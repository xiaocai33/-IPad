//
//  MTSortViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/4.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTSortViewController.h"
#import "MTDataTool.h"
#import "MTSort.h"
#import "UIView+Extension.h"
#import "MTConstant.h"

/** 自定义排序按钮 */
@interface MTSortButton : UIButton
/** 按钮中的排序模型 */
@property (nonatomic, strong) MTSort *sort;
@end

@implementation MTSortButton
/**
 *  初始化操作
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置普通状态
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        
        //设置高亮状态
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setSort:(MTSort *)sort{
    _sort = sort;
    //设置按钮文字
    [self setTitle:sort.label forState:UIControlStateNormal];
}

@end

//自定义排序按钮 -- end

@interface MTSortViewController ()

@end

@implementation MTSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化按钮
    
    NSArray *sorts = [MTDataTool sorts];
    CGFloat btnW = 120;
    CGFloat btnH = 44;
    CGFloat btnX = 15;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    CGFloat height = 0;
    
    for (int i = 0; i<sorts.count; i++) {
        MTSortButton *sortBtn = [MTSortButton buttonWithType:UIButtonTypeCustom];
        sortBtn.sort = sorts[i];
        sortBtn.width = btnW;
        sortBtn.height = btnH;
        
        sortBtn.x = btnX;
        sortBtn.y = btnStartY + i * (btnH + btnMargin);
        
        [sortBtn addTarget:self action:@selector(sortChange:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:sortBtn];
        
        height = CGRectGetMaxY(sortBtn.frame);
    }
    
    //设置popover的尺寸
    CGFloat width = btnW + 2 * btnX;
    height += btnMargin;
    self.preferredContentSize = CGSizeMake(width, height);
    
}

- (void)sortChange:(MTSortButton *)btn{
    
    //发送通知
    [MTNotificationCenter postNotificationName:MTSortDidChangeNotification object:nil userInfo:@{MTSelectSort : btn.sort}];
}





@end
