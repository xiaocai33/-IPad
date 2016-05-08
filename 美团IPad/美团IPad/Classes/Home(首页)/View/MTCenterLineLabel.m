//
//  MTCenterLineLabel.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/8.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTCenterLineLabel.h"

@implementation MTCenterLineLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //画横线
//    //获得当前图形上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    //画线
//    //设置起点
//    CGContextMoveToPoint(ctx, 0, rect.size.height * 0.5);
//    //设置终点
//    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height * 0.5);
//    //渲染
//    CGContextStrokePath(ctx);
    
    
    //画一个高度为 1 的矩形
    UIRectFill(CGRectMake(0, rect.size.height * 0.4, rect.size.width, 1));
}


@end
