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
    
    MTHomeDropdownView *dropdownView = [[MTHomeDropdownView alloc] init];
    
    //根据 dropdownView 的尺寸, 设置popover的尺寸
    self.preferredContentSize = CGSizeMake(dropdownView.width, CGRectGetMaxY(dropdownView.frame));
    
    //[self.view addSubview:dropdownView];
    self.view = dropdownView;
    
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
