//
//  ViewController.m
//  CaiPiaoApp
//
//  Created by 王学超 on 2017/7/8.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "ViewController.h"
#import "TKTabControllerIniter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabItem];
    
    self.tabBar.barTintColor = [UIColor whiteColor];
}

- (void)initTabItem{
    
    TKTabControllerItem *rollViewItem = [[TKTabControllerItem alloc] initWithControllerName:@"CPHomeViewController" title:@"首页" tabImageName:@"home_nor" selectedImageName:@"home_sel"];
    
    TKTabControllerItem *consultViewItem = [[TKTabControllerItem alloc] initWithControllerName:@"CPNewsViewController" title:@"资讯" tabImageName:@"reward_nor" selectedImageName:@"reward_sel"];

    TKTabControllerItem *marketViewItem = [[TKTabControllerItem alloc] initWithControllerName:@"CPMapViewController" title:@"附近" tabImageName:@"search_nor" selectedImageName:@"search_sel"];

    TKTabControllerItem *moreViewItem = [[TKTabControllerItem alloc] initWithControllerName:@"CPBaseViewController" title:@"我的" tabImageName:@"min_nor" selectedImageName:@"min_sel"];
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:rollViewItem,consultViewItem,marketViewItem,moreViewItem, nil];
    
    for (TKTabControllerItem *item in items) {
        item.addNavController = YES;
        item.titleNormalColor = [UIColor tabNormalColor];
        item.titleSelectedColor = [UIColor tabSelectColor];
        item.navContorllerName = @"CPNavigationController";
    }
    
    NSArray *controllers = [TKTabControllerIniter viewControllersWithItems:items];
    
    self.viewControllers = controllers;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
