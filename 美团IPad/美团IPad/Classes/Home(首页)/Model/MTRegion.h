//
//  MTRegion.h
//  美团IPad
//
//  Created by 小蔡 on 16/5/2.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTRegion : NSObject
/** 区域名字 */
@property (nonatomic, copy) NSString *name;
/** 子区域 */
@property (nonatomic, strong) NSArray *subregions;
@end
