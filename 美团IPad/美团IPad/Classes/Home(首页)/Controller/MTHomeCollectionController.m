//
//  MTHomeCollectionController.m
//  美团IPad
//
//  Created by 小蔡 on 16/4/29.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTHomeCollectionController.h"
#import "MTConstant.h"
#import "UIBarButtonItem+Extent.h"
#import "UIView+Extension.h"
#import "MTHomeLeftTopItem.h"
#import "MTCategoryViewController.h"
#import "MTDistrictViewController.h"

@interface MTHomeCollectionController ()
/** 分类 */
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
/** 地区 */
@property (nonatomic, weak) UIBarButtonItem *districtTopView;
/** 排序 */
@property (nonatomic, weak) UIBarButtonItem *sortedItem;

@end

@implementation MTHomeCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init{
    //流水布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    return [self initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注意在collection中self.view == self.collectionView.superview;
    self.collectionView.backgroundColor = MTHomeBg;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    //设置导航栏内容
    [self setupRightNav];//右边内容
    [self setupLeftNav];//左边内容
    
    // 监听城市改变
    [MTNotificationCenter addObserver:self selector:@selector(cityChange:) name:MTCityDidChangeNotification object:nil];

}

- (void)dealloc{
    //移除通知
    [MTNotificationCenter removeObserver:self];
}

#pragma mark - 监听通知方法
/**
 *  监听城市改变通知方法
 */
- (void)cityChange:(NSNotification *)noti{
    
    NSString *cityName = noti.userInfo[MTSelectCityName];
    
    MTHomeLeftTopItem *topItem = (MTHomeLeftTopItem *)self.districtTopView.customView;
    
    [topItem setTitle:[NSString stringWithFormat:@"%@ - 全部", cityName]];
    
}

#pragma mark - 设置导航栏按内容
/**
 *  设置导航栏右边的内容
 */
- (void)setupRightNav{
    
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_map" highlightedImage:@"icon_map_highlighted"];
    mapItem.customView.width = 60;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_search" highlightedImage:@"icon_search_highlighted"];
    searchItem.customView.width = 60;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}


/**
 *  设置导航栏左边的内容
 */
- (void)setupLeftNav{
    // 1.设置logo
    UIBarButtonItem *logoItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_meituan_logo" highlightedImage:nil];
    logoItem.enabled = NO;
    
    // 2.类别
    MTHomeLeftTopItem *categoryTopView = [MTHomeLeftTopItem item];
    [categoryTopView addTarget:self action:@selector(categoryAction)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopView];
    self.categoryItem = categoryItem;
    
    // 3.地区
    MTHomeLeftTopItem *districtTopView = [MTHomeLeftTopItem item];
    [districtTopView addTarget:self action:@selector(districtAction)];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtTopView];
    self.districtTopView = districtItem;
    
    // 4.排序
    MTHomeLeftTopItem *sortedTopView = [MTHomeLeftTopItem item];
    [sortedTopView addTarget:self action:@selector(sortedAction)];
    UIBarButtonItem *sortedItem = [[UIBarButtonItem alloc] initWithCustomView:sortedTopView];
    self.sortedItem = sortedItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, districtItem, sortedItem];
}

#pragma mark - 监听事件
/**
 *  监听点击事件
 */
- (void)categoryAction{
    UIPopoverController *popoverC = [[UIPopoverController alloc] initWithContentViewController:[[MTCategoryViewController alloc] init]];

    [popoverC presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)districtAction{
    UIPopoverController *popoverC = [[UIPopoverController alloc] initWithContentViewController:[[MTDistrictViewController alloc] init]];
    
    [popoverC presentPopoverFromBarButtonItem:self.districtTopView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)sortedAction{

}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
