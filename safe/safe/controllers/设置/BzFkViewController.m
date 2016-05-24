//
//  BzFkViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/6.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "BzFkViewController.h"
#import "HowUseViewController.h"

@interface BzFkViewController ()
@property (weak, nonatomic) IBOutlet UIView *howUse1View;
@property (weak, nonatomic) IBOutlet UIView *howUse2View;


@end

@implementation BzFkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    [self addtap];
    // Do any additional setup after loading the view from its nib.
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"帮助与反馈";
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
-(void)addtap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];
    [_howUse1View addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];
    [_howUse2View addGestureRecognizer:tap1];
}

-(void)onTapView:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag) {
        case 100:
        {
            HowUseViewController *haoV = [[HowUseViewController alloc]init];
            haoV.naviTitle = @"如何使用安全模式";
            [self.navigationController pushViewController:haoV animated:YES];
        }
            break;
        case 101:
        {
            HowUseViewController *haoV = [[HowUseViewController alloc]init];
            haoV.naviTitle = @"如何使用出行模式";
            [self.navigationController pushViewController:haoV animated:YES];
        }
            break;
        case 102:
        {
            
        }
            break;
            
        default:
            break;
    }
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onKhdsyBtnClick:(UIButton *)sender {
    HowUseViewController *haoV = [[HowUseViewController alloc]init];
    haoV.naviTitle = @"客户端使用";
    [self.navigationController pushViewController:haoV animated:YES];
}
- (IBAction)onGyyzfBtnClick:(UIButton *)sender {
    HowUseViewController *haoV = [[HowUseViewController alloc]init];
    haoV.naviTitle = @"雇佣与支付";
    [self.navigationController pushViewController:haoV animated:YES];
}
- (IBAction)onYhyhdBtnClick:(UIButton *)sender {
    HowUseViewController *haoV = [[HowUseViewController alloc]init];
    haoV.naviTitle = @"优惠与活动";
    [self.navigationController pushViewController:haoV animated:YES];
}
- (IBAction)onZhyjfBtnClick:(UIButton *)sender {
   
}

- (IBAction)onCallClick:(UIButton *)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:010-65104917"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (IBAction)onKFClick:(UIButton *)sender {
    
    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"客服QQ:3046334727" message:@"请添加客服QQ咨询。" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alv show];
}




@end
