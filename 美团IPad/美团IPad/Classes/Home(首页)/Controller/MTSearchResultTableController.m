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



@end
