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

@interface MTDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

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



@end
