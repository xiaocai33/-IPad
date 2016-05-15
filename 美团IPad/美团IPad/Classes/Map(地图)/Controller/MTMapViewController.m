//
//  MTMapViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/15.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTMapViewController.h"
#import <MapKit/MapKit.h>
#import "UIView+SDAutoLayout.h"
#import "UIBarButtonItem+Extent.h"
#import "DPAPI.h"
#import "MTDealAnnotation.h"
#import "MTDeals.h"
#import "MTDataTool.h"
#import "MJExtension.h"
#import "MTCategory.h"
#import "MTBusiness.h"
#import "MTHomeLeftTopItem.h"
#import "MTConstant.h"
#import "MTCategoryViewController.h"

@interface MTMapViewController () <MKMapViewDelegate, DPRequestDelegate>
@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *mgr;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) DPRequest *lastRequest;
/** 当前选中的分类 */
@property (nonatomic, copy) NSString *selectedCategoryName;
/** 分类 popover */
@property (nonatomic, strong) UIPopoverController *categoryPopover;
/** 分类 */
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
@end

@implementation MTMapViewController

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地图";
    [self setupRequestAuthorization];
   
    
    //初始化子控件
    [self setupChildView];
    
    //添加导航栏左边的按钮
    UIBarButtonItem *closeBtnItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"icon_back" highlightedImage:@"icon_back_highlighted"];
    
    
    
    // 2.类别
    MTHomeLeftTopItem *categoryTopView = [MTHomeLeftTopItem item];
    [categoryTopView addTarget:self action:@selector(categoryAction)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopView];
    self.categoryItem = categoryItem;
    
    self.navigationItem.leftBarButtonItems = @[closeBtnItem, categoryItem];
    
    // 监听分类数据改变通知
    [MTNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:MTCategoryDidChangeNotification object:nil];
}

- (void)dealloc{
    [MTNotificationCenter removeObserver:self];
}

/**
 *  监听点击事件 -- 分类控制器
 */
- (void)categoryAction{
    UIPopoverController *categoryPopover = [[UIPopoverController alloc] initWithContentViewController:[[MTCategoryViewController alloc] init]];
    
    [categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    self.categoryPopover = categoryPopover;
}

/**
 *  监听分类数据改变通知方法
 */
- (void)categoryDidChange:(NSNotification *)noti{
    // 1 得到数据
    MTCategory *category = noti.userInfo[MTSelectCategory];
    NSString *subcategoryName = noti.userInfo[MTSelectSubcategoryName];
    
    if (subcategoryName == nil || [subcategoryName isEqualToString:@"全部"]) {//点击的分类没有子数据
        self.selectedCategoryName = category.name;
    } else { //单击了子分类
        self.selectedCategoryName = subcategoryName;
    }
    
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    // 2 改变Item上的显示标题
    MTHomeLeftTopItem *topItem = (MTHomeLeftTopItem *)self.categoryItem.customView;
    [topItem setTitle:category.name];
    [topItem setSubTitle:subcategoryName];
    [topItem setIcon:category.icon heighlightIcon:category.highlighted_icon];
    
    // 3 关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 4 从服务加载数据
    [self mapView:self.mapView regionDidChangeAnimated:YES];
}


- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  定位权限设置
 */
- (void)setupRequestAuthorization{
    self.mgr = [[CLLocationManager alloc] init];
    [self.mgr requestAlwaysAuthorization];
}

/** 初始化子控件 */
- (void)setupChildView{
    MKMapView *mapView = [[MKMapView alloc] init];
    mapView.delegate = self;
    //设置地图始终追踪用户的位置
    mapView.userTrackingMode = MKUserTrackingModeFollow;
    //不允许旋转
    mapView.rotateEnabled = NO;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    mapView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).topEqualToView(self.view);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_map_location"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_map_location_highlighted"] forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
    
    btn.sd_layout.leftSpaceToView(self.view, 20).bottomSpaceToView(self.view, 20).heightIs(70).widthIs(70);
}

#pragma mark - MKMapViewDelegate代理方法
/**
 * 用户位置改变后,调用这个方法(模拟器有问题)
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //地理反编码
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) return;
        
        CLPlacemark *pm = [placemarks firstObject];
        NSString *city = pm.locality ? pm.locality : pm.addressDictionary[@"State"];
        self.city = [city substringToIndex:city.length - 1];
        
        // 第一次发送请求给服务器
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
    
    //获取用户的位置
    CLLocationCoordinate2D coord = userLocation.location.coordinate;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    //将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度
    MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
    //设置地图显示区域
    [self.mapView setRegion:region animated:YES];
}

/**
 *  地图中心发生改变后,调用
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (self.city == nil) return;
    
    // 发送请求给服务器
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.city;
    //分类
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    // 经纬度
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @(1000);
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];

}

/**
 *  添加大头针模型
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MTDealAnnotation *)annotation{
    // 返回nil,意味着交给系统处理
    if (![annotation isKindOfClass:[MTDealAnnotation class]]) return nil;
    
    //创建大头针模型
    static NSString *ID = @"deal";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annoView.canShowCallout = YES;
    }
    
    // 设置模型(位置\标题\子标题)
    annoView.annotation = annotation;
    
    // 设置图片
    annoView.image = [UIImage imageNamed:annotation.icon];
    
    return annoView;
}



#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    if (request != self.lastRequest) return;
    
    NSArray *deals = [MTDeals objectArrayWithKeyValuesArray:result[@"deals"]];
    for (MTDeals *deal in deals) {
        
        // 获得团购所属的类型
        MTCategory *category = [MTDataTool categoryWithDeal:deal];
        
        for (MTBusiness *business in deal.businesses) {
            MTDealAnnotation *anno = [[MTDealAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            anno.title = business.name;
            anno.subtitle = deal.title;
            anno.icon = category.map_icon;
            
            if ([self.mapView.annotations containsObject:anno]) break;
            
            [self.mapView addAnnotation:anno];
        }
    }

}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"错误---%@", error);
}

@end
