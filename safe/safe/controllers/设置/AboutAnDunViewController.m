//
//  AboutAnDunViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/17.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "AboutAnDunViewController.h"
#import "BanBenViewController.h"
#import "LixianViewController.h"


@interface AboutAnDunViewController ()
@property (weak, nonatomic) IBOutlet UIView *banbenjieshaoView;
@property (weak, nonatomic) IBOutlet UIView *lianxiwomen;

@end

@implementation AboutAnDunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBanben)];
    [_banbenjieshaoView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLianxi)];
    [_lianxiwomen addGestureRecognizer:tap2];

}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"xiabiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"关于安顿";
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
-(void)tapBanben
{
    BanBenViewController *bbvc = [[BanBenViewController alloc]initWithNibName:@"BanBenViewController" bundle:nil];
    [self.navigationController pushViewController:bbvc  animated:YES];
}
-(void)tapLianxi
{
    LixianViewController *lxVC = [[LixianViewController alloc]initWithNibName:@"LixianViewController" bundle:nil];
    [self.navigationController pushViewController:lxVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
