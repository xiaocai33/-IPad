//
//  MTHomeLeftTopItem.h
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTHomeLeftTopItem : UIView

/**
 *  根据xib加载视图
 */
+ (instancetype)item;

- (void)addTarget:(id)target action:(SEL)action;

/** 设置标题 */
- (void)setTitle:(NSString *)title;

/** 设置子标题 */
- (void)setSubTitle:(NSString *)subtitle;

/** 设置显示图标 */
- (void)setIcon:(NSString *)icon heighlightIcon:(NSString *)heighlightIcon;
@end
