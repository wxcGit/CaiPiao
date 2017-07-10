//
//  FDNetworkManager.m
//  Find
//
//  Created by chunhui on 15/5/9.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import "TKNetworkManager.h"

#define TEST 0

@interface TKNetworkManager ()

@property(nonatomic , strong) AFHTTPSessionManager *sessionManager;

@property(nonatomic , strong) Reachability *reachability;

#if TEST

@property(nonatomic , assign) BOOL tokenTest;

#endif



@end

@implementation TKNetworkManager

+(TKNetworkManager *)sharedInstance
{
    static TKNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TKNetworkManager alloc] init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanageNotification:) name:kReachabilityChangedNotification object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
            [_reachability startNotifier];
        });
        
#if TEST
      
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenTestNotification:) name:@"tokenTestNotification" object:nil];
        
        
#endif
        
    }
    return self;
}

-(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    _sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

-(NSTimeInterval)timeoutInterval
{
    return _sessionManager.requestSerializer.timeoutInterval;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(NSDictionary *)chageResponseToDictWithUrl:(NSString *)url response:(id)response
{
    
#if TEST
    
    if (_tokenTest) {
        NSMutableDictionary *mdict = [[NSMutableDictionary alloc]init];
        mdict[@"errno"] = @"20002";
        mdict[@"time"] = @1453361583;
        mdict[@"msg"] = @"token失效:10006";

        return mdict;
    }
    
#endif
    
    
    if ([response isKindOfClass:[NSData class]]) {
        
        @try {
            NSError *error = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
            if (error) {
                [self.delegate jsonParseFailedWithUrl:url response:response];
                NSString *content = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                NSLog(@"response is: %@ \n json error is: %@\n",content,error);
                
            }
            
            return dict;
        }
        @catch (NSException *exception) {
            [self.delegate jsonParseFailedWithUrl:url response:response];
#if DEBUG
            NSLog(@"change respose failed :\n%@\n",exception);
            NSArray *callstack = [NSThread callStackSymbols];
            NSLog(@"call tree is:\n%@\n",callstack);
#endif
        }

    }
    return response;
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [_sessionManager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        responseObject = [self chageResponseToDictWithUrl:URLString response:responseObject];
        [self handleResponse:responseObject];
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure(task , error);
        }
    }];
    
}


- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [_sessionManager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        responseObject = [self chageResponseToDictWithUrl:URLString response:responseObject];
        [self handleResponse:responseObject];
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure(task , error);
        }
    }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [_sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        responseObject = [self chageResponseToDictWithUrl:URLString response:responseObject];
        [self handleResponse:responseObject];
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

-(nullable NSURLSessionDataTask *)download:(NSString *)URLString
                                  progress:(NSProgress * __nullable __autoreleasing * __nullable)progress
                               destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                         completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * __nullable filePath, NSError * __nullable error))completionHandler
{
    NSURL *url = [NSURL URLWithString:URLString];
    if (url == nil) {
        return  nil;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];    
    NSURLSessionDownloadTask *task = [_sessionManager downloadTaskWithRequest:request progress:nil destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response , filePath , error);
        }
    }];
    
    [task resume];
    
    return task;
    
}


-(BOOL)handleResponse:(NSDictionary *)response
{
    NSInteger errNum = 0;
    if ([response isKindOfClass:[NSDictionary class]]) {
        errNum = [[response objectForKey:@"errno"] integerValue];
        if (errNum == 10007) {
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *url = [NSURL URLWithString:@"wandu://login"];
            NSDictionary *options = [[NSDictionary alloc] init];
            [[application delegate] application:application openURL:url options:options];
        }
        if (errNum != 0 && [_delegate respondsToSelector:@selector(checkError:responseData:)]) {
            [_delegate checkError:errNum responseData:response];
        }
    }
    
    return errNum == 0;
}

#if TEST

-(void)tokenTestNotification:(NSNotification *)notification
{
    _tokenTest = YES;
}

#endif

#pragma mark - net check

-(void)startNotifier
{
    [_reachability startNotifier];
}

-(void)stopNotifier
{
    [_reachability stopNotifier];
}

-(BOOL)networkReachable
{
    if (_reachability) {
        NetworkStatus status =  [_reachability currentReachabilityStatus];
        return status != NotReachable;
    }
    return YES;
}

-(NetworkStatus)networkStatus
{
    return [_reachability currentReachabilityStatus];
}


-(void)reachabilityChanageNotification:(NSNotification *)notification
{
    NSDictionary *statusInfo = @{@"status":@([_reachability currentReachabilityStatus])};
    [[NSNotificationCenter defaultCenter]postNotificationName:kTKNetworkChangeNotification object:nil userInfo:statusInfo];
}

NSString *kTKNetworkChangeNotification = @"_kTKNetworkChangeNotification";

@end
