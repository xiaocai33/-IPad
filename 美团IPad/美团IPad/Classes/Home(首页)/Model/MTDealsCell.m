//
//  MTDealsCell.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/8.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTDealsCell.h"
#import "UIView+SDAutoLayout.h"

@interface MTDealsCell()

@property (nonatomic, weak) UIView *dealImageView;

@end

@implementation MTDealsCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //初始化内部控件操作
        [self setupContentView];
    }
    return self;
}
/**
 *  内部控件操作
 */
- (void)setupContentView{
    
    /**
     属性名不能以new开头
     */
    
    //图片控件
    UIImageView *dealImageView = [[UIImageView alloc] init];
    dealImageView.image = [UIImage imageNamed:@"placeholder_deal"];
    
    [self addSubview:dealImageView];
    self.dealImageView = dealImageView;
    
    //自动布局
    dealImageView.sd_layout
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .topSpaceToView(self, 10)
    .heightIs(185);
    
    //新单Image ic_deal_new
    UIImageView *dealNewView = [[UIImageView alloc] init];
    dealNewView.image = [UIImage imageNamed:@"ic_deal_new"];
    [self addSubview:dealNewView];
    
    //自动布局
    dealNewView.sd_layout
    .leftEqualToView(dealImageView)
    .topEqualToView(dealImageView)
    .heightIs(24)
    .widthIs(38);
    
    //底部描述\价格详情View
    [self setupDetailView];
}

/**
 *  设置底部控件的布局
 */
- (void)setupDetailView{
    UIView *detailView = [[UIView alloc] init];
    [self addSubview:detailView];
    
    detailView.sd_layout
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .bottomSpaceToView(self, 10)
    .topSpaceToView(self.dealImageView, 5);
    
    //设置容器中的控件
    //标题Label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.text = @"[丫丫] 烤鸭";
    
    [detailView addSubview:titleLabel];
    
    titleLabel.sd_layout.leftEqualToView(detailView).rightEqualToView(detailView).topEqualToView(detailView).heightIs(21);
    
    //团购信息描述信息
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font = [UIFont systemFontOfSize:14.0];
    descLabel.textColor = [UIColor grayColor];
    descLabel.text = @"哈哈大家哈减肥哈哈附加咖啡黑金卡回复,哈哈大家哈减肥哈哈附加咖啡黑金卡回复";
    
    [detailView addSubview:descLabel];
    
    descLabel.sd_layout.leftEqualToView(detailView).rightEqualToView(detailView).topSpaceToView(titleLabel, 5).heightIs(40);
    
    //当前价格
    UILabel *currentPriceLabel = [[UILabel alloc] init];
    currentPriceLabel.text = @"¥ 108";
    currentPriceLabel.textColor = [UIColor colorWithRed:200.0 green:54 blue:5 alpha:1.0];
    currentPriceLabel.font = [UIFont systemFontOfSize:20.0];
    //设置UILabel宽度自适应
    [currentPriceLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    [detailView addSubview:currentPriceLabel];
    
    currentPriceLabel.sd_layout.leftEqualToView(detailView).bottomEqualToView(detailView).heightIs(20);
    
    //历史价格
    UILabel *listPriceLabel = [[UILabel alloc] init];
    listPriceLabel.text = @"¥ 128";
    listPriceLabel.textColor = [UIColor grayColor];
    listPriceLabel.font = [UIFont systemFontOfSize:11.0];
    
    
    [detailView addSubview:listPriceLabel];
    
    listPriceLabel.sd_layout.leftSpaceToView(currentPriceLabel, 5).bottomEqualToView(detailView).heightIs(15);
    
    //销售量
    UILabel *purchaseCountLabel = [[UILabel alloc] init];
    purchaseCountLabel.text = @"200002";
    purchaseCountLabel.textColor = [UIColor grayColor];
    purchaseCountLabel.font = [UIFont systemFontOfSize:11.0];
    purchaseCountLabel.textAlignment = NSTextAlignmentRight;
    
    [detailView addSubview:purchaseCountLabel];
    
    purchaseCountLabel.sd_layout.rightEqualToView(detailView).bottomEqualToView(detailView).heightIs(15).widthIs(100);
    
}

- (void)drawRect:(CGRect)rect{
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
}

@end
