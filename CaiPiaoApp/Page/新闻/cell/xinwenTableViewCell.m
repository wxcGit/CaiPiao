//
//  xinwenTableViewCell.m
//  zhanzhan
//
//  Created by 辛书亮 on 2017/7/11.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "xinwenTableViewCell.h"
#import "GatoBaseHelp.h"

@interface xinwenTableViewCell()
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) UILabel * time;
@property (nonatomic ,strong) UILabel * come;
@end
@implementation xinwenTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"xinwenTableViewCell";
    xinwenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"xinwenTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setValueWithModel:(xinwenModel *)model
{
    if (model.pic.length > 0) {
        [self allFrame];
        [self.photo sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@""]];
    }else{
        [self titleFrame];
    }
    self.name.text = model.title;
    self.time.text = model.time;
    self.come.text = model.src;
}

-(void)titleFrame
{
    self.photo.sd_layout.leftSpaceToView(self, 15)
    .topSpaceToView(self, 10)
    .widthIs(75)
    .heightIs(60);
    self.photo.hidden = YES;
    
    self.name.sd_layout.leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .topSpaceToView(self, 10)
    .heightIs(40);
    
    self.time.sd_layout.leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .topSpaceToView(self.name, 5)
    .heightIs(20);
    
    self.come.sd_layout.leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .topSpaceToView(self.name, 5)
    .heightIs(20);
}
-(void)allFrame
{
    self.photo.hidden = NO;
    
    self.photo.sd_layout.leftSpaceToView(self, 15)
    .topSpaceToView(self, 10)
    .widthIs(75)
    .heightIs(60);
    
    self.name.sd_layout.leftSpaceToView(self.photo, 10)
    .rightSpaceToView(self, 15)
    .topSpaceToView(self, 10)
    .heightIs(40);
    
    self.time.sd_layout.leftEqualToView(self.name)
    .rightSpaceToView(self, 15)
    .topSpaceToView(self.name, 5)
    .heightIs(20);
    
    self.come.sd_layout.leftEqualToView(self.name)
    .rightSpaceToView(self, 15)
    .topSpaceToView(self.name, 5)
    .heightIs(20);
}
-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        [self addSubview:_photo];
    }
    return _photo;
}
-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.font = FONT(30);
        _name.numberOfLines = 2;
        [self addSubview:_name];
    }
    return _name;
}
-(UILabel *)time
{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.textColor = [UIColor appTabBarTitleColor];
        _time.font = FONT(26);
        _time.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_time];
    }
    return _time;
}
-(UILabel *)come
{
    if (!_come) {
        _come = [[UILabel alloc]init];
        _come.textAlignment = NSTextAlignmentRight;
        _come.font = FONT(26);
        _come.textColor = [UIColor appTabBarTitleColor];
        [self addSubview:_come];
    }
    return _come;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .heightIs(1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
