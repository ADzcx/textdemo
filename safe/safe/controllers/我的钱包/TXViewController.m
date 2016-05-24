//
//  TXViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/25.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "TXViewController.h"
#import "CoreTFManagerVC.h"

@interface TXViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ketijineLabel;
@property (weak, nonatomic) IBOutlet UITextField *zhifubaozhanghaoTF;
@property (weak, nonatomic) IBOutlet UITextField *zhenshixingmingTF;
@property (weak, nonatomic) IBOutlet UITextField *tixianjineTF;

@end

@implementation TXViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tm1 = [TFModel modelWithTextFiled:_zhifubaozhanghaoTF inputView:nil name:@"" insetBottom:0];
        TFModel *tm2 = [TFModel modelWithTextFiled:_zhenshixingmingTF inputView:nil name:@"" insetBottom:0];
        TFModel *tm3 = [TFModel modelWithTextFiled:_tixianjineTF inputView:nil name:@"" insetBottom:0];
        return @[tm1,tm2,tm3];
    }];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [CoreTFManagerVC uninstallManagerForVC:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    [self customUI];
    _zhifubaozhanghaoTF.delegate = self;
    _zhenshixingmingTF.delegate = self;
    _tixianjineTF.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"提现";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
}
-(void)customUI
{
    NSUserDefaults *usDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *usDic = [usDef objectForKey:@"info"];
    //    urest
    _ketijineLabel.text = [NSString stringWithFormat:@"%@",usDic[@"urest"]];
}
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TF Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _tixianjineTF) {
        _tixianjineTF.text = [NSString stringWithFormat:@"%@元",_tixianjineTF.text];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSubmitClick:(UIButton *)sender {
    NSString *kt = _ketijineLabel.text;
    NSString *tx = _tixianjineTF.text;
    
    if (_zhifubaozhanghaoTF.text.length < 2) {
        [self showHint:@"请输入正确的支付宝账号！" yOffset:-10];
        return;
    }
    
    if (_zhenshixingmingTF.text.length < 2) {
        [self showHint:@"请输入真实姓名以便审核！" yOffset:-10];
        return;
    }
    
    if (tx.intValue > kt.intValue) {
        [self showHint:@"提现金额大于可用余额！" yOffset:-100];
        return;
    }
    if (_tixianjineTF.text.length < 1) {
        [self showHint:@"请输入正确的提现金额！" yOffset:-100];
        return;
    }
//    cash ：金额
//toType: 转账类型；0银行卡，1支付宝
//account: 帐号，银行卡或支付宝帐号
//name: 真实姓名
//xxx.xxx.xxx.xxx:port/zrwt/account/tocash?token=xxx&cash=100&toType=0&account=xxxx&name=xxx
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/account/tocash"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:tx forKey:@"cash"];
    [param setValue:@"1" forKey:@"toType"];
    [param setValue:_zhifubaozhanghaoTF.text forKey:@"account"];
    [param setValue:_zhenshixingmingTF.text forKey:@"name"];
    
    DbgLog(@"发送的数据是:%@",param);
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        [MBProgressHUD hideHUDForView:window animated:YES];
        //取出本地用户信息
        
        if ([[NSString stringWithFormat:@"%@",rspDic[@"code"]] isEqualToString:@"200"]) {
            [self showHint:rspDic[@"msg"] yOffset:-10];
            NSUserDefaults *usDef = [NSUserDefaults standardUserDefaults];
            NSDictionary *usDic = [usDef objectForKey:@"info"];
            //    urest
            int sy = kt.intValue - tx.intValue;
            [usDic setValue:[NSString stringWithFormat:@"%d",sy] forKey:@"urest"];
            [usDef synchronize];
            
            _ketijineLabel.text = [NSString stringWithFormat:@"%d",sy];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
    
}


@end
