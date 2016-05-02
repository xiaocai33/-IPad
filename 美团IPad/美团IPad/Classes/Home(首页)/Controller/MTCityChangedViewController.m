//
//  MTCityChangedViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/2.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTCityChangedViewController.h"
#import "UIView+SDAutoLayout.h"

@interface MTCityChangedViewController ()

@end

@implementation MTCityChangedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"切换城市";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    [self.view addSubview:searchBar];
    
    //自动布局
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    searchBar.sd_layout
    .topSpaceToView(self.view, 5)
    .leftSpaceToView(self.view, 5)
    .rightSpaceToView(self.view, 5)
    .heightIs(35);
    
    // 2.初始化TableView
    UITableView *cityTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    cityTableView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:cityTableView];
    
    //自动布局
    cityTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    cityTableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(searchBar, 0)
    .bottomEqualToView(self.view);
    
}




@end
