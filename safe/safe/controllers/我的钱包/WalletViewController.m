//
//  WalletViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/25.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "WalletViewController.h"
#import "JFdetailTableViewController.h"
#import "YEDetailTableViewController.h"
#import "ZKJTableViewController.h"
#import "CZViewController.h"
#import "TXViewController.h"


@interface WalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *yueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIView *jifenView;
@property (weak, nonatomic) IBOutlet UIView *youhuijuanView;
@property (weak, nonatomic) IBOutlet UIView *yueView;
@property (weak, nonatomic) IBOutlet UIView *tixianView;

@end

@implementation WalletViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self customData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTapOnView];
    [self custNaviItm];
    
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"我的钱包";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
}
-(void)customData
{
    NSUserDefaults *usDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *usDic = [usDef objectForKey:@"info"];
//    urest
    _yueLabel.text = [NSString stringWithFormat:@"%@",usDic[@"urest"]];
    
    
}
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addTapOnView
{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    _yueView.tag = 100;
     [_yueView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    _jifenView.tag = 200;
    [_jifenView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    _youhuijuanView.tag = 300;
    [_youhuijuanView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    _tixianView.tag = 400;
    [_tixianView addGestureRecognizer:tap4];
    
}
-(void)tapView:(UITapGestureRecognizer *)sender
{
    DbgLog(@"tap :%ld",(long)sender.view.tag);
    if (sender.view.tag == 100) {
        YEDetailTableViewController *yeVC = [[YEDetailTableViewController alloc]init];
        [self.navigationController pushViewController:yeVC animated:YES];
    }else if (sender.view.tag ==200){
        JFdetailTableViewController *jfvc = [[JFdetailTableViewController alloc]init];
        [self.navigationController pushViewController:jfvc animated:YES];
    }else if (sender.view.tag == 300){
        ZKJTableViewController *zkVC = [[ZKJTableViewController alloc]init];
        [self.navigationController pushViewController:zkVC animated:YES];
    }else if (sender.view.tag == 400){
        TXViewController *txVC = [[TXViewController alloc]init];
        [self.navigationController pushViewController:txVC animated:YES];
    }
    else
    {
        [self showHint:@"无触发事件" yOffset:-100];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onCZBtnClick:(UIButton *)sender {
    CZViewController *czVC = [[CZViewController alloc]init];
    [self.navigationController pushViewController:czVC animated:YES];
}
- (IBAction)onTXBtnClick:(UIButton *)sender {
    TXViewController *txVC = [[TXViewController alloc]init];
    [self.navigationController pushViewController:txVC animated:YES];
}


@end
