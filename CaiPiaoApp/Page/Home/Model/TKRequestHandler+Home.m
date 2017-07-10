//
//  TKRequestHandler+Home.m
//  CaiPiaoApp
//
//  Created by wxc on 10/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "TKRequestHandler+Home.h"

#define HTTP_Home @"http://api.jisuapi.com/caipiao/class?appkey=3bc704584b4f096b"

@implementation TKRequestHandler (Home)

- (NSURLSessionDataTask*)getHomeDatafinish:(void (^)(NSURLSessionDataTask *, CPHomeModel *, NSError *))finish
{
    return [self getRequestForPath:HTTP_Home param:nil jsonName:@"CPHomeModel" finish:^(NSURLSessionDataTask * _Nonnull sessionDataTask, JSONModel * _Nullable model, NSError * _Nullable error) {
        if (finish) {
            finish(sessionDataTask, (CPHomeModel*)model, error);
        }
    }];
}

@end
