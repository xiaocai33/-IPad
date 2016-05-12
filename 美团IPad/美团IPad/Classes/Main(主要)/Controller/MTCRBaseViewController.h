//
//  MTCRBaseViewController.h
//  美团IPad
//
//  Created by 小蔡 on 16/5/12.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTCRBaseViewController : UICollectionViewController

/**
 *  由子控制器给父控制传递参数
 */
- (void)setupArray:(NSMutableArray *)array withCount:(int)count;

@end
