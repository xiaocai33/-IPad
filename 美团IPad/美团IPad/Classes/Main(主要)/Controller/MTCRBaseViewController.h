//
//  MTCRBaseViewController.h
//  美团IPad
//
//  Created by 小蔡 on 16/5/12.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTDeals;
@interface MTCRBaseViewController : UICollectionViewController

/**
 *  由子控制器根据当前页数给父控制传递模型
 */
- (void)setupArray:(NSMutableArray *)array withCount:(int)count;
/**
 *  由子控制器根据当前页数给父控制传递模型总共的个数
 */
- (int)allCount;

/** 根据父控制得到的模型数据, 由子控制实现具体的数据库删除操作 */
- (void)removeDeal:(MTDeals *)deal;

/** 由子控件提供没有数据时,显示的图片 */
- (NSString *)setNoDataImage;

@end
