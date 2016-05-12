//
//  MTDealsCell.h
//  美团IPad
//
//  Created by 小蔡 on 16/5/8.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTDeals, MTDealsCell;
@protocol MTDealsCellDelegate <NSObject>

- (void)dealCellCheckingStateDidChange:(MTDealsCell *)cell;

@end

@interface MTDealsCell : UICollectionViewCell

@property (nonatomic, strong) MTDeals *deal;
@property (nonatomic, weak) id<MTDealsCellDelegate> delegate;

@end
