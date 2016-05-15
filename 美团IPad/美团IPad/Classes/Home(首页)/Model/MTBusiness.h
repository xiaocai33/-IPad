//
//  MTBusiness.h
//  美团IPad
//
//  Created by 小蔡 on 16/5/15.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTBusiness : NSObject
/** 店名 */
@property (nonatomic, copy) NSString *name;
/** 纬度 */
@property (nonatomic, assign) float latitude;
/** 经度 */
@property (nonatomic, assign) float longitude;
@end
