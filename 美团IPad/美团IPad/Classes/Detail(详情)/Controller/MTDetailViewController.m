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

@interface MTDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MTHomeBg;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
}

/**
 *  返回控制器支持的方向(横屏)
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}



@end
