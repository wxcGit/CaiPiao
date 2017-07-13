//
//  TKRequestHandler+News.h
//  CaiPiaoApp
//
//  Created by wxc on 13/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "TKRequestHandler.h"
#import "CPNewsModel.h"

@interface TKRequestHandler (News)

- (NSURLSessionDataTask*)getNewsDatafinish:(void (^)(NSURLSessionDataTask *sessionDataTask, CPNewsModel *model , NSError *error))finish;

@end
