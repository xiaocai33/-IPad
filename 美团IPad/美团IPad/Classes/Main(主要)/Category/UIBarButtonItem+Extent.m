//
//  UIBarButtonItem+Extent.m
//  01-微博UITabBarViewController的创建
//
//  Created by 小蔡 on 15/12/13.
//  Copyright © 2015年 小蔡. All rights reserved.
//

#import "UIBarButtonItem+Extent.h"
#import "UIView+Extension.h"

@implementation UIBarButtonItem (Extent)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightedImage:(NSString *)highlightedImage{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *imageV = [UIImage imageNamed:image];
    //图片不渲染
    [imageV imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [btn setImage:imageV forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    
    btn.size = btn.currentImage.size;
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
