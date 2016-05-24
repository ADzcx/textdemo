//
//  ChangeViewController.m
//  safe
//
//  Created by XueYongWei on 15/9/15.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "ChangeViewController.h"

@interface ChangeViewController ()

@end

@implementation ChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    // Do any additional setup after loading the view.
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"请填写";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
    
    UIButton *donebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    donebtn.frame = CGRectMake(0, 0, 30, 30);
    donebtn.titleLabel.font = [UIFont systemFontOfSize:12];
    donebtn.tintColor = [UIColor greenColor];
    [donebtn setTitle:@"完成" forState:UIControlStateNormal];
    [donebtn addTarget:self action:@selector(onDoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:donebtn];
}
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onDoneBtnClick:(UIButton *)sender
{
    DbgLog(@"will send %@",_textView.text);
    [self.delegate  changeViewController:self needChangeTitle:_textView.text];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
