//
//  CPBaseTableViewController.m
//  CaiPiaoApp
//
//  Created by wxc on 10/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "CPBaseTableViewController.h"

@interface CPBaseTableViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CPBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor backGroundColor];
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
