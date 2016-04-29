//
//  MTHomeDropdownView.m
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTHomeDropdownView.h"
#import "UIView+SDAutoLayout.h"

@implementation MTHomeDropdownView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置view不随父控件伸缩
        self.autoresizingMask = UIViewAutoresizingNone;
        
        //添加主表和附表
        [self setUpTableView];
        
    }
    
    return self;
}

/**
 *  初始化主表和附表
 */
- (void)setUpTableView{
    NSLog(@"setUpTableView");
    UITableView *mainTableView = [[UITableView alloc] init];
    [self addSubview:mainTableView];
    mainTableView.backgroundColor = [UIColor greenColor];
    
    UITableView *subTableView = [[UITableView alloc] init];
    [self addSubview:subTableView];
    subTableView.backgroundColor = [UIColor blueColor];
    
    mainTableView.translatesAutoresizingMaskIntoConstraints = NO;
    subTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    mainTableView.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthRatioToView(self, 0.5);
    
    subTableView.sd_layout
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthRatioToView(self, 0.5);
    
}

@end
