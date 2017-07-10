//
//  CPHomeViewController.m
//  CaiPiaoApp
//
//  Created by wxc on 10/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "CPHomeViewController.h"
#import "TKRequestHandler+Home.h"

@interface CPHomeViewController ()

@end

@implementation CPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)loadData
{
    __weak typeof(self) wSelf = self;
    [[TKRequestHandler sharedInstance]getHomeDatafinish:^(NSURLSessionDataTask * _Nonnull task, CPHomeModel * _Nullable model, NSError * _Nullable error) {
        [wSelf.tableView reloadData];
    }];
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