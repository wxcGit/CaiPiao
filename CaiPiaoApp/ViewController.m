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
}

- (void)initTabItem{
    
    TKTabControllerItem *rollViewItem = [[TKTabControllerItem alloc] initWithControllerName:@"CSRollViewController" title:@"Telegraph" tabImageName:@"tab_live_normal" selectedImageName:@"tab_live_selected"];
    
    TKTabControllerItem *consultViewItem = [[TKTabControllerItem alloc] initWithControllerName:@"CSConsultViewController" title:@"Read" tabImageName:@"tab_ref_normal" selectedImageName:@"tab_ref_selected"];

    TKTabControllerItem *marketViewItem = [[TKTabControllerItem alloc] initWithControllerName:@"CSMarketViewController" title:@"Markets" tabImageName:@"tab_market_normal" selectedImageName:@"tab_market_selected"];

    TKTabControllerItem *moreViewItem = [[TKTabControllerItem alloc] initWithControllerName:@"CSMyCenterViewController" title:@"Me" tabImageName:@"tab_me_normal" selectedImageName:@"tab_me_selected"];
    
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
