//
//  PingLunViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/3.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "PingLunViewController.h"

@interface PingLunViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PingLunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    // Do any additional setup after loading the view from its nib.
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"评论";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
    
    UIButton *sendbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendbtn.frame = CGRectMake(0, 0, 25, 25);
    sendbtn.tintColor = [UIColor greenColor];
    [sendbtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sendbtn];
    [_textView becomeFirstResponder];
}
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onBckClick:(UIButton *)sender {
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSendClick:(UIButton *)sender {
    [_textView resignFirstResponder];
    if (_textView.text.length < 1) {
        [self showHint:@"评论内容过少！" yOffset:-200];
        [_textView becomeFirstResponder];
        return;
    }
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary: [userDef objectForKey:@"info"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/comment"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_photoID  forKey:@"photoId"];
    [param setValue:_textView.text forKey:@"comment"];
    DbgLog(@"发的参数%@-%@",strUrl,param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"修改成功 %@  date:%@",rspDic,rspDic[@"data"]);
        [self showHint:@"评论成功" yOffset:-100];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
//        [self showHint:@"出错了 " yOffset:-200];
        _textView.text = @"";
        [_textView becomeFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
