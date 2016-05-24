//
//  HowUseViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/6.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "HowUseViewController.h"

@interface HowUseViewController ()
@property (weak, nonatomic) IBOutlet UITextView *BodyTextView;

@end

@implementation HowUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    self.navigationItem.title = _naviTitle;
    if ([_naviTitle isEqualToString:@"如何使用出行模式"]) {
        _BodyTextView.text = [self readFrom:@"chuxing"];
    }else if ([_naviTitle isEqualToString:@"如何使用安全模式"]){
        _BodyTextView.text = [self readFrom:@"anquan"];
    }else if ([_naviTitle isEqualToString:@"客户端使用"]){
        _BodyTextView.text = [self readFrom:@"shiyong"];
    }else if ([_naviTitle isEqualToString:@"雇佣与支付"]){
        _BodyTextView.text = [self readFrom:@"guyongzhifu"];
    }else if ([_naviTitle isEqualToString:@"优惠与活动"]){
        _BodyTextView.text = [self readFrom:@"youhuiyuhuodong"];
    }

}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
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
-(NSString *)readFrom:(NSString *)tfName
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:tfName ofType:@"txt"];
    NSString *retString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return retString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
