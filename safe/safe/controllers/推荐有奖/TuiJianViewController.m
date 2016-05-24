//
//  TuiJianViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/26.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#define UmengAppKey @"55f8df6f67e58e8fdc0001bb"

#define WXAPPID @"APPID"
#define WXAPPsecret @"APPsecret"
#define WXUrl @"www.weixin.com"

#import "TuiJianViewController.h"
#import "TXLTableViewController.h"
#import "CoreUMeng.h"
#import "CoreUmengShare.h"
#import "TJListController.h"

@interface TuiJianViewController ()

@end

@implementation TuiJianViewController
{
    NSString *_messageContent;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self prepareData];
    
    [self custNaviItm];
    
}

- (void)prepareData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/version/getVersionMsg"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSDictionary *dic = @{@"token":userDic[@"token"],@"type":@"ios"};//参数
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"%@",dic[@"data"]);
        
        _messageContent = dic[@"data"];
        
        
//        NSArray *downUrl = [dic[@"data"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
//        DbgLog(@"%@",downUrl[1]);
//        
//        [CoreUMeng umengSetAppKey:UmengAppKey];
//        
//        [CoreUMeng umengSetSinaSSOWithRedirectURL:@"http://www.baidu.com"];
//        //集成微信
//        [CoreUMeng umengSetWXAppId:WXAPPID appSecret:WXAPPsecret url:downUrl[1]];
//        //集成QQ
//        [CoreUMeng umengSetQQAppId:@"100424468" appSecret:@"c7394704798a158208a74ab60104f0ba" url:downUrl[1]];
//        [CoreUmengShare show:self text:dic[@"data"] image:[UIImage imageNamed:@"ICON80-01.png"]];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
    }];

    
    
}

-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"推荐有奖";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)onHaveGetMoneyClick:(UIButton *)sender {
    TJListController *tjVC = [[TJListController alloc]init];
    [self.navigationController pushViewController:tjVC animated:YES];
}
//点击推荐给通讯录好友时触发
- (IBAction)OnTuijianToTxlClick:(UIButton *)sender {
    
    TXLTableViewController *txlVC = [[TXLTableViewController alloc]init];
    
    txlVC.MsgContnt = _messageContent;
    
    [self.navigationController pushViewController:txlVC animated:YES];
    
    
    
}
- (IBAction)shareBtnClick:(UIButton *)sender {
    
    [self shareToSNS];
    
}

-(void)shareToSNS
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;

    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/version/getVersionMsg"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSDictionary *dic = @{@"token":userDic[@"token"],@"type":@"ios"};//参数
    
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        
        NSLog(@"%@",dic[@"data"]);
        
        NSArray *downUrl = [dic[@"data"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        DbgLog(@"%@",downUrl[1]);
        
        [CoreUMeng umengSetAppKey:UmengAppKey];
        
        [CoreUMeng umengSetSinaSSOWithRedirectURL:@"http://www.baidu.com"];
        //集成微信
        [CoreUMeng umengSetWXAppId:WXAPPID appSecret:WXAPPsecret url:downUrl[1]];
        //集成QQ
        [CoreUMeng umengSetQQAppId:@"100424468" appSecret:@"c7394704798a158208a74ab60104f0ba" url:downUrl[1]];
        [CoreUmengShare show:self text:dic[@"data"] image:[UIImage imageNamed:@"ICON80-01.png"]];


        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
    }];

    
}


@end
