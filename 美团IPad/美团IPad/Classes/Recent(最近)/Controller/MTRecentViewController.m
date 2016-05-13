//
//  MTRecentViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/8.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTRecentViewController.h"
#import "MTDealTool.h"
#import "MJRefresh.h"
#import "MTDeals.h"


@interface MTRecentViewController ()

@end

@implementation MTRecentViewController


- (void)setupArray:(NSMutableArray *)array withCount:(int)count{
    
    [array addObjectsFromArray:[MTDealTool recentDeals:count]];
    
    [self.collectionView footerBeginRefreshing];
}

- (int)allCount{
    return [MTDealTool recentDealsCount];
}

- (void)removeDeal:(MTDeals *)deal{
    [MTDealTool removeRecentDeal:deal];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最近浏览的团购";
    
}
@end
