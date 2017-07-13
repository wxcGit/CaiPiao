//
//  FANetworkErrorView.h
//  FunApp
//
//  Created by wxc on 3/7/17.
//  Copyright © 2017年 Wandu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FANetworkErrorView : UIView

@property (nonatomic, copy) void (^tryAgainBlock)();

@end
