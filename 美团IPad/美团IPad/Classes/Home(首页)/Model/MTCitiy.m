//
//  MTCitiy.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/2.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTCitiy.h"
#import "MJExtension.h"
#import "MTRegion.h"

@implementation MTCitiy

- (NSDictionary *)objectClassInArray{
    return @{@"regions" : [MTRegion class]};
}

@end
