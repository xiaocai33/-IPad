//
//  MTDealsBaseViewController.h
//  美团IPad
//
//  Created by 小蔡 on 16/5/8.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDealsBaseViewController : UICollectionViewController

/**
 *  由子控制器给父控制传递参数
 */
- (void)setupParams:(NSMutableDictionary *)params;

@end
