//
//  SettingViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/21.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "SettingViewController.h"
#import "CydzViewController.h"
#import "BzFkViewController.h"
#import "FltkViewController.h"
#import "AboutAnDunViewController.h"
#import "LoginViewController.h"
#import "Manager.h"
#import "ViewController.h"


@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *cydzView;
@property (weak, nonatomic) IBOutlet UIView *hpadView;
@property (weak, nonatomic) IBOutlet UIView *fltkView;
@property (weak, nonatomic) IBOutlet UIView *gyadView;
@property (weak, nonatomic) IBOutlet UIView *bzfkView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    
    UIScrollView *backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backScrollView.backgroundColor = [UIColor whiteColor];
    
    backScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT+1);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backScrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *bodyview = [[[NSBundle mainBundle]loadNibNamed:@"SetView" owner:self options:nil]lastObject];
    bodyview.frame = self.view.bounds;
    [backScrollView addSubview:bodyview];
    [self addTapOnView];
    
}
-(void)addTapOnView
{
    DbgLog(@"添加手势");
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];
    [_cydzView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];
    [_hpadView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];
    [_bzfkView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];
    [_fltkView addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];
    [_gyadView addGestureRecognizer:tap5];
}

-(void)onTapView:(UITapGestureRecognizer *)sender
{
    DbgLog(@"点击了%ld",(long)sender.view.tag);
    switch (sender.view.tag) {
        case 101:
        {
            CydzViewController *cyVC = [[CydzViewController alloc]initWithNibName:@"CydzViewController" bundle:nil];
            [self.navigationController pushViewController:cyVC animated:YES];
            
        }
            break;
        case 102:
        {
            
            NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d",1052119488];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }
            break;
        case 103:
        {
            BzFkViewController *bzVC = [[BzFkViewController alloc]initWithNibName:@"BzFkViewController" bundle:nil];
            [self.navigationController pushViewController:bzVC animated:YES];
            
        }
            break;
        case 104:
        {
            FltkViewController *cyVC = [[FltkViewController alloc]initWithNibName:@"FltkViewController" bundle:nil];
            [self.navigationController pushViewController:cyVC animated:YES];
            
        }
            break;
        case 105:
        {
            AboutAnDunViewController *cyVC = [[AboutAnDunViewController alloc]initWithNibName:@"AboutAnDunViewController" bundle:nil];
            [self.navigationController pushViewController:cyVC animated:YES];
            
        }
            break;
        default:
            break;
    }
}

-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"xiabiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"设置";
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
- (IBAction)onLogoutBtnClick:(UIButton *)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/getQuit"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:@"2" forKey:@"uonline"];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        
    }];
    
    [APService setAlias:@"ios" callbackSelector:nil object:nil];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            DbgLog(@"退出成功");
            [self showHint:@"退出成功" yOffset:-200];
        }
    } onQueue:nil];
    
    Manager *mng = [Manager manager];
    ViewController *vc = mng.mainView;
    [mng.menuVC reloadMenuDataAndView];
    [vc friendReal];
//需要清楚地图所有的坐标。
    
    [userDef removeObjectForKey:@"info"];
    [userDef removeObjectForKey:@"jingxiCount"];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:loginVC animated:YES];
    

}
- (IBAction)yxkgValueChange:(UISwitch *)sender {
    
}


@end
