//
//  MTDeals.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/8.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTDeals.h"
#import "MJExtension.h"
#import "MTBusiness.h"
@implementation MTDeals
MJCodingImplementation

- (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"desc" : @"description"};
}

- (BOOL)isEqual:(MTDeals *)object{
    return [self.deal_id isEqualToString:object.deal_id];
}

- (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [MTBusiness class]};
}

@end
