//
//  xinwenViewController.m
//  zhanzhan
//
//  Created by 辛书亮 on 2017/7/11.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "CPXinwenViewController.h"
#import "xinwenModel.h"
#import "xinwenTableViewCell.h"
#import "xinwenWebViewController.h"

#import "tishiXiaoShiViewController.h"
#define xinwenHttp @"http://api.jisuapi.com/news/search?appkey=3bc704584b4f096b"

@interface CPXinwenViewController ()

@property (nonatomic, strong) NSMutableArray *updataArray;
@property (nonatomic, strong) NSMutableDictionary *updateParms;

@end

@implementation CPXinwenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //下拉刷新
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) wself = self;
    [self addHeaderRefreshView:self.tableView callBack:^{
        [wself loadNewTopic];
    }];
    
    //上拉刷新
    [self addFooterRefreshView:self.tableView callBack:^{
        [wself loadMoreTopic];
    }];
    
    //自动更改透明度
    self.updataArray = [NSMutableArray array];
    [self getdata];

}

//刷新
-(void)loadNewTopic
{
    self.updataArray = [NSMutableArray array];
    [self getdata];
}
//加载更多
-(void)loadMoreTopic
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //结束尾部刷新
        __weak typeof(self) wself = self;
        [wself stopRefresh:wself.tableView];
    });
}
#pragma mark 网络请求
-(void)getdata
{
    //    model = [[MineModel alloc]init];
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:@"彩票" forKey:@"keyword"];
    [IWHttpTool getWithURL:xinwenHttp params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSArray * array = [[dic objectForKey:@"result"] objectForKey:@"list"];
        for (int i = 0 ; i < array.count ; i ++) {
            xinwenModel * model = [[xinwenModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [self.updataArray addObject:model];
        }
        NSLog(@"%@",dic);
        //结束头部刷新
        [self.GatoTableview.mj_header endRefreshing];
        //结束尾部刷新
        [self.GatoTableview.mj_footer endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.updataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    xinwenTableViewCell * cell = [xinwenTableViewCell cellWithTableView:tableView];
    xinwenModel * model = [[xinwenModel alloc]init];
    model = self.updataArray[indexPath.row];
    [cell setValueWithModel:model];
    return cell;
//    Gato_tableviewcell_new
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    xinwenWebViewController * vc = [[xinwenWebViewController alloc]init];
    xinwenModel * model = [[xinwenModel alloc]init];
    model = self.updataArray[indexPath.row];
    vc.model = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
