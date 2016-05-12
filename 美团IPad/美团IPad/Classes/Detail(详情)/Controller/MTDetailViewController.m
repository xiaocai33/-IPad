//
//  MTDetailViewController.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/9.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTDetailViewController.h"
#import "MTConstant.h"
#import "MTDeals.h"
#import "UIImageView+WebCache.h"
#import "DPAPI.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "MTRestrictions.h"
#import "MTDealTool.h"

@interface MTDetailViewController () <UIWebViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
/** 订单详情图片 */
@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
/** 订单名称 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 订单描述 */
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
/** 订单分享 */
@property (weak, nonatomic) IBOutlet UIButton *sharedBtn;
/** 订单收藏 */
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
/** 订单随时退 */
@property (weak, nonatomic) IBOutlet UIButton *refundableAnyTimeButton;
/** 订单是否需要提前预约 */
@property (weak, nonatomic) IBOutlet UIButton *reservationRequiredButton;
/** 订单剩余时间 */
@property (weak, nonatomic) IBOutlet UIButton *leftTimeButton;
/** 订单购买人数 */
@property (weak, nonatomic) IBOutlet UIButton *haveBuyNow;


@end

@implementation MTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MTHomeBg;
    
    //隐藏webView
    self.webView.hidden = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    //网络加载动画开始
    [self.activityIndicator startAnimating];
    
    //设置基本信息
    //设置团购标题和描述
    self.titleLabel.text = self.deal.title;
    self.desLabel.text = self.deal.desc;
    
    //当前购买人数
    [self.haveBuyNow setTitle:[NSString stringWithFormat:@"已售 %zd", self.deal.purchase_count] forState:UIControlStateNormal];
    
    //图片
    [self.dealImageView sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    //NSLog(@"%@", self.deal.image_url);
    
    //计算过期时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *deadline = [fmt dateFromString:self.deal.purchase_deadline];
    
    //延迟1天
    deadline = [deadline dateByAddingTimeInterval:24 * 3600];
    
    NSDate *now = [NSDate date];
    
    //获取日历对象
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [[NSCalendar currentCalendar] components:unit fromDate:now toDate:deadline options:0];
    
    if (cmps.day > 365) {
        [self.leftTimeButton setTitle:@"一年内不过期" forState:UIControlStateNormal];
    } else {
        [self.leftTimeButton setTitle:[NSString stringWithFormat:@"剩余%zd天%zd小时%zd分", cmps.day,cmps.hour,cmps.minute] forState:UIControlStateNormal];
    }
    
    //在子线程中执行
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 发送请求获得更详细的团购数据
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 页码
    params[@"deal_id"] = self.deal.deal_id;
    [api requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
    //});
    
    //NSLog(@"%@", self.deal.deal_id);
    //NSLog(@"%zd", [MTDealTool isCollected:self.deal]);
    //判断当前团购是否被收藏
    self.collectBtn.selected = [MTDealTool isCollected:self.deal];
    
    //判断当前团购是否已经被浏览过
    if ([MTDealTool isRecented:self.deal]) {//被浏览过
        [MTDealTool removeRecentDeal:self.deal];//从数据库删除
    }
    [MTDealTool addRecentDeal:self.deal];//插入数据库
    
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    
    //回到主线程加载界面
    //dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"%@",result);
    self.deal = [MTDeals objectWithKeyValues:[result[@"deals"] firstObject]];
        
    //设置退款预约消息
    self.refundableAnyTimeButton.selected = self.deal.restrictions.is_refundable;
    self.reservationRequiredButton.selected = self.deal.restrictions.is_reservation_required;
    //});
    
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    //回到主线程加载界面
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showError:@"网络超时,请稍后再试..." toView:self.view];
    });
}


#pragma mark - 返回控制器支持的方向
/**
 *  返回控制器支持的方向(横屏)
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //MTLog(@"%@--%@",self.deal.deal_id, webView.request.URL.absoluteString);
    if ([self.deal.deal_h5_url isEqualToString:webView.request.URL.absoluteString]) {
        NSString *deal_id = [self.deal.deal_id substringFromIndex:[self.deal.deal_id rangeOfString:@"-"].location + 1];
        //MTLog(@"%@", deal_id);
        //更多详情的界面
        NSString *urlStr = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@", deal_id];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        
    } else {//更多详情加载完成
        NSMutableString *js = [NSMutableString string];
        //删除头部header
        [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
        [js appendString:@"header.parentNode.removeChild(header);"];
        // 删除顶部的购买
        [js appendString:@"var box = document.getElementsByClassName('cost-box')[0];"];
        [js appendString:@"box.parentNode.removeChild(box);"];
        // 删除底部部的购买
        [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
        [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
        // 删除footer
        [js appendString:@"var footer = document.getElementsByTagName('footer')[0];"];
        [js appendString:@"footer.parentNode.removeChild(footer);"];

        //执行js代码
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        //显示webView
        self.webView.hidden = NO;
        //网络加载动画停止
        [self.activityIndicator stopAnimating];
        
//        //获得网页数据
//        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
//        NSLog(@"%@",html);
    }
}

/**
 *  返回上一个界面
 */
- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  收藏
 */
- (IBAction)collect:(UIButton *)btn {
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[MTCollectDealKey] = self.deal;
    
    if(btn.selected){//已经收藏过了 再次单击 移除
        [MTDealTool removeCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
        info[MTIsCollectKey] = @(NO);
    }else{ //收藏
        [MTDealTool addCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
        info[MTIsCollectKey] = @(YES);
    }
    
    //是否选中取反
    btn.selected = !btn.isSelected;
    
    //发送通知
    [MTNotificationCenter postNotificationName:MTCollectStateDidChangeNotification object:nil userInfo:info];
    
    
}

/**
 *  立即购买
 */
- (IBAction)buy {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.deal.deal_url]];
    
}


@end
