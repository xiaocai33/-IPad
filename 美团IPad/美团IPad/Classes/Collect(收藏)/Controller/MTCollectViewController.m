//
//  MTCollectViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/8.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTCollectViewController.h"
#import "MTConstant.h"
#import "MJRefresh.h"
#import "MTDealTool.h"


@interface MTCollectViewController ()

@end

@implementation MTCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏的团购";
    
}

#pragma mark - 实现父控制的接口
- (void)setupArray:(NSMutableArray *)array withCount:(int)count{
    
    [array addObjectsFromArray:[MTDealTool collectDeals:count]];
    
    [self.collectionView footerBeginRefreshing];
}

- (int)allCount{
    return [MTDealTool collectDealsCount];
}

- (void)removeDeal:(MTDeals *)deal{
    [MTDealTool removeCollectDeal:deal];
}

- (NSString *)setNoDataImage{
    return @"icon_collects_empty";
}


@end
