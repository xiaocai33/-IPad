//
//  MTSearchViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/8.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTSearchViewController.h"
#import "UIBarButtonItem+Extent.h"

@interface MTSearchViewController ()

@end

@implementation MTSearchViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init{
    //流水布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    return [self initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
     //添加导航栏左边的按钮
    UIBarButtonItem *closeBtnItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"icon_back" highlightedImage:@"icon_back_highlighted"];
   
    self.navigationItem.leftBarButtonItem = closeBtnItem;
    
    //设置导航栏的title为UISearchBar
    self.navigationItem.titleView = [[UISearchBar alloc] init];
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
