//
//  LevelViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/1.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "LevelViewController.h"
#import "HowToShengJiViewController.h"

@interface LevelViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *dengjiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;


@property (weak, nonatomic) IBOutlet UILabel *jifenshengyuLabel;
@property (weak, nonatomic) IBOutlet UILabel *dunhuiyuan;



@end

@implementation LevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    [self customUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"我的等级";
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
-(void)customUI
{
    NSUserDefaults *usDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *usDic = [usDef objectForKey:@"info"];
    
//    HXPWD = BCC720F2981D1A68DBD66FFD67560C37;
//    token = bod78cbW;
//    uage = 24;
//    ubirth = "1991-07-16";
//    ucredit = 0;
//    uemtoken = "\U672a\U8bbe\U7f6e";
//    ufreezedate = "";
//    uhimgurl = "http://i.iandun.com/andun/upload/15311484716/15311484716_250x250.jpg";
//    uid = 15311484716;
//    uidcard = 412702199107162377;
//    ulevel = 48;
//    uname = "\U859b\U6c38\U4f1f";
//    unickname = 15311484716;
//    unote = "\U672a\U8bbe\U7f6e";
//    uonline = 2;
//    upwd = BCC720F2981D1A68DBD66FFD67560C37;
//    urefid = "";
//    urefname = "";
//    uregdate = "2015-10-18";
//    urest = 0;
//    userName = 15311484716;
//    usex = 0;
//    usignname = "\U8ba9\U5fc3\U5b89\U987f\Uff0c\U5e73\U5b89\U4e00\U751f";
//    ustatus = 2;
//    utoken = bod78cbW;
    NSString *dengji = usDic[@"ucredit"];
    NSString *jifen = usDic[@"ulevel"];
    NSString *shouji = usDic[@"uid"];
    
    if ([dengji isEqualToString:@"0"]) {
        _dengjiLabel.text = @"安顿普通用户";
        _dunhuiyuan.text = @"一盾会员";
    }else if ([dengji isEqualToString:@"1"]){
        _dengjiLabel.text = @"安顿一盾用户";
        _dunhuiyuan.text = @"二盾会员";
    }else if ([dengji isEqualToString:@"2"]){
        _dengjiLabel.text = @"安顿二盾用户";
        _dunhuiyuan.text = @"三盾会员";
    }else if ([dengji isEqualToString:@"3"]){
        _dengjiLabel.text = @"安顿三盾用户";
        _dunhuiyuan.text = @"四盾会员";
    }else if ([dengji isEqualToString:@"4"]){
        _dengjiLabel.text = @"安顿四盾用户";
        _dunhuiyuan.text = @"五盾会员";
    }else if ([dengji isEqualToString:@"5"]){
        _dengjiLabel.text = @"安顿五盾用户";
        _dunhuiyuan.text = @"超级会员";
    }
    _jifenLabel.text = jifen;
    int jf = jifen.intValue;
    _jifenshengyuLabel.text = [NSString stringWithFormat:@"%d", 1000-jf];
    
    NSString *sj3 = [shouji substringToIndex:3];
    NSString *sj44 = [shouji substringToIndex:7];
    NSString *sj4 = [sj44 substringFromIndex:3];
    NSString *sj03 = [shouji substringFromIndex:7];
    NSString *phone = [NSString stringWithFormat:@"%@   %@   %@",sj3,sj4,sj03];
    _phoneLabel.text = phone;
    DbgLog(@"");
    
    
    DbgLog(@"");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onHowShengJiClick:(UIButton *)sender {
    HowToShengJiViewController *howVC = [[HowToShengJiViewController alloc]initWithNibName:@"HowToShengJiViewController" bundle:nil];
    [self.navigationController pushViewController:howVC animated:YES];
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
