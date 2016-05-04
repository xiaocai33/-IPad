//
//  MTSort.h
//  美团IPad
//
//  Created by 小蔡 on 16/5/4.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSort : NSObject
/**
 *  排序名称
 */
@property (nonatomic, copy) NSString *label;

/**
 *  排序的值(将来发给服务器)
 */
@property (nonatomic, assign) int value;

@end
