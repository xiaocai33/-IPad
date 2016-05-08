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
#import "MTDealsCell.h"
#import "MTDeals.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"

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
/** 服务器返回数据模型 */
@property (nonatomic, strong) NSMutableArray *deals;

/** 选择加载的页数 */
@property (nonatomic, assign) int currentPage;
/** 最后一次请求 */
@property (nonatomic, strong) DPRequest *lastRequest;
/** 返回数据的条数 */
@property (nonatomic, assign) int totalCount;


@end

@implementation MTHomeCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)deals{
    if (_deals == nil) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}

- (instancetype)init{
    //流水布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(322, 322);
    
    return [self initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注意在collection中self.view == self.collectionView.superview;
    self.collectionView.backgroundColor = MTHomeBg;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[MTDealsCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    
    //设置导航栏内容
    [self setupRightNav];//右边内容
    [self setupLeftNav];//左边内容
    
    /** 监听通知 */
    [self setupNotication];
    
    //添加上拉刷新
    [self.collectionView addFooterWithTarget:self action:@selector(loadOldDeals)];
    
    //添加下拉刷新
    [self .collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
}

- (void)dealloc{
    //移除通知
    [MTNotificationCenter removeObserver:self];
}

/**
 *  监听通知
 */
- (void)setupNotication{
    // 监听城市改变通知
    [MTNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:MTCityDidChangeNotification object:nil];
    
    // 监听排序改变通知
    [MTNotificationCenter addObserver:self selector:@selector(sortDidChange:) name:MTSortDidChangeNotification object:nil];
    
    // 监听分类数据改变通知
    [MTNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:MTCategoryDidChangeNotification object:nil];
    
    // 监听区域数据改变通知
    [MTNotificationCenter addObserver:self selector:@selector(regionDidChange:) name:MTRegionDidChangeNotification object:nil];
}

#pragma mark - 监听屏幕旋转
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    int cols = (size.width == 1024 ? 3 : 2);
    // 根据列数计算内边距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    int inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    // 设置每一行之间的间距
    layout.minimumLineSpacing = inset;
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
    [self.collectionView headerBeginRefreshing];
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
    [self.collectionView headerBeginRefreshing];
    
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
    [self.collectionView headerBeginRefreshing];
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
    [self.collectionView headerBeginRefreshing];
}

#pragma mark - 与服务器交互的代码
- (void)loadDeals{
    DPAPI *api = [[DPAPI alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //城市
    params[@"city"] = self.selectedCityName;
    //每次的条数
    params[@"limit"] = @(30);
    
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
    
    // 页码
    params[@"page"] = @(self.currentPage);
    
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
    //MTLog(@"参数--%@", params);

}
/** 上拉刷新 */
- (void)loadOldDeals{
    
    self.currentPage++;
    
    [self loadDeals];
}

- (void)loadNewDeals{
    
    self.currentPage = 1;
    
    [self loadDeals];
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    //MTLog(@"请求成功---%@", result);
    if (self.lastRequest != request) return;
    self.totalCount = [result[@"total_count"] intValue];
    
    // 1.取出团购的字典数组
    NSArray *newDeals = [MTDeals objectArrayWithKeyValuesArray:result[@"deals"]];
    
    if (self.currentPage == 1) {
        //清除旧数据
        [self.deals removeAllObjects];
    }
    
    [self.deals addObjectsFromArray:newDeals];
    
    //2 刷新表格(在刷新表格的中,结束刷新)
    [self.collectionView reloadData];
    
    // 结束刷新操作
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    // 1.网络提醒
    [MBProgressHUD showError:@"网络繁忙,稍后再试..." toView:self.view];
    
    // 2.结束刷新操作
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    
    // 3.如果是上拉加载失败了
    if (self.currentPage > 1) {
        self.currentPage--;
    }
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //MTLog(@"%zd", self.deals.count);
   
    //设置下拉控件的显示
    self.collectionView.footerHidden = (self.totalCount == self.deals.count);
    
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTDealsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.deal = self.deals[indexPath.item];
    
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
