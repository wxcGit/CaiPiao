//
//  CPMapViewController.m
//  CaiPiaoApp
//
//  Created by wxc on 13/7/17.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "CPMapViewController.h"
#import <BaiduMapAPI/BMKMapView.h>
#import <BaiduMapAPI/BMKLocationService.h>

@interface CPMapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *service;
@property (nonatomic, strong) BMKUserLocation *currentLocation;

@end

@implementation CPMapViewController

- (void)viewDidLoad {
    self.customBackItem = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mapView];
    [self startLocation];
}

- (BMKMapView*)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT)];
        _mapView.showsUserLocation = YES;
    }
    
    return _mapView;
}

- (void)startLocation
{
    _service = [[BMKLocationService alloc]init];
    _service.delegate = self;
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    _currentLocation = userLocation;
    [_mapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _currentLocation = userLocation;
    [_mapView updateLocationData:userLocation];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [_service startUserLocationService];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
