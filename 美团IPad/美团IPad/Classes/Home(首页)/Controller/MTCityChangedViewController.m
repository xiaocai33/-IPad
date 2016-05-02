//
//  MTCityChangedViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/2.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTCityChangedViewController.h"
#import "UIView+SDAutoLayout.h"
#import "MTCityGroups.h"
#import "MJExtension.h"
#import "MTConstant.h"
#import "MTSearchResultTableController.h"

const int MTCoverTag = 1111;

@interface MTCityChangedViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
/** 城市分组数据 */
@property (nonatomic, strong) NSArray *cityGroups;

/** 城市详情显示表 */
@property (nonatomic, weak) UITableView *cityTableView;

/** 搜索框 */
@property (nonatomic, weak) UISearchBar *searchBar;

/** 按钮蒙版 */
@property (nonatomic, weak) UIButton *coverBtn;

/** 搜索结果显示tableView */
@property (nonatomic, weak) MTSearchResultTableController *searchTableVc;

@end

@implementation MTCityChangedViewController

- (MTSearchResultTableController *)searchTableVc{
    if (_searchTableVc == nil) {
        MTSearchResultTableController *vc = [[MTSearchResultTableController alloc] init];
        [self addChildViewController:vc];
        
        [self.view addSubview:vc.view];
        
        vc.view.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view)
        .topEqualToView(self.cityTableView);
        
        _searchTableVc = vc;
    }
    return _searchTableVc;
}

- (UIButton *)coverBtn{
    if (_coverBtn == nil) {
        UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        coverBtn.backgroundColor = [UIColor blackColor];
        [coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:coverBtn];
        
        //自动布局
        coverBtn.sd_layout
        .leftEqualToView(self.cityTableView)
        .rightEqualToView(self.cityTableView)
        .topEqualToView(self.cityTableView)
        .bottomEqualToView(self.cityTableView);
        
        _coverBtn = coverBtn;
        
        
    }
    return _coverBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"切换城市";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.cityGroups = [MTCityGroups objectArrayWithFilename:@"cityGroups.plist"];
    
    //初始化控件
    [self setupSearchBarAndTableView];
}

/**
 *  初始化搜索框和tableView
 */
- (void)setupSearchBarAndTableView{
    // 1.初始化搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入城市名或拼音";
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    
    searchBar.delegate = self;
    //设置搜索框取消按钮颜色
    searchBar.tintColor = MTHomeColor(32, 191, 179);
    
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    //自动布局
    //searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    searchBar.sd_layout
    .topSpaceToView(self.view, 15)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .heightIs(35);
    
    // 2.初始化TableView
    UITableView *cityTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    cityTableView.dataSource = self;
    cityTableView.delegate = self;
    
    //设置tabelView索引的颜色
    cityTableView.sectionIndexColor = [UIColor blackColor];
    
    [self.view addSubview:cityTableView];
    self.cityTableView = cityTableView;
    
    //自动布局
    cityTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    cityTableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(searchBar, 15)
    .bottomEqualToView(self.view);
    
}

/**
 *  取消蒙版
 */
- (void)coverBtnClick{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBar代理方法
/**
 *  开始搜索
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // 1. 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 2. 添加蒙版(方案1)
//    UIView *coverView = [[UIView alloc] init];
//    coverView.backgroundColor = [UIColor blackColor];
//    coverView.alpha = 0.5;
//    coverView.tag = MTCoverTag;
//    
//    //点击蒙版,取消搜索框(点击手势完成--UITapGestureRecognizer)
//    //调用seatchBar注销键盘的操作,会自动调用结束编辑的代理方法
//    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:searchBar action:@selector(resignFirstResponder)]];
//    
//    [self.view addSubview:coverView];
//    
//    coverView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    coverView.sd_layout
//    .leftEqualToView(self.cityTableView)
//    .rightEqualToView(self.cityTableView)
//    .topEqualToView(self.cityTableView)
//    .bottomEqualToView(self.cityTableView);
    
    // 2. 添加蒙版(方案2) 用按钮实现蒙版技术
    [UIView animateWithDuration:0.25 animations:^{
        self.coverBtn.alpha = 0.5;
    }];
    
    // 3 显示取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
    // 4. 更换搜索框的背景
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
}

/**
 *  结束搜索
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // 1. 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 2. 移除蒙版
    //[[self.view viewWithTag:MTCoverTag] removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        self.coverBtn.alpha = 0.0;
    }];
    
    // 3 隐藏取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    
    // 4. 恢复搜索框的背景
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
}

/**
 *  取消按钮被点击
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

/**
 *  搜索框文本内容改变调用
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length) {
        self.searchTableVc.view.hidden = NO;
    }else{
        self.searchTableVc.view.hidden = YES;
    }
}

#pragma mark - UITableView数据源方法
/**
 *  组数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cityGroups.count;
}

/**
 *  每组个数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MTCityGroups *group = self.cityGroups[section];
    return group.cities.count;
}

/**
 *  每个cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    MTCityGroups *group = self.cityGroups[indexPath.section];
    cell.textLabel.text = group.cities[indexPath.row];
    return cell;
}

#pragma mark - UITableView代理方法
/**
 *  表头内容
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    MTCityGroups *group = self.cityGroups[section];
    return group.title;
}

/**
 *  添加索引
 */
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    //    NSMutableArray *titles = [NSMutableArray array];
    //    for (MTCityGroup *group in self.cityGroups) {
    //        [titles addObject:group.title];
    //    }
    //    return titles;
    //KVC
    return [self.cityGroups valueForKey:@"title"];
}



@end
