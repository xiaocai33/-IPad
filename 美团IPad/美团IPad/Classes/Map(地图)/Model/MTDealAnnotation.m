//
//  MTMTDealAnnotation.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/15.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTDealAnnotation.h"

@implementation MTDealAnnotation
- (BOOL)isEqual:(MTDealAnnotation *)other
{
    return [self.title isEqual:other.title];
}
@end
