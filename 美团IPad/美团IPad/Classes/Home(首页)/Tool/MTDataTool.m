//
//  MTDataTool.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/4.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTDataTool.h"
#import "MJExtension.h"
#import "MTCitiy.h"
#import "MTCategory.h"
#import "MTSort.h"


@implementation MTDataTool

static NSArray *_cities;
+ (NSArray *)cities{
    if (_cities == nil) {
        _cities = [MTCitiy objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

static NSArray *_categories;
+ (NSArray *)categories{
    if (_categories == nil) {
        _categories = [MTCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

static NSArray *_sorts;
+ (NSArray *)sorts{
    if (_sorts == nil) {
        _sorts = [MTSort objectArrayWithFilename:@"cities.plist"];
    }
    return _sorts;
}

@end
