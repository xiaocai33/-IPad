//
//  MTHomeLeftTopItem.m
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTHomeLeftTopItem.h"

@implementation MTHomeLeftTopItem

+ (instancetype)item{
    MTHomeLeftTopItem *topView = [[[NSBundle mainBundle] loadNibNamed:@"MTHomeLeftTopItem" owner:nil options:nil] lastObject];
    topView.autoresizingMask = UIViewAutoresizingNone;
    return topView;
}

@end
