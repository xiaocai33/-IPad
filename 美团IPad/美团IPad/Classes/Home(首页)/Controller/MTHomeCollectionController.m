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
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"

#import "MTSearchViewController.h"
#import "MTNavigationController.h"
#import "AwesomeMenu.h"
#import "UIView+SDAutoLayout.h"
#import "MTCollectViewController.h"
#import "MTRecentViewController.h"
#import "MTMapViewController.h"

@interface MTHomeCollectionController () <AwesomeMenuDelegate>
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏内容
    [self setupRightNav];//右边内容
    [self setupLeftNav];//左边内容
    
    // 创建awesomemenu
    [self setupAwesomeMenu];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    /** 监听通知 */
    [self setupNotication];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //移除通知
    [MTNotificationCenter removeObserver:self];
}

#pragma mark - 创建awesomemenu
- (void)setupAwesomeMenu{
    //中间的item按钮
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:nil];
    
     //周边的item按钮
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    
    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];
    
    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    NSArray *items = @[item0, item1, item2, item3];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:items];
    menu.alpha = 0.5;
    // 设置菜单的活动范围
    menu.menuWholeAngle = M_PI_2;
    // 设置开始按钮的位置
    menu.startPoint = CGPointMake(50, 150);
    // 设置代理
    menu.delegate = self;
    // 不要旋转中间按钮
    menu.rotateAddButton = NO;
    
    
    [self.view addSubview:menu];
    
    menu.sd_layout.leftEqualToView(self.view).bottomEqualToView(self.view).heightIs(200).widthIs(200);
}

#pragma mark - AwesomeMenu代理方法
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu{
    //更换图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    
    // 完全显示
    menu.alpha = 1.0;
}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu{
    //更换图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    
    // 半透明显示
    menu.alpha = 0.5;
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    //更换图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    
    switch (idx) {
        case 0:{ // 收藏
            MTNavigationController *nav = [[MTNavigationController alloc] initWithRootViewController:[[MTCollectViewController alloc] init]];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 1:{ // 最近
            MTNavigationController *nav = [[MTNavigationController alloc] initWithRootViewController:[[MTRecentViewController alloc] init]];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 通知相关
//- (void)dealloc{
    //移除通知
    //[MTNotificationCenter removeObserver:self];
//}

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



#pragma mark - 设置导航栏按内容
/**
 *  设置导航栏右边的内容
 */
- (void)setupRightNav{
    
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:self action:@selector(mapBarDidClick) image:@"icon_map" highlightedImage:@"icon_map_highlighted"];
    mapItem.customView.width = 60;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchBarDidClick) image:@"icon_search" highlightedImage:@"icon_search_highlighted"];
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

#pragma mark - 监听导航栏按钮点击事件
/**
 *  监听地图按钮事件
 */
- (void)mapBarDidClick{
    MTMapViewController *mapVc = [[MTMapViewController alloc] init];
    MTNavigationController *nav = [[MTNavigationController alloc] initWithRootViewController:mapVc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  监听搜索按钮事件
 */
- (void)searchBarDidClick{
    if (self.selectedCityName) {
        MTSearchViewController *searchVc = [[MTSearchViewController alloc] init];
        searchVc.cityName = self.selectedCityName;
        MTNavigationController *nav = [[MTNavigationController alloc] initWithRootViewController:searchVc];
        
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"请选择城市后再搜索" toView:self.view];
    }
    
}

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

#pragma mark - 给父类传递参数
- (void)setupParams:(NSMutableDictionary *)params{
    //城市
    params[@"city"] = self.selectedCityName;
    
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
    
}


@end
