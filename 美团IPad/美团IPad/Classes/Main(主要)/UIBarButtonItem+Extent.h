//
//  UIBarButtonItem+Extent.h
//  01-微博UITabBarViewController的创建
//
//  Created by 小蔡 on 15/12/13.
//  Copyright © 2015年 小蔡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extent)
/**
 *  根据图片 创建UIBarButton
 *
 *  @param image            默认图片
 *  @param highlightedImage 高亮图片
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightedImage:(NSString *)highlightedImage;
@end
