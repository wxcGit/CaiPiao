//
//  TKRequestHandler+News.m
//  CaiPiaoApp
//
//  Created by wxc on 13/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "TKRequestHandler+News.h"

#define HTTP_News @"https://api.jisuapi.com/news/search?appkey=3bc704584b4f096b"
@implementation TKRequestHandler (News)

- (NSURLSessionDataTask*)getNewsDatafinish:(void (^)(NSURLSessionDataTask *sessionDataTask, CPNewsModel *model , NSError *error))finish
{
    NSDictionary *dic = @{@"keyword":@"彩票"};
    return [self getRequestForPath:HTTP_News param:dic jsonName:@"CPNewsModel" finish:^(NSURLSessionDataTask * _Nonnull sessionDataTask, JSONModel * _Nullable model, NSError * _Nullable error) {
        if (finish) {
            finish(sessionDataTask, (CPNewsModel*)model, error);
        }
    }];
}

@end
