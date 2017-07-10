//
//  CPHomeModel.h
//  CaiPiaoApp
//
//  Created by wxc on 10/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol CPHomeResultModel<NSObject>

@end


@interface  CPHomeResultModel  : JSONModel

@property (nonatomic, copy, nullable)   NSString * caipiaoid;
@property (nonatomic, copy, nullable)   NSString * name;
@property (nonatomic, copy, nullable)   NSString * parentid;

@end


@interface  CPHomeModel  : JSONModel

@property (nonatomic, copy, nullable)   NSString * status;
@property (nonatomic, copy, nullable)   NSString * msg;
@property (nonatomic, strong, nullable) NSArray<CPHomeResultModel> * result;

@end
