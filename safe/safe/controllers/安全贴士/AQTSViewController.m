//
//  AQTSViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/26.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "AQTSViewController.h"

@interface AQTSViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *bodyWebView;
@property (nonatomic,strong)UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong)UIBarButtonItem *bkItm;
@property (nonatomic,strong)UIBarButtonItem *closeItm;
@property (nonatomic,assign) NSInteger clickNum;
@end

@implementation AQTSViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self custNaviItm];
    [self customUI];
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"xiabiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"安全贴士";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
}
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)customUI
{
    // Do any additional setup after loading the view from its nib.
    _clickNum = 0;
    _bodyWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,self.view.frame.size.height)];
    _bodyWebView.delegate = self;
    [_bodyWebView scalesPageToFit];
    _bodyWebView.scrollView.bounces = NO;
    NSString *strUrl = [NSString stringWithFormat:@"%@/client/tips",HeadUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [self.view addSubview: _bodyWebView];
    [_bodyWebView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void) webViewDidStartLoad:(UIWebView *)webView
{
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor darkGrayColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [_activityIndicator setCenter:view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    _clickNum ++;
    if (!_closeItm&&_clickNum > 1) {
        DbgLog(@"not exit");
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        backBtn.frame = CGRectMake(0, 0, 30, 30);
        [backBtn setTitle:@"后退" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(onBkClick:) forControlEvents:UIControlEventTouchUpInside];
        _bkItm = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = _bkItm;
        
        UIButton *clsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        clsBtn.frame = CGRectMake(0, 0, 30, 30);
        [clsBtn setTitle:@"退出" forState:UIControlStateNormal];
        [clsBtn addTarget:self action:@selector(onCloseClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeItm = [[UIBarButtonItem alloc]initWithCustomView:clsBtn];
        self.navigationItem.rightBarButtonItem = _closeItm;
    }
   
    [_activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"webViewDidFinishLoad");
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [self showHint:@"网络不好，请稍后再试" yOffset:-10];
    [view removeFromSuperview];
}

-(void)onBkClick:(UIButton *)sender
{
    [_bodyWebView goBack];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
}
-(void)onCloseClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}
@end
