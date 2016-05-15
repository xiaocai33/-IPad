//
//  MTMTDealAnnotation.h
//  美团IPad
//
//  Created by 小蔡 on 16/5/15.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MTDealAnnotation : NSObject
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
/** 图片名 */
@property (nonatomic, copy) NSString *icon;
@end
