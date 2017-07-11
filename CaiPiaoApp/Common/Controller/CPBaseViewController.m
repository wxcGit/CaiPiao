//
//  CPBaseViewController.m
//  CaiPiaoApp
//
//  Created by wxc on 10/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "CPBaseViewController.h"

@interface CPBaseViewController ()

@end

@implementation CPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor backGroundColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
