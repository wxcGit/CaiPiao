//
//  CPBaseViewController.m
//  CaiPiaoApp
//
//  Created by wxc on 10/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "CPBaseViewController.h"
#import "FANetworkErrorView.h"

@interface CPBaseViewController ()

@property (nonatomic, strong) FANetworkErrorView *errorView;

@end

@implementation CPBaseViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _customRefreshTip = YES;
        _customBackItem = YES;
        self.pageName = @"";
        _pagedurationLog = YES;
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.customRefreshTip = YES;
    _customBackItem = YES;
    _pagedurationLog = YES;
}

- (BOOL) isNavigationBarRed
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    // 移除重复的页面
    //
    if ([self respondsToSelector:@selector(isDuplicateOf:)]) {
        NSMutableArray *viewControllers = [[self.navigationController viewControllers] mutableCopy];
        BOOL duplicateControllerRemoved = NO;
        for (NSInteger index = [viewControllers count] - 2; index >= 0; index--) {
            if ([self isDuplicateOf:[viewControllers objectAtIndex:index]]) {
                [viewControllers removeObjectAtIndex:index];
                duplicateControllerRemoved = YES;
            }
        }
        if (duplicateControllerRemoved) {
            self.navigationController.viewControllers = viewControllers;
        }
    }
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = false;
    self.automaticallyAdjustsScrollViewInsets = false;
    //    [self addNightModelObserve];
    if (_customBackItem) {
        [self initBackItem];
    }
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor backGroundColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.view addSubview:self.errorView];
}

- (FANetworkErrorView*)errorView
{
    if (!_errorView) {
        _errorView = [[FANetworkErrorView alloc]init];
        _errorView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _errorView.tryAgainBlock = ^{
            [weakSelf tryNetRequestAgain];
        };
    }
    
    return _errorView;
}

/**
 显示隐藏网络错误提示
 */
- (void)showNetErrorView
{
    [self.view bringSubviewToFront:_errorView];
    _errorView.hidden = NO;
}
- (void)hiddenNetErrorView
{
    _errorView.hidden = YES;
}

/**
 点击重试
 */
-(void)tryNetRequestAgain
{
    
}

-(void)initBackItem
{
    UIBarButtonItem *backItem = [UIBarButtonItem defaultLeftItemWithTarget:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
