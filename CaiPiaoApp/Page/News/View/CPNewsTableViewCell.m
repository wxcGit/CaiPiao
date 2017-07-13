//
//  CPNewsTableViewCell.m
//  CaiPiaoApp
//
//  Created by wxc on 13/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "CPNewsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CPNewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CPNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(CPNewsResultListModel *)model
{
    if ([model.pic hasPrefix:@"http"] && ![model.pic hasPrefix:@"https"]) {
        NSMutableString *string = [NSMutableString stringWithString:model.pic];
        [string insertString:@"s" atIndex:4];
        model.pic = string;
    }
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    _titleLabel.text = model.title;
    _detailLabel.text = model.src;
    _timeLabel.text = model.time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
