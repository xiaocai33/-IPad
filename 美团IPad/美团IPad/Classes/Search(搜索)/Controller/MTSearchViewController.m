//
//  MTSearchViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/8.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTSearchViewController.h"
#import "UIBarButtonItem+Extent.h"
#import "MJRefresh.h"

@interface MTSearchViewController () <UISearchBarDelegate>

@end

@implementation MTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     //添加导航栏左边的按钮
    UIBarButtonItem *closeBtnItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"icon_back" highlightedImage:@"icon_back_highlighted"];
   
    self.navigationItem.leftBarButtonItem = closeBtnItem;
    
    //设置导航栏的title为UISearchBar
    // 中间的搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];

    searchBar.placeholder = @"请输入关键词";
    searchBar.delegate = self;
    
    self.navigationItem.titleView = searchBar;
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 搜索框的Search按钮被点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // 进入下拉刷新状态, 发送请求给服务器
    [self.collectionView headerBeginRefreshing];
    
    // 退出键盘
    [searchBar resignFirstResponder];
}

#pragma mark - 给服务发送参数
- (void)setupParams:(NSMutableDictionary *)params{
    params[@"city"] = @"成都";
    UISearchBar *searchBar = (UISearchBar *)self.navigationItem.titleView;
    params[@"keyword"] = searchBar.text;
}

@end
