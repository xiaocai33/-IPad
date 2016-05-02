//
//  MTCityGroups.h
//  美团IPad
//
//  Created by 小蔡 on 16/5/2.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCityGroups : NSObject
/**
 *  分组名称
 */
@property (nonatomic, copy) NSString *title;

/**
 *  分组详情城市名称
 */
@property (nonatomic, strong) NSArray *cities;
@end
