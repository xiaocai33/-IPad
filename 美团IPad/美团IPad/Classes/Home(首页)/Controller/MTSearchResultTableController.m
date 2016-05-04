//
//  MTSearchResultTableController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/2.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTSearchResultTableController.h"
#import "MTDataTool.h"
#import "MTCitiy.h"
#import "MTConstant.h"

@interface MTSearchResultTableController ()
/** 搜索匹配的城市数据 */
@property (nonatomic, strong) NSArray *resultCities;

@end

@implementation MTSearchResultTableController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)setSearchKey:(NSString *)searchKey{
    _searchKey = [searchKey copy];
    
    //将字符串转为小写
    searchKey = searchKey.lowercaseString;
    
    //过滤器筛选条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchKey, searchKey, searchKey];
    self.resultCities = [[MTDataTool cities] filteredArrayUsingPredicate:predicate];
    
    //刷新表格
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"resultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    MTCitiy *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    return cell;
}

#pragma mark - Table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"共有%zd个搜索结果", self.resultCities.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MTCitiy *city = self.resultCities[indexPath.row];
    //发送通知(将选中的城市名称发送出去)
    [MTNotificationCenter postNotificationName:MTCityDidChangeNotification object:nil userInfo:@{MTSelectCityName : city.name}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
