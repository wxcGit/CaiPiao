//
//  CPNewsModel.h
//  CaiPiaoApp
//
//  Created by wxc on 13/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CPNewsResultListModel<NSObject>

@end


@interface  CPNewsResultListModel  : JSONModel

@property (nonatomic, copy, nullable)   NSString * category;
@property (nonatomic, copy, nullable)   NSString * src;
@property (nonatomic, copy, nullable)   NSString * weburl;
@property (nonatomic, copy, nullable)   NSString * title;
@property (nonatomic, copy, nullable)   NSString * url;
@property (nonatomic, copy, nullable)   NSString * pic;
@property (nonatomic, copy, nullable)   NSString * content;
@property (nonatomic, copy, nullable)   NSString * time;

@end


@interface  CPNewsResultModel  : JSONModel

@property (nonatomic, copy, nullable)   NSString * num;
@property (nonatomic, strong, nullable) NSArray<CPNewsResultListModel> * list;
@property (nonatomic, copy, nullable)   NSString * keyword;

@end


@interface  CPNewsModel  : JSONModel

@property (nonatomic, copy, nullable)   NSString * status;
@property (nonatomic, copy, nullable)   NSString * msg;
@property (nonatomic, strong, nullable) CPNewsResultModel * result ;

@end
