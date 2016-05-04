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
#import "MTConstant.h"

@interface MTCategoryViewController () <MTHomeDropdownDataSource, MTHomeDropdownDelegate>

@end

@implementation MTCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置popover的尺寸
    self.preferredContentSize = CGSizeMake(400, 480);
    
    MTHomeDropdownView *dropdownView = [[MTHomeDropdownView alloc] init];
    
    // dropdownView 实现数据源方法 和 代理
    dropdownView.dataSource = self;
    dropdownView.delegate = self;
    
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

#pragma mark - MTHomeDropdownDelegate 代理方法
- (void)homeDropdown:(MTHomeDropdownView *)homeDropdown didSelectRowInMainTable:(int)row{
    //选中的模型
    MTCategory *category = [MTDataTool categories][row];
    if (category.subcategories.count == 0) {//没有子标题的情况下,发送通知
        //发送通知
        [MTNotificationCenter postNotificationName:MTCategoryDidChangeNotification object:nil userInfo:@{MTSelectCategory : category}];
    }
}

- (void)homeDropdown:(MTHomeDropdownView *)homeDropdown didSelectRowInSubTable:(int)subRow rowInMainTable:(int)mainRow{
    //选中的模型
    MTCategory *category = [MTDataTool categories][mainRow];
    //选中子数据的标题
    NSString *subcategoryName = category.subcategories[subRow];
    ////发送通知
    [MTNotificationCenter postNotificationName:MTCategoryDidChangeNotification object:nil userInfo:@{MTSelectCategory : category, MTSelectSubcategoryName : subcategoryName}];
}



@end
