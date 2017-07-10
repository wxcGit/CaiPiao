//
//  H5ViewController.m
//  SSC_Lottery
//
//  Created by 丰华财经 on 2017/6/15.
//  Copyright © 2017年 com.ly. All rights reserved.
//

#import "H5ViewController.h"
#import <SVProgressHUD.h>
#import <UMeng/MobClick.h>

#define kUrl @"http://app.shajilon.com/1.html"

@interface H5ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) UILabel *laughLabel;

@end

@implementation H5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * url = kUrl;
    if (Gato_Bmob_URL) {
        url = Gato_Bmob_URL;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
    _webView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)onlineConfigCallBack:(NSNotification *)notification {
    NSLog(@"online config has fininshed and params = %@", notification.userInfo);
    NSString *laughString = notification.userInfo[@"laugh"];
    if ([laughString isEqualToString:@"1"]) {
        [self.view.window addSubview:self.laughLabel];
    }
}

- (UILabel*)laughLabel
{
    if (!_laughLabel) {
        _laughLabel = [[UILabel alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _laughLabel.text = @"哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼哈哈,傻逼";
        _laughLabel.userInteractionEnabled = YES;
        _laughLabel.numberOfLines = 0;
    }
    
    return _laughLabel;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
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
