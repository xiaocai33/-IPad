//
//  MTDistrictViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/2.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTDistrictViewController.h"
#import "UIView+SDAutoLayout.h"
#import "MTHomeDropdownView.h"
#import "MJExtension.h"
#import "MTCityChangedViewController.h"
#import "MTNavigationController.h"
#import "MTRegion.h"

@interface MTDistrictViewController () <MTHomeDropdownDataSource>

@end

@implementation MTDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(320, 480);
    
    //初始化视图
    [self setupCityChangeViewAndDetailView];
}

/**
 *  初始化视图
 */
- (void)setupCityChangeViewAndDetailView{
    // 1. 初始化切换城市视图按钮(一个view中添加按钮和imageView)
    UIView *contentView = [[UIView alloc] init];
    //contentView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:contentView];
    
    //设置autosizing的值为NO;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //自动布局
    contentView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(44);
    
    // 1.1 在contentView中添加按钮
    UIButton *cityChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //cityChangeBtn.backgroundColor = [UIColor redColor];
    //设置按钮标题和颜色
    [cityChangeBtn setTitle:@"切换城市" forState:UIControlStateNormal];
    [cityChangeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置按钮选中和默认情况下的背景图片
    [cityChangeBtn setImage:[UIImage imageNamed:@"btn_changeCity"] forState:UIControlStateNormal];
    [cityChangeBtn setImage:[UIImage imageNamed:@"btn_changeCity_selected"] forState:UIControlStateHighlighted];

    //设置按钮左对齐
    cityChangeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    //设置按钮内边距和标题的内边距
    cityChangeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    cityChangeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [cityChangeBtn addTarget:self action:@selector(cityChanged) forControlEvents:UIControlEventTouchUpInside];

    [contentView addSubview:cityChangeBtn];
    
    //自动布局
    cityChangeBtn.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topEqualToView(contentView)
    .bottomEqualToView(contentView);

    // 1.2 设置右边的箭头图形
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
    
    [contentView addSubview:imageV];
    
    imageV.sd_layout
    .widthIs(17)
    .heightIs(17)
    .rightSpaceToView(contentView, 10)
    .centerYEqualToView(contentView);
    
    
    // 2. 初始化tableView视图
    MTHomeDropdownView *dropView = [[MTHomeDropdownView alloc] init];
    
    //dropView 实现自己的数据源
    dropView.dataSource = self;
    
    [self.view addSubview:dropView];
    
    dropView.translatesAutoresizingMaskIntoConstraints = NO;
    
    dropView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(contentView, 0)
    .bottomEqualToView(self.view);

}

/**
 *  切换城市
 */
- (void)cityChanged{
    [self.districtPopover dismissPopoverAnimated:YES];
    
    MTCityChangedViewController *cityVc = [[MTCityChangedViewController alloc] init];
    MTNavigationController *nav = [[MTNavigationController alloc] initWithRootViewController:cityVc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - MTHomeDropdownDataSource 数据源方法
/** 主表行数 */
- (NSInteger)numberOfRowsInMainTable:(MTHomeDropdownView *)homeDropdown{
    
    return self.regions.count;
}

/** 主表标题 */
- (NSString *)homeDropdown:(MTHomeDropdownView *)homeDropdown titleForRowInMainTable:(int)row{
    //得到模型数据
    MTRegion *region = self.regions[row];
    return region.name;
}

/** 主表子数据 */
- (NSArray *)homeDropdown:(MTHomeDropdownView *)homeDropdown subdataForRowInMainTable:(int)row{
    //得到模型数据
    MTRegion *region = self.regions[row];
    return region.subregions;
}



@end
