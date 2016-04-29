//
//  MTConstant.h
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
// 定义常量

#import <Foundation/Foundation.h>

#define MTHomeColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define MTHomeBg MTHomeColor(230,230,230)

#ifdef DEBUG
#define MTLog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else
#define MTLog(...)

#endif
