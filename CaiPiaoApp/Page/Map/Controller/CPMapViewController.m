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
#import <BaiduMapAPI/BMKPoiSearch.h>
#import <BaiduMapAPI/BMKPointAnnotation.h>
#import <BaiduMapAPI/BMKGeoCodeSearch.h>

@interface CPMapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *service;
@property (nonatomic, strong) BMKUserLocation *currentLocation;
@property (nonatomic, strong) BMKPoiSearch *search;

@end

@implementation CPMapViewController

- (void)viewDidLoad {
    self.customBackItem = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mapView];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatItemWithTarget:self action:@selector(rightAction) title:@"彩票站"];
    [self startLocation];
}

- (BMKMapView*)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT)];
        _mapView.showsUserLocation = YES;
        [_mapView setMapType:BMKMapTypeStandard];
        [_mapView setZoomLevel:16];
        _mapView.isSelectedAnnotationViewFront = YES;
    }
    
    return _mapView;
}

- (BMKPoiSearch*)search
{
    if (!_search) {
        _search = [[BMKPoiSearch alloc]init];
        _search.delegate = self;
    }
    
    return _search;
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
    [self updateLocation:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self updateLocation:userLocation];
}

- (void)updateLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D currentCenterCoor = _currentLocation.location.coordinate;
    CLLocationCoordinate2D centerCoor = userLocation.location.coordinate;
    
    if (currentCenterCoor.latitude != centerCoor.latitude || currentCenterCoor.longitude != centerCoor.longitude) {
        _currentLocation = userLocation;
        [_mapView updateLocationData:userLocation];
        _mapView.centerCoordinate = centerCoor;
    }
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

- (void)rightAction
{
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.location = _currentLocation.location.coordinate;
    option.radius = 1000000;
    option.keyword = @"彩票";
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    [self.search poiSearchNearBy:option];
}

/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        //在此处理正常结果
        for (int i = 0; i < poiResult.poiInfoList.count; i++)
        {
            BMKPoiInfo* poi = [poiResult.poiInfoList objectAtIndex:i];
            [self addAnimatedAnnotationWithName:poi.name withAddress:poi.pt];
            
            //逆地理编码
            BMKGeoCodeSearch *_geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
            _geoCodeSearch.delegate = self;
            //初始化逆地理编码类
            BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
            //需要逆地理编码的坐标位置
            reverseGeoCodeOption.reverseGeoPoint = poi.pt;
            [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
        }

    }
}

// 添加动画Annotation
- (void)addAnimatedAnnotationWithName:(NSString *)name withAddress:(CLLocationCoordinate2D)coor {
    
    BMKPointAnnotation*animatedAnnotation = [[BMKPointAnnotation alloc]init];
    animatedAnnotation.coordinate = coor;
    animatedAnnotation.title = name;
    [_mapView addAnnotation:animatedAnnotation];
    
}


/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    
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
