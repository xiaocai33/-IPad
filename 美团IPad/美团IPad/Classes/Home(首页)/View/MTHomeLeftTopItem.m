//
//  MTHomeLeftTopItem.m
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTHomeLeftTopItem.h"

@interface MTHomeLeftTopItem()
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@end

@implementation MTHomeLeftTopItem

+ (instancetype)item{
    MTHomeLeftTopItem *topView = [[[NSBundle mainBundle] loadNibNamed:@"MTHomeLeftTopItem" owner:nil options:nil] lastObject];
    topView.autoresizingMask = UIViewAutoresizingNone;
    return topView;
}

- (void)addTarget:(id)target action:(SEL)action{
    [self.iconBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
