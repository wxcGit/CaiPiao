//
//  TKRequestHandler+Home.h
//  CaiPiaoApp
//
//  Created by wxc on 10/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKRequestHandler.h"
#import "CPHomeModel.h"

@interface TKRequestHandler (Home)

- (NSURLSessionDataTask*)getHomeDatafinish:(void (^)(NSURLSessionDataTask *, CPHomeModel *, NSError *))finish;

@end
