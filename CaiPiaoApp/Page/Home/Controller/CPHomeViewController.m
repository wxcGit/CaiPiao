//
//  CPHomeViewController.m
//  CaiPiaoApp
//
//  Created by wxc on 10/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "CPHomeViewController.h"
#import "TKRequestHandler+Home.h"
#import "CPNewsTableViewCell.h"

@interface CPHomeViewController ()

@end

@implementation CPHomeViewController

- (void)viewDidLoad {
    self.customBackItem = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    
    __weak typeof(self) wSelf = self;
    [self addHeaderRefreshView:self.tableView callBack:^{
        [wSelf loadData];
    }];
}

- (void)loadData
{
    __weak typeof(self) wSelf = self;
    [[TKRequestHandler sharedInstance]getHomeDatafinish:^(NSURLSessionDataTask * _Nonnull task, CPHomeModel * _Nullable model, NSError * _Nullable error) {
        [wSelf stopRefresh:wSelf.tableView];
        [wSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
