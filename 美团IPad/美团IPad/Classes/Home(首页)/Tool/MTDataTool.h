//
//  MTDataTool.h
//  美团IPad
//
//  Created by 小蔡 on 16/5/4.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTDataTool : NSObject

/**
 *  返回城市数据
 */
+ (NSArray *)cities;

/**
 *  返回分类数据
 */
+ (NSArray *)categories;

/**
 *  返回排序数据
 */
+ (NSArray *)sorts;

@end
