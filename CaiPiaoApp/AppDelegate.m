//
//  AppDelegate.m
//  CaiPiaoApp
//
//  Created by 王学超 on 2017/7/8.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import <UMeng/MobClick.h>
#import "ViewController.h"
#import "H5ViewController.h"
#import <SVProgressHUD.h>
#import <BaiduMapAPI/BMKMapManager.h>

#define KBmobKey @"a2fab2b62bf31a1e065eccb01107da46"
#define kUmengAppKey    @"59436cbcb27b0a4fee0004fa"
#define kJPushAppKey    @"81406cba25cbb69255e6ade3"
#define kJPushChannel @"http://read.mhxzhkl.com"

#define kBaiduMapKey @"gOYxLT0lGunKGSSPaCLvyDA7UvUGtE3i"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, strong) BMKMapManager *mapManeger;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self regitsterAll:launchOptions];
    //配置rooterView
    
    ViewController * tabbarVC = [[ViewController alloc] init];
    self.window.rootViewController = tabbarVC;
//    [self setupRootVc];
    return YES;
}

- (void)setupRootVc
{
    NSString *show = [[NSUserDefaults standardUserDefaults]objectForKey:BMOB_SHOW];
    if ([show isEqualToString:@"YES"]) {
        H5ViewController * h5VC = [[H5ViewController alloc] init];
        self.window.rootViewController = h5VC;
    }else{
        [self bmobWithShow];
    }
    
    [self.window makeKeyAndVisible];
}

-(void )bmobWithShow
{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Config"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    __weak typeof(self) weakSelf = self;
    [bquery getObjectInBackgroundWithId:@"yUO8cccx" block:^(BmobObject *object,NSError *error){
        [SVProgressHUD dismiss];
        if (error || object == nil){
            //进行错误处理
            ViewController * tabbarVC = [[ViewController alloc] init];
            weakSelf.window.rootViewController = tabbarVC;
        }else{
            NSString * url = [object objectForKey:@"url"];
            NSString * show = [object objectForKey:@"show"];
            if ([show isEqualToString:@"YES"]) {
                H5ViewController * tabbarVC = [[H5ViewController alloc] init];
                weakSelf.window.rootViewController = tabbarVC;
            }else{
                ViewController * tabbarVC = [[ViewController alloc] init];
                weakSelf.window.rootViewController = tabbarVC;
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:show forKey:BMOB_SHOW];
            [[NSUserDefaults standardUserDefaults] setObject:url forKey:BMOB_URL];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }];
    
}


- (void)regitsterAll:(NSDictionary *)launchOptions
{
    //Bmob注册
    [Bmob registerWithAppKey:KBmobKey];
    
    //极光推送
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey channel:kJPushChannel apsForProduction:YES];
    
    //友盟
    [MobClick startWithAppkey:kUmengAppKey];
    [MobClick updateOnlineConfig];
    
    _mapManeger = [[BMKMapManager alloc]init];
    [_mapManeger start:kBaiduMapKey generalDelegate:nil];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (application.applicationIconBadgeNumber>0) {//badge number 不为0，说明程序有那个圈圈图标
        NSLog(@"我可能收到了推送");
        //这里进行有关处理
        [application setApplicationIconBadgeNumber:0];//将图标清零。
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
