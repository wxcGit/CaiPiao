
//  TKModuleWebViewController.m
//  ToolKit
//
//  Created by chunhui on 15/7/28.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import "TKModuleWebViewController.h"

#define kRightButtonTag 10000
@interface TKModuleWebViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) NSString *url;
@property (nonatomic ,strong) UIWebView * webView;
@property (nonatomic ,strong) NSString * webString;

@end

@implementation TKModuleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.model) {
        self.title = self.model.title;
        self.webString = self.model.content;
        [self setValue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void )setValue
{
    [self.webView loadHTMLString:self.webString baseURL:nil];
    [self webViewDidFinishLoad:self.webView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 360;" // UIWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     //     "var httpP = \"http://webapi.houno.cn\"+imageArr[i].getAttribute(\"src\");"
     //     "imageArr[i].setAttribute(\"src\",httpP);"  // 遇到返回图片路径不是全路径的情况拼接，但没有成功！估计是加载先后顺序问题导致，这个方法走的时候已经加载完成。
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}

@end
