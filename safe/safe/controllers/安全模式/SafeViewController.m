//
//  SafeViewController.m
//  safe
//
//  Created by andun on 15/10/5.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "SafeViewController.h"
#import "UrgentFriendViewController.h"
#import "BaoPingAnViewController.h"
#import "MyZoneViewController.h"
#import "JInJilxrTbVController.h"

@interface SafeViewController () <MyZoneViewControllerDelegate>

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self customUI];
    [self custNaviItm];
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"xiabiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"安全设置";
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

- (void)customUI
{
    _myView.tag = 100;
    [self addTapOnView:_myView];
    _urGentView.tag = 101;
    [self addTapOnView:_urGentView];
    _baopinganView.tag = 102;
    [self addTapOnView:_baopinganView];

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapClick:)];
//    [_myView addGestureRecognizer:tap];
//    
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap1Click:)];
//    [_urGentView addGestureRecognizer:tap1];
//    
}
-(void)addTapOnView:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapView:)];
    [view addGestureRecognizer:tap];
}
-(void)OnTapView:(UITapGestureRecognizer *)sender
{
    DbgLog(@"%ld",(long)sender.view.tag);
    switch (sender.view.tag) {
        case 100:
        {
//            if([self.delegate respondsToSelector:@selector(safeViewController:)])
//            {
//                [self.delegate safeViewController:self];
//            }
//            [self.navigationController popViewControllerAnimated:YES];
            MyZoneViewController *mzVC = [[MyZoneViewController alloc]init];
            
            mzVC.localSafeArray2 = _localSafeArray;
            
            mzVC.delegate = self;
            
            [self.navigationController pushViewController:mzVC animated:YES];
            
        }
            break;
        case 101:
        {
//            UrgentFriendViewController *urVC = [[UrgentFriendViewController alloc] init];
//            
//            [self.navigationController pushViewController:urVC animated:YES];
            JInJilxrTbVController *jjV = [[JInJilxrTbVController alloc]init];
            [self.navigationController pushViewController:jjV animated:YES];
        }
            break;
        case 102:
        {
            BaoPingAnViewController *bpaVc = [[BaoPingAnViewController alloc]initWithNibName:@"BaoPingAnViewController" bundle:nil];
            [self.navigationController pushViewController:bpaVc animated:YES];
            
        }
            break;
        case 103:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)MyZoneViewController:(MyZoneViewController *)myZoneViewController
{
    
    if([self.delegate respondsToSelector:@selector(safeViewController:)])
    {
        [self.delegate safeViewController:self];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
