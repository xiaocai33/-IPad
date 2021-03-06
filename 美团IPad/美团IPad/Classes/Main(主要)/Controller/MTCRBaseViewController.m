//
//  MTCRBaseViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/12.
//  Copyright © 2016年 xiaocai. All rights reserved.
// 收藏界面 和 最近浏览界面的父类

#import "MTCRBaseViewController.h"

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

@interface MTCRBaseViewController () <MTDealsCellDelegate>
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

@implementation MTCRBaseViewController

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
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self setNoDataImage]]];
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
    
    // 设置导航栏内容
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:MTEdit style:UIBarButtonItemStyleDone target:self action:@selector(editBtnClick:)];
    
    //接收收藏改变的通知
    [MTNotificationCenter addObserver:self selector:@selector(collectStateDidChange:) name:MTCollectStateDidChangeNotification object:nil];
    
    //接收最近改变的通知
    [MTNotificationCenter addObserver:self selector:@selector(recentStateDidChange:) name:MTRecentStateDidChangeNotification object:nil];
    
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

- (void)recentStateDidChange:(NSNotification *)info{
    //NSLog(@"%@", info.userInfo[MTRecentDealKey]);
    if ([self.deals containsObject:info.userInfo[MTRecentDealKey]]) {//判断是否在当前数组中
        //先从数组中删除
        [self.deals removeObject:info.userInfo[MTRecentDealKey]];
    }
    
    //将记录插到数组的最前面
    [self.deals insertObject:info.userInfo[MTRecentDealKey] atIndex:0];
    //刷新表格
    [self.collectionView reloadData];
}


#pragma mark - 上拉加载
- (void)loadMoreDeals{
    
    // 1 页数加1
    self.currentPage++;
    
    //2 添加新收藏数据
    [self setupArray:self.deals withCount:self.currentPage];

    //[self.deals addObjectsFromArray:arrayM];
    
    //2 刷新表格
    [self.collectionView reloadData];
    
    //3 结束刷新
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
    //切记在遍历数组的时候,不能对当前遍历的数组进行删除\插入操作
    //解决办法:将要删除的数据,放到一个临时的数组中,然后删除
    NSMutableArray *tempArray = [NSMutableArray array];
    for (MTDeals *deal in self.deals) {
        if (deal.isChecking) {
            [tempArray addObject:deal];
            
            [self removeDeal:deal];
        }
    }
    
    // 删除所有打钩的模型
    [self.deals removeObjectsInArray:tempArray];
    [self.collectionView reloadData];
    self.deleteBtnItem.enabled = NO;
}

#pragma mark - cell的代理
- (void)dealCellCheckingStateDidChange:(MTDealsCell *)cell{
    BOOL checkStauts = NO;
    for (MTDeals *deal in self.deals) {
        if (deal.isChecking) {
            checkStauts = YES;
            break;
        }
    }
    // 根据有没有打钩的情况,决定删除按钮是否可用
    self.deleteBtnItem.enabled = checkStauts;
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
    self.collectionView.footerHidden = ([self allCount] == self.deals.count);
    
    //数据的显示
    self.noDataView.hidden = (self.deals.count != 0);
    
//    UIBarButtonItem *editBarBtn = self.navigationItem.rightBarButtonItem;
//    editBarBtn.enabled = (self.deals.count != 0);
//    if ([editBarBtn.title isEqualToString:MTDone]) {
//        [self editBtnClick:editBarBtn];
//    }
    
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTDealsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.deal = self.deals[indexPath.item];
    cell.delegate = self;
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MTDetailViewController *detailVc = [[MTDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}
@end
