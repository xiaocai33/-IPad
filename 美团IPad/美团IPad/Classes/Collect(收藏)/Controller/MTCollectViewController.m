//
//  MTCollectViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/8.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTCollectViewController.h"
#import "UIBarButtonItem+Extent.h"
#import "UIView+SDAutoLayout.h"
#import "MTConstant.h"
#import "MJRefresh.h"
#import "MTDealsCell.h"
#import "MTDetailViewController.h"
#import "MTDealTool.h"
#import "MTDeals.h"

#define MTEdit @"编辑"
#define MTDone @"完成"

@interface MTCollectViewController ()
/** 团购收藏数据 */
@property (nonatomic, strong) NSMutableArray *deals;
/** 没有收藏数据提示 */
@property (nonatomic, weak) UIImageView *noDataView;

/** 选择加载的页数 */
@property (nonatomic, assign) int currentPage;

/** 返回 UIBarButtonItem */
@property (nonatomic, strong) UIBarButtonItem *closeBtnItem;
/** 全选 UIBarButtonItem */
@property (nonatomic, strong) UIBarButtonItem *selectedAllBtnItem;
/** 全不选 UIBarButtonItem */
@property (nonatomic, strong) UIBarButtonItem *unSelectedAllBtnItem;
/** 删除 UIBarButtonItem */
@property (nonatomic, strong) UIBarButtonItem *deleteBtnItem;

@end

@implementation MTCollectViewController

static NSString * const reuseIdentifier = @"Cell";
/** 返回 UIBarButtonItem */
- (UIBarButtonItem *)closeBtnItem{
    if (!_closeBtnItem) {
        _closeBtnItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"icon_back" highlightedImage:@"icon_back_highlighted"];
    }
    return _closeBtnItem;
}

/** 全选 UIBarButtonItem */
- (UIBarButtonItem *)selectedAllBtnItem{
    if (!_selectedAllBtnItem) {
        _selectedAllBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"  全选  " style:UIBarButtonItemStylePlain target:self action:@selector(selectedAllDeal)];
    }
    return _selectedAllBtnItem;
}

/** 全不选 UIBarButtonItem */
- (UIBarButtonItem *)unSelectedAllBtnItem{
    if (!_unSelectedAllBtnItem) {
        _unSelectedAllBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"  全不选  " style:UIBarButtonItemStylePlain target:self action:@selector(unSelectedAllDeal)];
    }
    return _unSelectedAllBtnItem;
}

/** 删除 UIBarButtonItem */
- (UIBarButtonItem *)deleteBtnItem{
    if (!_deleteBtnItem) {
        _deleteBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"  删除  " style:UIBarButtonItemStylePlain target:self action:@selector(deleteDeal)];
        _deleteBtnItem.enabled = NO;
    }
    return _deleteBtnItem;
}


/** 团购收藏数据 */
- (NSMutableArray *)deals{
    if (!_deals) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}

/** 没有收藏数据提示 */
- (UIImageView *)noDataView{
    if (_noDataView == nil) {
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collects_empty"]];
        [self.view addSubview:noDataView];
        noDataView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view);
        
        _noDataView = noDataView;
    }
    return _noDataView;
}

- (instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(322, 322);
    
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加导航栏左边的按钮
//    UIBarButtonItem *closeBtnItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"icon_back" highlightedImage:@"icon_back_highlighted"];
    
    self.navigationItem.leftBarButtonItems = @[self.closeBtnItem];
    
    self.title = @"收藏的团购";
    
    //其他内容设置
    //注意在collection中self.view == self.collectionView.superview;
    self.collectionView.backgroundColor = MTHomeBg;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[MTDealsCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    [self loadMoreDeals];
    
    //添加上拉刷新
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    
    //接收收藏改变的通知
    [MTNotificationCenter addObserver:self selector:@selector(collectStateDidChange:) name:MTCollectStateDidChangeNotification object:nil];
    
    // 设置导航栏内容
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:MTEdit style:UIBarButtonItemStyleDone target:self action:@selector(editBtnClick:)];
    
}
- (void)dealloc{
    [MTNotificationCenter removeObserver:self];
}

- (void)collectStateDidChange:(NSNotification *)info{
//    if ([notification.userInfo[MTIsCollectKey] boolValue]) {
//        // 收藏成功
//        [self.deals insertObject:notification.userInfo[MTCollectDealKey] atIndex:0];
//    } else {
//        // 取消收藏成功
//        [self.deals removeObject:notification.userInfo[MTCollectDealKey]];
//    }
//
//    [self.collectionView reloadData];
    
    [self.deals removeAllObjects];
    
    self.currentPage = 0;
    
    [self loadMoreDeals];
}

#pragma mark - 上拉加载
- (void)loadMoreDeals{
    
    // 1.增加页码
    self.currentPage++;
    
    //2 添加新收藏数据
    NSArray *array = [MTDealTool collectDeals:self.currentPage];
    [self.deals addObjectsFromArray:array];
    
    //3 刷新表格
    [self.collectionView reloadData];
    
    //4 结束刷新
    [self.collectionView footerEndRefreshing];
}

#pragma mark - 导航栏按钮点击
/** 销毁控制器 */
- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 编辑 */
- (void)editBtnClick:(UIBarButtonItem *)btnItem{
    if ([btnItem.title isEqualToString:MTEdit]){//编辑 --> 完成
        btnItem.title = MTDone;
        self.navigationItem.leftBarButtonItems = @[self.closeBtnItem, self.selectedAllBtnItem, self.unSelectedAllBtnItem, self.deleteBtnItem];
        
        for (MTDeals *deal in self.deals) {
            deal.editing = YES;
        }
        
    } else{ // 完成 --> 编辑
        btnItem.title = MTEdit;
        self.navigationItem.leftBarButtonItems = @[self.closeBtnItem];
        for (MTDeals *deal in self.deals) {
            deal.editing = NO;
        }
    }
    
    [self.collectionView reloadData];
}

/** 全选 */
- (void)selectedAllDeal{
    for (MTDeals *deal in self.deals) {
        deal.checking = YES;
    }
    
    [self.collectionView reloadData];
    
    self.deleteBtnItem.enabled = YES;
}

/** 全部选 */
- (void)unSelectedAllDeal{
    for (MTDeals *deal in self.deals) {
        deal.checking = NO;
    }
    
    [self.collectionView reloadData];
    
    self.deleteBtnItem.enabled = NO;
}

/** 删除 */
- (void)deleteDeal{
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //MTLog(@"%zd", self.deals.count);
    [self viewWillTransitionToSize:collectionView.size withTransitionCoordinator:nil];
    
    //设置上拉控件的显示
    self.collectionView.footerHidden = ([MTDealTool collectDealsCount] == self.deals.count);
    
    //数据的显示
    self.noDataView.hidden = (self.deals.count != 0);
    
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTDealsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MTDetailViewController *detailVc = [[MTDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}
@end
