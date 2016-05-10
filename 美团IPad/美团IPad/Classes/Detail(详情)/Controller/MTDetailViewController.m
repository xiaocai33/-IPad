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

@interface MTDetailViewController () <UIWebViewDelegate>
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
/** 订单过期退 */
@property (weak, nonatomic) IBOutlet UIButton *refundableExpireButton;
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
    
}

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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //显示webView
            self.webView.hidden = NO;
            //网络加载动画停止
            [self.activityIndicator stopAnimating];
        });
        
        
        
        
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
 *  立即购买
 */
- (IBAction)buy {
}

/**
 *  收藏
 */
- (IBAction)collect:(UIButton *)sender {
}



@end
