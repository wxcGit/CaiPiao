//
//  CPNewsViewController.m
//  CaiPiaoApp
//
//  Created by wxc on 13/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "CPNewsViewController.h"
#import "TKRequestHandler+News.h"
#import "CPNewsTableViewCell.h"
#import "TKModuleWebViewController.h"

@interface CPNewsViewController ()

@property (nonatomic, strong) NSMutableArray *newsArray;

@end

@implementation CPNewsViewController

- (void)viewDidLoad {
    self.customBackItem = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self loadData:YES];
}

- (void)setupUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"CPNewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CPNewsTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) wSelf = self;
    [self addHeaderRefreshView:self.tableView callBack:^{
        [wSelf loadData:YES];
    }];
    
    [self addFooterRefreshView:self.tableView callBack:^{
        [wSelf loadData:NO];
    }];
}

- (void)loadData:(BOOL)isRefresh
{
    __weak typeof(self) wSelf = self;
    [[TKRequestHandler sharedInstance]getNewsDatafinish:^(NSURLSessionDataTask *sessionDataTask, CPNewsModel *model, NSError *error) {
        [wSelf stopRefresh:wSelf.tableView];
        if (!error) {
            if (isRefresh) {
                wSelf.newsArray = [NSMutableArray arrayWithArray:model.result.list];
            }else{
                [wSelf.newsArray addObjectsFromArray:model.result.list];
            }
            [wSelf.tableView reloadData];
        }
    }];
}

#pragma mark TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CPNewsTableViewCell"];
    cell.model = _newsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPNewsResultListModel *model = _newsArray[indexPath.row];
    
    TKModuleWebViewController *web = [[TKModuleWebViewController alloc]init];
    web.model = model;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
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
