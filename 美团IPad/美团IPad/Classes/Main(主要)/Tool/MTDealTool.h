//
//  MTDealTool.h
//  美团IPad
//
//  Created by 小蔡 on 16/5/10.
//  Copyright © 2016年 xiaocai. All rights reserved.
// 将团购信息存数据库

#import <Foundation/Foundation.h>
@class MTDeals;
@interface MTDealTool : NSObject
/**
 *  返回第page页的收藏团购数据:page从1开始
 */
+ (NSArray *)collectDeals:(int)page;
/**
 *  收藏团购的数目
 */
+ (int)collectDealsCount;
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(MTDeals *)deal;
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(MTDeals *)deal;
/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(MTDeals *)deal;

@end
