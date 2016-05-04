//
//  MTHomeDropdownView.m
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTHomeDropdownView.h"
#import "UIView+SDAutoLayout.h"
//#import "MTCategory.h"
#import "MTMainHomeTableCell.h"
#import "MTSubHomeTableCell.h"

@interface MTHomeDropdownView() <UITableViewDataSource, UITableViewDelegate>
/** 主表 */
@property (nonatomic, weak) UITableView *mainTableView;
/** 从表 */
@property (nonatomic, weak) UITableView *subTableView;
/** 选中的类别 */
//@property (nonatomic, strong) MTCategory *seledtedCategory;

/** 选中的行号 */
@property (nonatomic, assign) NSInteger selectedRow;
@end

@implementation MTHomeDropdownView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置view不随父控件伸缩
        self.autoresizingMask = UIViewAutoresizingNone;
        //添加主表和附表
        [self setUpTableView];
        
    }
    
    return self;
}

/**
 *  初始化主表和附表
 */
- (void)setUpTableView{

    UITableView *mainTableView = [[UITableView alloc] init];
    //去掉自带的横线
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //添加数据源和代理
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    
    [self addSubview:mainTableView];
    self.mainTableView = mainTableView;
    
    UITableView *subTableView = [[UITableView alloc] init];
    subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //添加数据源和代理
    subTableView.dataSource = self;
    subTableView.delegate = self;
    
    [self addSubview:subTableView];
    self.subTableView = subTableView;
    
    mainTableView.translatesAutoresizingMaskIntoConstraints = NO;
    subTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    mainTableView.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthRatioToView(self, 0.5);
    
    subTableView.sd_layout
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthRatioToView(self, 0.5);
    
}

//- (void)setCategories:(NSArray *)categories{
//    _categories = categories;
//}

#pragma mark - UITableView的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.mainTableView) {
        //由数据源得到具体的条数
        return [self.dataSource numberOfRowsInMainTable:self];
        
    }else {
        //由数据源得到选中的行的子数据
        return [self.dataSource homeDropdown:self subdataForRowInMainTable:self.selectedRow].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    //主表
    if (tableView == self.mainTableView) {
        cell = [MTMainHomeTableCell mainTableViewCellWithTableView:tableView];
        
//        MTCategory *category = self.categories[indexPath.row];
//        cell.textLabel.text = category.name;
//        cell.imageView.image = [UIImage imageNamed:category.small_icon];
//        if (category.subcategories.count > 0) {
//            //cell上的箭头
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        } else {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
        //由数据源得到改行的题目
        NSString *title = [self.dataSource homeDropdown:self titleForRowInMainTable:indexPath.row];
        cell.textLabel.text = title;
        
        //由数据源得到改行的图标
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:iconForRowInMainTable:)]) {
            NSString *icon = [self.dataSource homeDropdown:self iconForRowInMainTable:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:icon];
        }
        
        //由数据源得到改行选中的图标
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:selectedIconForRowInMainTable:)]) {
            NSString *selectedIcon = [self.dataSource homeDropdown:self selectedIconForRowInMainTable:indexPath.row];
            cell.imageView.highlightedImage = [UIImage imageNamed:selectedIcon];
        }
        
        //由数据源得到改行选中的子数据
        NSArray *subdata = [self.dataSource homeDropdown:self subdataForRowInMainTable:indexPath.row];
        if (subdata.count > 0) {
             //cell上的箭头
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    } else {//从表
        cell = [MTSubHomeTableCell subTableViewCellWithTableView:tableView];
        
        //由数据源得到改行选中的子数据
        NSArray *subdata = [self.dataSource homeDropdown:self subdataForRowInMainTable:self.selectedRow];
        
        cell.textLabel.text = subdata[indexPath.row];
    }
    
    return cell;
}


#pragma mark - UITableView的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) { //主表
        // 被点击的分类
        self.selectedRow = indexPath.row;
        
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectRowInMainTable:)]) {
            [self.delegate homeDropdown:self didSelectRowInMainTable:indexPath.row];
        }
        //刷新右边表格
        [self.subTableView reloadData];
    } else { //从表
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectRowInSubTable:rowInMainTable:)]) {
            [self.delegate homeDropdown:self didSelectRowInSubTable:indexPath.row rowInMainTable:self.selectedRow];
        }
    }
    
}


@end
