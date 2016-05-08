//
//  MTDealsBaseViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/8.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTDealsBaseViewController.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+SDAutoLayout.h"
#import "DPAPI.h"
#import "MJRefresh.h"
#import "MTDealsCell.h"
#import "MTDeals.h"
#import "MTConstant.h"
#import "MJExtension.h"

@interface MTDealsBaseViewController () <DPRequestDelegate>

/** 服务器返回数据模型 */
@property (nonatomic, strong) NSMutableArray *deals;

/** 选择加载的页数 */
@property (nonatomic, assign) int currentPage;
/** 最后一次请求 */
@property (nonatomic, strong) DPRequest *lastRequest;
/** 返回数据的条数 */
@property (nonatomic, assign) int totalCount;
/** 显示没有数据的图片 */
@property (nonatomic, weak) UIImageView *noDataView;


@end

@implementation MTDealsBaseViewController

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)deals{
    if (_deals == nil) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}

- (UIImageView *)noDataView{
    if (_noDataView == nil) {
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        [self.view addSubview:noDataView];
        noDataView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view);
        
        _noDataView = noDataView;
    }
    return _noDataView;
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
    
    self.collectionView.alwaysBounceVertical = YES;
    
    //添加上拉刷新
    [self.collectionView addFooterWithTarget:self action:@selector(loadOldDeals)];
    
    //添加下拉刷新
    [self .collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
}



#pragma mark - 与服务器交互的代码
- (void)loadDeals{
    DPAPI *api = [[DPAPI alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self setupParams:params];
   
    //每次的条数
    params[@"limit"] = @(30);
    // 页码
    params[@"page"] = @(self.currentPage);
    
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
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
    
    //设置下拉控件的显示
    self.collectionView.footerHidden = (self.totalCount == self.deals.count);
    
    //数据的显示
    self.noDataView.hidden = (self.totalCount != 0);
    
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTDealsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

@end
