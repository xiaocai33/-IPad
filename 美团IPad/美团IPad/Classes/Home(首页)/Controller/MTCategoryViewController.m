//
//  MTCategoryViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTCategoryViewController.h"
#import "MJExtension.h"
#import "MTDataTool.h"
#import "MTHomeDropdownView.h"
#import "UIView+SDAutoLayout.h"
#import "MTCategory.h"

@interface MTCategoryViewController () <MTHomeDropdownDataSource>

@end

@implementation MTCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置popover的尺寸
    self.preferredContentSize = CGSizeMake(320, 480);
    
    MTHomeDropdownView *dropdownView = [[MTHomeDropdownView alloc] init];
    
    // dropdownView 实现数据源方法
    dropdownView.dataSource = self;
    
    //根据 dropdownView 的尺寸, 设置popover的尺寸
    //self.preferredContentSize = CGSizeMake(dropdownView.width, CGRectGetMaxY(dropdownView.frame));
    
    //[self.view addSubview:dropdownView];
    self.view = dropdownView;
    
    dropdownView.translatesAutoresizingMaskIntoConstraints = NO;
    
    dropdownView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    
//    //得到模型数据
//    dropdownView.categories = [MTDataTool categories];
}

#pragma mark - MTHomeDropdownDataSource 数据源方法
/** 主表行数 */
- (NSInteger)numberOfRowsInMainTable:(MTHomeDropdownView *)homeDropdown{
    
    return [MTDataTool categories].count;
}

/** 主表标题 */
- (NSString *)homeDropdown:(MTHomeDropdownView *)homeDropdown titleForRowInMainTable:(int)row{
    //得到模型数据
    MTCategory *category = [MTDataTool categories][row];
    return category.name;
}

/** 主表子数据 */
- (NSArray *)homeDropdown:(MTHomeDropdownView *)homeDropdown subdataForRowInMainTable:(int)row{
    //得到模型数据
    MTCategory *category = [MTDataTool categories][row];
    return category.subcategories;
}

/** 主表图标 */
- (NSString *)homeDropdown:(MTHomeDropdownView *)homeDropdown iconForRowInMainTable:(int)row{
    //得到模型数据
    MTCategory *category = [MTDataTool categories][row];
    return category.small_icon;
}

/** 主表选中图标  */
- (NSString *)homeDropdown:(MTHomeDropdownView *)homeDropdown selectedIconForRowInMainTable:(int)row{
    //得到模型数据
    MTCategory *category = [MTDataTool categories][row];
    return category.small_highlighted_icon;
}




@end
