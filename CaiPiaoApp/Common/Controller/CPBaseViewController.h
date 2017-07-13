//
//  CPBaseViewController.h
//  CaiPiaoApp
//
//  Created by wxc on 10/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Refresh.h"

@interface CPBaseViewController : UIViewController

/**
 *  是否定制导航栏返回返回
 *  默认是yes
 */
@property(nonatomic , assign) BOOL customBackItem;

//是否定制刷新提示 默认yes
@property (nonatomic, assign) BOOL customRefreshTip;

@property (nonatomic, copy) NSString *pageName;

//是否进行页面时长统计
@property (nonatomic, assign) BOOL pagedurationLog;

-(BOOL) isNavigationBarRed;

- (BOOL) isDuplicateOf:(UIViewController *)viewController;
/**
 *  点击导航栏返回是调用的方法
 */
-(void)backAction;

//-(void)initNavbarTitle;
- (void)addRightButtonWithTitle:(NSString *)title;

-(BOOL)checkLogin;

//显示置顶按钮
- (void)showTopButtonToScrollView:(UIScrollView*)scrollView;

// 后台进入前台
-(void)enterForeground;


/**
 显示隐藏网络错误提示
 */
- (void)showNetErrorView;
- (void)hiddenNetErrorView;

/**
 点击重试
 */
-(void)tryNetRequestAgain;

@end
