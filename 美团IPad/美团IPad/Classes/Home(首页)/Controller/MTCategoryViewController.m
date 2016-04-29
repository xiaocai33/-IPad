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
    
    self.view.backgroundColor = [UIColor grayColor];
    
    MTHomeDropdownView *dropdownView = [[MTHomeDropdownView alloc] init];
    
    [self.view addSubview:dropdownView];
    
    dropdownView.translatesAutoresizingMaskIntoConstraints = NO;
    
    dropdownView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    //得到模型数据
    //NSArray *categories = [MTCategory objectWithFilename:@"categories.plist"];
}




@end
