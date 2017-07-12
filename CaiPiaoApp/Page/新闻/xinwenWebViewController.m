//
//  xinwenWebViewController.m
//  zhanzhan
//
//  Created by 辛书亮 on 2017/7/11.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "xinwenWebViewController.h"
#import "GatoBaseHelp.h"
@interface xinwenWebViewController ()<UIWebViewDelegate>
@property (nonatomic ,strong) UIWebView * webView;
@property (nonatomic ,strong) NSString * webString;

@end

@implementation xinwenWebViewController

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
        _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, Gato_Width, Gato_Height)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
        
    }
    return _webView;
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
