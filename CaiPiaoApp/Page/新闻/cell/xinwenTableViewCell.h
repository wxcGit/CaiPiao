//
//  xinwenTableViewCell.h
//  zhanzhan
//
//  Created by 辛书亮 on 2017/7/11.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xinwenModel.h"
@interface xinwenTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)setValueWithModel:(xinwenModel *)model;
@end
