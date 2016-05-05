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
#import "MTRegionViewController.h"
#import "MTSortViewController.h"
#import "MTSort.h"
#import "MTCitiy.h"
#import "MTDataTool.h"
#import "MTCategory.h"
#import "MTRegion.h"
#import "DPAPI.h"

@interface MTHomeCollectionController () <DPRequestDelegate>
/** 分类 */
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
/** 地区 */
@property (nonatomic, weak) UIBarButtonItem *regionTopView;
/** 排序 */
@property (nonatomic, weak) UIBarButtonItem *sortedItem;

/** 分类 popover */
@property (nonatomic, strong) UIPopoverController *categoryPopover;
/** 地区 popover */
@property (nonatomic, strong) UIPopoverController *regionPopover;
/** 排序 popover */
@property (nonatomic, strong) UIPopoverController *sortPopover;

/** 当前选中的城市 */
@property (nonatomic, copy) NSString *selectedCityName;
/** 当前选中的区域 */
@property (nonatomic, copy) NSString *selectedRegionName;
/** 当前选中的分类 */
@property (nonatomic, copy) NSString *selectedCategoryName;
/** 当前选中的排序 */
@property (nonatomic, strong) MTSort *selectedSort;

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
    
    // 监听城市改变通知
    [MTNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:MTCityDidChangeNotification object:nil];
    
    // 监听排序改变通知
    [MTNotificationCenter addObserver:self selector:@selector(sortDidChange:) name:MTSortDidChangeNotification object:nil];
    
    // 监听分类数据改变通知
    [MTNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:MTCategoryDidChangeNotification object:nil];
    
    // 监听区域数据改变通知
    [MTNotificationCenter addObserver:self selector:@selector(regionDidChange:) name:MTRegionDidChangeNotification object:nil];

}

- (void)dealloc{
    //移除通知
    [MTNotificationCenter removeObserver:self];
}

#pragma mark - 监听通知方法
/**
 *  监听城市改变通知方法
 */
- (void)cityDidChange:(NSNotification *)noti{
    // 1 得到数据
    self.selectedCityName = noti.userInfo[MTSelectCityName];
    
    // 2 改变导航栏上的显示标题
    MTHomeLeftTopItem *topItem = (MTHomeLeftTopItem *)self.regionTopView.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - 全部", self.selectedCityName]];
    
    // 3 从服务加载数据
    [self loadNewDeals];
}

/**
 *  监听排序数据改变通知方法
 */
- (void)sortDidChange:(NSNotification *)noti{
    // 1 得到数据
    MTSort *sort = noti.userInfo[MTSelectSort];
    
    self.selectedSort = sort;
    
    // 2 改变Item上的显示标题
    MTHomeLeftTopItem *topItem = (MTHomeLeftTopItem *)self.sortedItem.customView;
    [topItem setSubTitle:sort.label];
    
    // 3 关闭popover
    [self.sortPopover dismissPopoverAnimated:YES];
    
    // 4 从服务加载数据
    [self loadNewDeals];
    
}

/**
 *  监听分类数据改变通知方法
 */
- (void)categoryDidChange:(NSNotification *)noti{
    // 1 得到数据
    MTCategory *category = noti.userInfo[MTSelectCategory];
    NSString *subcategoryName = noti.userInfo[MTSelectSubcategoryName];
    
    if (subcategoryName == nil || [subcategoryName isEqualToString:@"全部"]) {//点击的分类没有子数据
        self.selectedCategoryName = category.name;
    } else { //单击了子分类
        self.selectedCategoryName = subcategoryName;
    }
    
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    // 2 改变Item上的显示标题
    MTHomeLeftTopItem *topItem = (MTHomeLeftTopItem *)self.categoryItem.customView;
    [topItem setTitle:category.name];
    [topItem setSubTitle:subcategoryName];
    [topItem setIcon:category.icon heighlightIcon:category.highlighted_icon];
    
    // 3 关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 4 从服务加载数据
    [self loadNewDeals];
}

/**
 *  监听区域数据改变通知方法
 */
- (void)regionDidChange:(NSNotification *)noti{
    // 1 得到数据
    MTRegion *region = noti.userInfo[MTSelectRegion];
    NSString *subregionName = noti.userInfo[MTSelectSubregionName];
    
    if (subregionName == nil || [subregionName isEqualToString:@"全部"]) {//点击的区域没有子数据
        self.selectedRegionName = region.name;
    } else {
        self.selectedRegionName = subregionName;
    }
    
    if ([self.selectedRegionName isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
    
    // 2 改变Item上的显示标题
    MTHomeLeftTopItem *topItem = (MTHomeLeftTopItem *)self.regionTopView.customView;
    NSString *titleName = [NSString stringWithFormat:@"%@ - %@", self.selectedCityName, region.name];
    [topItem setTitle:titleName];
    [topItem setSubTitle:subregionName];
    
    // 3 关闭popover
    [self.regionPopover dismissPopoverAnimated:YES];
    
    // 4 从服务加载数据
    [self loadNewDeals];
}

#pragma mark - 与服务器交互的代码
- (void)loadNewDeals{
    DPAPI *api = [[DPAPI alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //城市
    params[@"city"] = self.selectedCityName;
    //每次的条数
    params[@"limit"] = @(5);
    
    //分类
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    //区域
    if (self.selectedRegionName) {
        params[@"region"] = self.selectedRegionName;
    }
    
    //排序
    if (self.selectedSort) {
        params[@"sort"] = @(self.selectedSort.value);
    }
    
    
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
    MTLog(@"参数--%@", params);
    
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    MTLog(@"请求成功---%@", result);
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    MTLog(@"请求失败---%@", error);
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
    MTHomeLeftTopItem *regionTopView = [MTHomeLeftTopItem item];
    [regionTopView addTarget:self action:@selector(regionAction)];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:regionTopView];
    self.regionTopView = regionItem;
    
    // 4.排序
    MTHomeLeftTopItem *sortedTopView = [MTHomeLeftTopItem item];
    [sortedTopView addTarget:self action:@selector(sortedAction)];
    [sortedTopView setTitle:@"排序"];
    [sortedTopView setIcon:@"icon_sort" heighlightIcon:@"icon_sort_highlighted"];
    
    UIBarButtonItem *sortedItem = [[UIBarButtonItem alloc] initWithCustomView:sortedTopView];
    self.sortedItem = sortedItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, regionItem, sortedItem];
}

#pragma mark - 监听事件
/**
 *  监听点击事件 -- 分类控制器
 */
- (void)categoryAction{
    UIPopoverController *categoryPopover = [[UIPopoverController alloc] initWithContentViewController:[[MTCategoryViewController alloc] init]];

    [categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    self.categoryPopover = categoryPopover;
}

/**
 *  监听点击事件 -- 区域控制器
 */
- (void)regionAction{
    MTRegionViewController *regionVc = [[MTRegionViewController alloc] init];
    
    if (self.selectedCityName) {
        //根据得到的城市名称,获得当前的city模型
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", self.selectedCityName];
        MTCitiy *city = [[[MTDataTool cities] filteredArrayUsingPredicate:predicate] firstObject];
        regionVc.regions = city.regions;
    }
    
    UIPopoverController *regionPopover = [[UIPopoverController alloc] initWithContentViewController:regionVc];
    
    regionVc.regionPopover = regionPopover;
    
    [regionPopover presentPopoverFromBarButtonItem:self.regionTopView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    self.regionPopover = regionPopover;
}

/**
 *  监听点击事件 -- 排序控制器
 */
- (void)sortedAction{
    UIPopoverController *sortPopover = [[UIPopoverController alloc] initWithContentViewController:[[MTSortViewController alloc] init]];
    
    [sortPopover presentPopoverFromBarButtonItem:self.sortedItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    self.sortPopover = sortPopover;
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
