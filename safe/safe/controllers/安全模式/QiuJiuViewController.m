//
//  QiuJiuViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/8.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "QiuJiuViewController.h"
#import "Manager.h"
@interface QiuJiuViewController ()
@property (weak, nonatomic) IBOutlet UILabel *miaoshuLabel;
@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic,assign) int currentCount;
@property (nonatomic,assign) int sendSos;
@end

@implementation QiuJiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    _currentCount = 5;
    _sendSos = 0;
    
    _timer = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(onTimerSOSClick)userInfo:nil repeats:YES];
    
    [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];

    [_timer fire];
    // Do any additional setup after loading the view from its nib.
}
-(void)custNaviItm
{
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(20, 20, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onSoSBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bkbtn];
}
-(void)onSoSBkBtnClick:(UIButton *)sender
{
    _sendSos = 1;
    [_timer setFireDate:[NSDate distantFuture]];
    
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)onTimerSOSClick
{
    DbgLog(@"%d",_currentCount);
    if(_currentCount != 1)
    {
        _miaoshuLabel.text = [NSString stringWithFormat:@"%d",_currentCount];
        _currentCount--;
    }else if (_currentCount == 1)
    {
        [_timer setFireDate:[NSDate distantFuture]];
        
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
        
        [self QiuZhuNow];
        _sendSos = 1;
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark 在这里发送求救
-(void)QiuZhuNow
{
///xxx.xxx.xxx.xxx:port/zrwt/sos/sms?token=xxx&longitude=222.22&altitude=11.11&pos=xxx
    if (_sendSos == 1) {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/sos/sms"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    Manager *safemng = [Manager manager];
    NSString *la = [NSString stringWithFormat:@"%f",safemng.mainView.localCoordinate.latitude];
    NSString *lo = [NSString stringWithFormat:@"%f",safemng.mainView.localCoordinate.longitude];
    NSString *po = [NSString stringWithFormat:@"%@",safemng.mainView.localAddress];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:lo forKey:@"longitude"];
    [param setValue:la forKey:@"altitude"];
    [param setValue:po forKey:@"pos"];
    DbgLog(@"发送的参数:%@",param);
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        if ([rspDic[@"code"] integerValue] == 200) {
            [self showHint:@"✅ 已办妥 " yOffset:-100];
        }
        //取出本地用户信息
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onQuxiaoBtnClick:(UIButton *)sender {
    _sendSos = 1;
    [_timer setFireDate:[NSDate distantFuture]];
    
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)on110Click:(UIButton *)sender {
    [self callPhone:@"110"];
}
- (IBAction)on120Click:(UIButton *)sender {
    [self callPhone:@"120"];
}
-(void)callPhone:(NSString*)phoneNumber
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}


@end
