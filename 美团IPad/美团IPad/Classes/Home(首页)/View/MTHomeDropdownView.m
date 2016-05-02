//
//  MTHomeDropdownView.m
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTHomeDropdownView.h"
#import "UIView+SDAutoLayout.h"
#import "MTCategory.h"
#import "MTMainHomeTableCell.h"
#import "MTSubHomeTableCell.h"

@interface MTHomeDropdownView() <UITableViewDataSource, UITableViewDelegate>
/** 主表 */
@property (nonatomic, weak) UITableView *mainTableView;
/** 从表 */
@property (nonatomic, weak) UITableView *subTableView;
/** 选中的类别 */
@property (nonatomic, strong) MTCategory *seledtedCategory;

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

- (void)setCategories:(NSArray *)categories{
    _categories = categories;
}

#pragma mark - UITableView的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.mainTableView) {
        //NSLog(@"%zd", self.categories.count);
        return self.categories.count;
    }else {
        return self.seledtedCategory.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    //主表
    if (tableView == self.mainTableView) {
        cell = [MTMainHomeTableCell mainTableViewCellWithTableView:tableView];
        
        MTCategory *category = self.categories[indexPath.row];
        cell.textLabel.text = category.name;
        cell.imageView.image = [UIImage imageNamed:category.small_icon];
        if (category.subcategories.count > 0) {
            //cell上的箭头
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {//从表
        cell = [MTSubHomeTableCell subTableViewCellWithTableView:tableView];
        
        cell.textLabel.text = self.seledtedCategory.subcategories[indexPath.row];
    }
    
    return cell;
}


#pragma mark - UITableView的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) {
        // 被点击的分类
        self.seledtedCategory = self.categories[indexPath.row];
        
        //刷新右边表格
        [self.subTableView reloadData];
    }
    
}


@end
