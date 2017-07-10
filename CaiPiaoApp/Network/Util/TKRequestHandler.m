//
//  TKRequestHandler.m
//  ToolKit
//
//  Created by chunhui on 15/10/9.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "TKRequestHandler.h"
#import "JSONModel.h"
#import "TKNetworkManager.h"
#import "TKHttpParameter.h"

@interface TKRequestHandler ()<TKNetworkManagerDelegate>

-(NSDictionary *)addExterParam:(NSDictionary *)param;

@end

@implementation TKRequestHandler

/**
 *  单例对象
 *
 *  @return 单例
 */
+(TKRequestHandler *)sharedInstance
{
    static TKRequestHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[TKRequestHandler alloc]init];
    });
    return handler;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        [TKNetworkManager sharedInstance].delegate = self;
        
    }
    return self;
}

-(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    [TKNetworkManager sharedInstance].timeoutInterval = timeoutInterval;
}

-(NSTimeInterval)timeoutInterval
{
    return [TKNetworkManager sharedInstance].timeoutInterval;
}

-(NSString *)requestUrlForPath:(NSString *)path
{
    if([path hasPrefix:@"http"]){
        //完整的url
        return path;
    }
    
    NSMutableString *url = [[NSMutableString alloc]init];
    if (_host.length == 0) {
        NSAssert(false, @"TKRequest handler must  set host");
    }
    [url appendString:self.host];
    if (path.length > 0) {
        if (![path hasPrefix:@"/"]) {
            [url appendString:@"/"];
        }
        [url appendString:path];
    }
    return url;
}

-(NSDictionary *)addExterParam:(NSDictionary *)param
{
    TKHttpParameter *paramter = [[TKHttpParameter alloc]init];
    paramter.codeSignBlock = self.codeSignBlock;
    if (self.extraInfoBlock) {
        NSDictionary *userInfoDict = self.extraInfoBlock();
        if (userInfoDict) {
            [paramter addKeyValueDict:userInfoDict];
        }
    }
    [paramter addKeyValueDict:param];
    if (self.baseParam) {
        [paramter addKeyValueDict:self.baseParam];
    }
    
    return [paramter build];
}

-(NSURLSessionDataTask *)getRequestForPath:(NSString *)path param:(NSDictionary *)param jsonName:(NSString *)jsonName finish:(void (^)(NSURLSessionDataTask *sessionDataTask, JSONModel *model , NSError *error))finish
{    
    NSAssert(path.length > 0 && jsonName.length > 0, @"request path and json name must set");
    return [self getRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        JSONModel *model = nil;
        NSDictionary *responseObject = response;
        
        if (responseObject) {
            Class clazz = NSClassFromString(jsonName);
            NSError *error = nil;
            model = [[clazz alloc] initWithDictionary:responseObject error:&error];
            if (error) {
                NSLog(@"error is: %@\n\n",error);
            }
        }
        
        if (model == nil && error == nil ){
            //服务端问题
            error = [NSError errorWithDomain:kRequestFailedTip code:-10000 userInfo:nil];
        }
        
        if ([[responseObject valueForKey:@"errno"] integerValue] == 10007) {
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *url = [NSURL URLWithString:@"wandu://login"];
            NSDictionary *options = [[NSDictionary alloc] init];
            [[application delegate] application:application openURL:url options:options];
        }

        if (finish) {
            finish(sessionDataTask, model,error);
        }
    }];
}

-(NSURLSessionDataTask *)postRequestForPath:(NSString *)path param:(NSDictionary *)param jsonName:(NSString *)jsonName finish:(void (^)(NSURLSessionDataTask *sessionDataTask, JSONModel *model , NSError *error))finish
{
    NSAssert(path.length > 0 && jsonName.length > 0, @"request path and json name must set");
    
    return [self postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        
        JSONModel *model = nil;
        NSDictionary *responseObject = response;
        if (responseObject) {
            Class clazz = NSClassFromString(jsonName);
            model = [[clazz alloc]initWithDictionary:responseObject error:nil];
        }
        if (model == nil && error == nil ){
            //服务端问题
            error = [NSError errorWithDomain:kRequestFailedTip code:-10000 userInfo:nil];
        }
        
        if (finish) {
            finish(sessionDataTask, model, error);
        }
    }];
    
}


-(NSURLSessionDataTask *)postRequestForPath:(NSString *)path param:(NSDictionary *)param jsonName:(NSString *)jsonName formData:(void (^)(id <AFMultipartFormData> formData))block finish:(void (^)(NSURLSessionDataTask *sessionDataTask, JSONModel *model , NSError *error))finish
{
    NSAssert(path.length > 0 , @"request path and json name must set");
    return [self postRequestForPath:path param:param formData:^(id<AFMultipartFormData> formData) {
        if (block) {
            block(formData);
        }
    } finish:^(NSURLSessionDataTask *sessionDataTask, id responseObject, NSError *error) {
        
        JSONModel *model = nil;
        if (responseObject) {
            Class clazz = NSClassFromString(jsonName);
            model = [[clazz alloc]initWithDictionary:responseObject error:nil];
        }
        
        if (model == nil && error == nil ){
            //服务端问题
            error = [NSError errorWithDomain:@"请求失败" code:0 userInfo:nil];
        }
        
        if (finish) {
            finish(sessionDataTask, model, error);
        }
    }];
    
}

/**
 *  下载文件
 *
 *  @param path     文件url
 *  @param progress 进度
 *  @param finish   完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)downloadFile:(NSString *)path progress:(void(^)(CGFloat progress))progress targetPath:(NSURL *)destinationPath finish:(void (^)(NSURLSessionDataTask *sessionDataTask, NSString *path , NSError *error))finish
{
    
    NSProgress *progressbar = nil;
    NSURLSessionDataTask *task = [[TKNetworkManager sharedInstance]download:path progress:&progressbar destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return destinationPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        finish(task , filePath , error );
        
    }];
    return task;
    
}
/**
 *  下载文件
 *
 *  @param path   文件地址
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)downloadFile:(NSString *)path  finish:(void (^)(NSURLSessionDataTask *sessionDataTask,  NSString *downloadPath , NSError *error))finish
{
    if(path.length == 0){
        return nil;
    }
    
    NSString *tempName = [NSString stringWithFormat:@"tmp_%.0f.dat",[[NSDate date] timeIntervalSince1970]*100];
    NSString *downPath = [NSTemporaryDirectory() stringByAppendingPathComponent:tempName];
    
    NSURLSessionDataTask *task = [[TKNetworkManager sharedInstance] download:path progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSString *path  = nil;
        if (filePath) {
            path = [NSString stringWithUTF8String:[filePath fileSystemRepresentation]];
        }                
        finish(task , path , error);
    }];
    
    return task;
    
}


/**
 *  通用get请求
 *
 *  @param path   请求的路径
 *  @param param  请求的参数
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getRequestForPath:(NSString *)path param:(NSDictionary *)param  finish:(void (^)(NSURLSessionDataTask *sessionDataTask, id response , NSError *error))finish
{
    NSAssert(path.length > 0 , @"request path and json name must set");
    return [[TKNetworkManager sharedInstance] GET:[self requestUrlForPath:path] parameters:[self addExterParam:param] success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSError *error = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            @try {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            }
            @catch (NSException *exception) {
                [self.delegate jsonParseFailedWithUrl:path response:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                responseObject = nil;
            }
        }
        //处理返回结果的错误代码到error中
        if (error == nil && responseObject) {
            error = [self handleErrorWithResponse:responseObject];
        }
        
        if (finish) {
            finish(operation, responseObject,error);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (finish) {
            error = [self  convertError:error];
            finish(operation, nil,error);
        }
    }];
}
/**
 *  通用post请求
 *
 *  @param path   请求的path
 *  @param param  请求的参数
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */

-(NSURLSessionDataTask *)postRequestForPath:(NSString *)path param:(NSDictionary *)param finish:(void (^)(NSURLSessionDataTask *sessionDataTask, id response , NSError *error))finish
{
    NSAssert(path.length > 0 , @"request path and json name must set");
    return [[TKNetworkManager sharedInstance] POST:[self requestUrlForPath:path] parameters:[self addExterParam:param] success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSError *error = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            @try {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            }
            @catch (NSException *exception) {
                [self.delegate jsonParseFailedWithUrl:path response:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                
                responseObject = nil;
            }
        }
        
        if(error == nil && responseObject){
            error =  [self handleErrorWithResponse:responseObject];
        }
        
        if (finish) {
            finish(operation, responseObject,error);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (finish) {
            error = [self  convertError:error];
            finish(operation, nil,error);
        }
    }];
}

/**
 *  通用二进制post请求
 *
 *  @param path   请求path
 *  @param param  请求参数
 *  @param block  二进制构造block
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)postRequestForPath:(NSString *)path param:(NSDictionary *)param formData:(void (^)(id <AFMultipartFormData> formData))block finish:(void (^)(NSURLSessionDataTask *sessionDataTask, id response , NSError *error))finish
{
    NSAssert(path.length > 0 , @"request path and json name must set");
    
    return [[TKNetworkManager sharedInstance] POST:[self requestUrlForPath:path] parameters:[self addExterParam:param] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nullable formData) {
        block(formData);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            @try {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            }
            @catch (NSException *exception) {
                [self.delegate jsonParseFailedWithUrl:path response:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                
                responseObject = nil;
            }
        }
        
        if (error == nil && responseObject) {
            error = [self handleErrorWithResponse:responseObject];
        }        
        if (finish) {
            finish(task, responseObject, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (finish) {
            error = [self  convertError:error];
            finish(task, nil,error);
        }
    }];
}

/**
 *  判断并处理错误
 *
 *  @param errNo    错误number
 *  @param response 请求返回的数据
 */
-(void)checkError:(NSInteger)errNo responseData:(NSDictionary *)response
{
    if([_delegate respondsToSelector:@selector(checkError:responseData:)]){
        [_delegate checkError:errNo responseData:response];
    }
}


-(NSError *)convertError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(convertError:)]) {
        //使用代理的转换
        return [_delegate convertError:error];
    }
    //未设置delegate ,使用默认的
    NSError *err = nil;
    switch (error.code) {
        case kCFURLErrorNotConnectedToInternet:
        case kCFURLErrorUnknown:
        case kCFURLErrorTimedOut:
        case kCFURLErrorCannotConnectToHost:
        case kCFURLErrorResourceUnavailable:
        case kCFURLErrorNetworkConnectionLost:
        {
            err = [NSError errorWithDomain:kRequestNetErrorTip code:error.code userInfo:nil];
        }
            break;
            
        default:
            if (error.userInfo) {
                NSString *msg = error.userInfo[NSLocalizedRecoverySuggestionErrorKey];
                if (msg.length == 0) {
                    msg = error.userInfo[NSLocalizedFailureReasonErrorKey];
                }
                if (msg) {
                    error = [NSError errorWithDomain:msg code:error.code userInfo:error.userInfo];
                }else{
                    error = [NSError errorWithDomain:kRequestFailedTip code:error.code userInfo:error.userInfo];
                }
            }
            
            err = error;
            break;
    }
    
    
    return err;
}

- (NSError *)handleErrorWithResponse:(NSDictionary *)dic{
    
    NSError *error = nil;
    NSString *errNum = dic[@"errno"];
    if (errNum.integerValue != 0 ) {
        error = [NSError errorWithDomain:dic[@"errmsg"]?:kRequestFailedTip code:errNum.integerValue userInfo:nil];
    }
    
    return error;
}

- (void)jsonParseFailedWithUrl:(NSString *)url response:(NSString *)response {
    [self.delegate jsonParseFailedWithUrl:url response:response];
}

@end

NSString *kRequestNetErrorTip = @"请查看网络连接";
NSString *kRequestFailedTip   = @"网络请求异常";
