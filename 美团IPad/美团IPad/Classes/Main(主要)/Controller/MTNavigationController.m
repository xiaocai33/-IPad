//
//  MTNavigationController.m
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTNavigationController.h"
#import "MTConstant.h"

@interface MTNavigationController ()

@end

@implementation MTNavigationController

//类第一次加载的时候会调用这个方法,只调一次
+ (void)initialize{
    //设置所有导航栏的样式
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
    //设置所有 UIBarButtonItem 的样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : MTHomeColor(21, 188, 173)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏右边的按钮
    
    //设置导航栏左边的按钮
}





@end
