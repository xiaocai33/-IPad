//
//  MTConstant.h
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
// 定义常量

#import <Foundation/Foundation.h>

#define MTHomeColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define MTHomeBg MTHomeColor(230,230,230)

#ifdef DEBUG
#define MTLog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else
#define MTLog(...)

#endif

#define MTNotificationCenter [NSNotificationCenter defaultCenter]

/** 城市改变通知 */
extern NSString *const MTCityDidChangeNotification;
/** 选中的城市名称 */
extern NSString *const MTSelectCityName;

/** 城市改变通知 */
extern NSString *const MTSortDidChangeNotification;
/** 选中的排序模型 */
extern NSString *const MTSelectSort;

/** 分类改变通知 */
extern NSString *const MTCategoryDidChangeNotification;
/** 选中的分类模型 */
extern NSString *const MTSelectCategory;
/** 选中的子分类名称 */
extern NSString *const MTSelectSubcategoryName;

/** 区域改变通知 */
extern NSString *const MTRegionDidChangeNotification;
/** 选中的区域模型 */
extern NSString *const MTSelectRegion;
/** 选中的子区域名称 */
extern NSString *const MTSelectSubregionName;

/** 收藏改变通知 */
extern NSString *const MTCollectStateDidChangeNotification;
/** 是否收藏 */
extern NSString *const MTIsCollectKey;
/** 收藏订单详情 */
extern NSString *const MTCollectDealKey;
