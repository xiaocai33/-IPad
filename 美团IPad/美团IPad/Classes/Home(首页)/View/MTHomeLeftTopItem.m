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
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//子标题
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

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

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subtitle{
    self.subTitleLabel.text = subtitle;
}

- (void)setIcon:(NSString *)icon heighlightIcon:(NSString *)heighlightIcon{
    //设置普通状态按钮
    [self.iconBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    //设置高亮状态按钮
    [self.iconBtn setImage:[UIImage imageNamed:heighlightIcon] forState:UIControlStateHighlighted];
}


@end
