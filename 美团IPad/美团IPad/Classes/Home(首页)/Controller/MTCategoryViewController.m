//
//  MTCategoryViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTCategoryViewController.h"
#import "MJExtension.h"
#import "MTCategory.h"
#import "MTHomeDropdownView.h"
#import "UIView+SDAutoLayout.h"

@interface MTCategoryViewController ()

@end

@implementation MTCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置popover的尺寸
    self.preferredContentSize = CGSizeMake(320, 480);
    
    MTHomeDropdownView *dropdownView = [[MTHomeDropdownView alloc] init];
    
    [self.view addSubview:dropdownView];
    
    dropdownView.translatesAutoresizingMaskIntoConstraints = NO;
    
    dropdownView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    //得到模型数据
    dropdownView.categories = [MTCategory objectArrayWithFilename:@"categories.plist"];
}




@end
