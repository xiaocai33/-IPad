//
//  MTHomeDropdownView.h
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
// 模仿 UITableView 设计通用的视图

#import <UIKit/UIKit.h>
@class MTHomeDropdownView;

@protocol MTHomeDropdownDataSource <NSObject>
/**
 *  主表格一共多少行
 */
- (NSInteger)numberOfRowsInMainTable:(MTHomeDropdownView *)homeDropdown;

/**
 *  主表格每一行的标题
 *  @param row          行号
 */
- (NSString *)homeDropdown:(MTHomeDropdownView *)homeDropdown titleForRowInMainTable:(int)row;

/**
 *  主表格每一行的子数据
 *  @param row          行号
 */
- (NSArray *)homeDropdown:(MTHomeDropdownView *)homeDropdown subdataForRowInMainTable:(int)row;

//可选的数据源方法
@optional
/**
 *  主表格每一行的图标
 *  @param row          行号
 */
- (NSString *)homeDropdown:(MTHomeDropdownView *)homeDropdown iconForRowInMainTable:(int)row;

/**
 *  主表格每一行选中的图标
 *  @param row          行号
 */
- (NSString *)homeDropdown:(MTHomeDropdownView *)homeDropdown selectedIconForRowInMainTable:(int)row;

@end

@interface MTHomeDropdownView : UIView

//@property (nonatomic, strong) NSArray *categories;

@property (nonatomic, weak) id<MTHomeDropdownDataSource> dataSource;

@end
