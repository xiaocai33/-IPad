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

const int MTCoverTag = 1111;

@interface MTCityChangedViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *cityGroups;

@property (nonatomic, weak) UITableView *cityTableView;

@end

@implementation MTCityChangedViewController

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
    
    [self.view addSubview:searchBar];
    
    //自动布局
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    searchBar.sd_layout
    .topSpaceToView(self.view, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
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
    .topSpaceToView(searchBar, 10)
    .bottomEqualToView(self.view);
    
}

#pragma mark - UISearchBar代理方法
/**
 *  开始搜索
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // 1. 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 2. 添加蒙版
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.5;
    coverView.tag = MTCoverTag;
    
    //点击蒙版,取消搜索框(点击手势完成--UITapGestureRecognizer)
    //调用seatchBar注销键盘的操作,会自动调用结束编辑的代理方法
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:searchBar action:@selector(resignFirstResponder)]];
    
    [self.view addSubview:coverView];
    
    coverView.translatesAutoresizingMaskIntoConstraints = NO;
    
    coverView.sd_layout
    .leftEqualToView(self.cityTableView)
    .rightEqualToView(self.cityTableView)
    .topEqualToView(self.cityTableView)
    .bottomEqualToView(self.cityTableView);
    
    // 3. 更换搜索框的背景
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
}

/**
 *  结束搜索
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // 1. 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 2. 移除蒙版
    [[self.view viewWithTag:MTCoverTag] removeFromSuperview];
    
    // 3. 恢复搜索框的背景
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
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
