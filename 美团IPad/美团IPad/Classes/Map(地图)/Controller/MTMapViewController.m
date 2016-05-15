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

@interface MTMapViewController ()

@end

@implementation MTMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地图";
    
    //初始化子控件
    [self setupChildView];
    
    //添加导航栏左边的按钮
    UIBarButtonItem *closeBtnItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"icon_back" highlightedImage:@"icon_back_highlighted"];
    
    self.navigationItem.leftBarButtonItem = closeBtnItem;
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 初始化子控件 */
- (void)setupChildView{
    MKMapView *mapView = [[MKMapView alloc] init];
    [self.view addSubview:mapView];
    
    mapView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).topEqualToView(self.view);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_map_location"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_map_location_highlighted"] forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
    
    btn.sd_layout.leftSpaceToView(self.view, 20).bottomSpaceToView(self.view, 20).heightIs(70).widthIs(70);
}

@end
