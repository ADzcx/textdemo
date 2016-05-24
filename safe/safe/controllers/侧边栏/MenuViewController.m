//
//  MenuViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/10.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "MenuViewController.h"
#import "WSFriendsViewController.h"
#import "XSportLight.h"
#import "PersonDetailViewController.h"
#import "SettingViewController.h"
#import "Manager.h"
#import "alumTableViewController.h"
#import "WalletViewController.h"
#import "TuiJianViewController.h"
#import "GYZMViewController.h"
#import "AQTSViewController.h"
#import "FaXianViewController.h"
#import "XXTableViewController.h"
#import "MenuADView.h"

@interface MenuViewController ()
//菜单视图的列表视图
@property (weak, nonatomic) IBOutlet UIScrollView *bodyScrollView;
@property (weak, nonatomic) IBOutlet UIView *lastMenu;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImgView;

@end

@implementation MenuViewController
{
 Manager *manager;
}
#pragma mark ---🐯添加新的菜单使用方法
-(void)HowToUse
{
    /**薛永伟2015.9.12
     1.在/views/menuView.xib里绘制该菜单视图
     2.在此文件中的viewDidload里取出该视图并添加点击事件addTapOnview:
     3.根据点击视图的tag取出该视图处理响应事件
     **/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [Manager manager];
    manager.menuVC  = self;
    
    self.navigationController.navigationBarHidden = YES;
    
    //    取出视图
    MenuADView *menuADview = [[[NSBundle mainBundle]loadNibNamed:@"MenuADView" owner:self options:nil]lastObject];
    menuADview.frame =CGRectMake(0, self.view.bounds.size.height-80, self.view.bounds.size.width, 80);
    //加入菜单底部的广告视图
    UITapGestureRecognizer *tapAD = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAD:)];
    
    [menuADview addGestureRecognizer:tapAD];
    
    //给菜单视图添加滑动返回手势
    menuADview.backgroundColor = [UIColor whiteColor];

    NSUserDefaults *maUseDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *maUserDic = [maUseDef objectForKey:@"info"];
    if (maUserDic) {
        AFHTTPRequestOperationManager *MuAdmanager = [AFHTTPRequestOperationManager manager];
        MuAdmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
        MuAdmanager.requestSerializer.timeoutInterval = 20.0;
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/admin/icon/get"];
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setValue:maUserDic[@"token"] forKey:@"token"];
        [param setValue:@"person" forKey:@"iconId"];
        
        [MuAdmanager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
            
            [menuADview.adImgView sd_setImageWithURL:[NSURL URLWithString:rspDic[@"data"]] placeholderImage:[UIImage imageNamed:@"menvAdView"]];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure :%@",error.localizedDescription);
        }];

    }
    [self.view addSubview:menuADview];
    
    //添加菜单视图
    _bodyScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-80);
    UIView * Menuview = [[[NSBundle mainBundle]loadNibNamed:@"MenuView" owner:self options:nil]lastObject];
   
    _bodyScrollView.contentSize = CGSizeMake(0,_lastMenu.frame.origin.y + _lastMenu.frame.size.height);
    
    [_bodyScrollView addSubview:Menuview];
    [self addTapOnViews];
    [self reloadMenuDataAndView];
    [self reloadMenuDataAndViewVC:0];
}

#pragma mark ---👋给视图添加手势
-(void)addTapOnViews
{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu1:)];
    [_headView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu2:)];
    [_xiangceView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu3:)];
    [_haoyouView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu4:)];
    [_qianbaoView addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu5:)];
    [_tuijianView addGestureRecognizer:tap5];
    
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu6:)];
    [_zhaomuView addGestureRecognizer:tap6];
    
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu7:)];
    [_tieshiView addGestureRecognizer:tap7];
    
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu8:)];
    [_faxianView addGestureRecognizer:tap8];
    
    UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu9:)];
    [_lastMenu addGestureRecognizer:tap9];
    
    UITapGestureRecognizer *tap10 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu10:)];
    [_xiaoxiView addGestureRecognizer:tap10];
    
}
#pragma mark ---👋手势的处理
//在菜单栏左滑隐藏菜单栏
-(void)swipGoBack:(UISwipeGestureRecognizer *)swip
{
    if (swip.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.sideMenuViewController hideMenuViewController];
        DbgLog(@"aa");
    }
}
-(void)TapAD:(UITapGestureRecognizer *)sender
{
    DbgLog(@"AD!!!!");
}
-(void)tapMenu1:(UITapGestureRecognizer *)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonDetailViewController *perVC = [story instantiateViewControllerWithIdentifier:@"PersonDetail"];
    NSLog(@"%@",manager.mainView);
    perVC.delegate = self;
    [manager.mainView.navigationController pushViewController:perVC animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
-(void)tapMenu2:(UITapGestureRecognizer *)sender
{
    alumTableViewController *alv = [[alumTableViewController alloc]init];
    alv.isSelf = YES;
    alv.userId = _userPhoneLabel.text;
    [manager.mainView.navigationController pushViewController:alv animated:YES];
    [_xiangceBiao setImage:[UIImage imageNamed:@"xiangce"]];
    [self.sideMenuViewController hideMenuViewController];
}
-(void)tapMenu3:(UITapGestureRecognizer *)sender
{
    WSFriendsViewController *fvc = [[WSFriendsViewController alloc]init];
    [manager.mainView.navigationController pushViewController:fvc animated:YES];
    [_haoyouBiao setImage:[UIImage imageNamed:@"haoyou"]];
    [self.sideMenuViewController hideMenuViewController];
}
-(void)tapMenu4:(UITapGestureRecognizer *)sender
{
    WalletViewController *waVC = [[WalletViewController alloc]init];
    [manager.mainView.navigationController pushViewController:waVC animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
-(void)tapMenu5:(UITapGestureRecognizer *)sender
{
    TuiJianViewController *tjVC = [[TuiJianViewController alloc]init];
    [manager.mainView.navigationController pushViewController:tjVC animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
-(void)tapMenu6:(UITapGestureRecognizer *)sender
{
    GYZMViewController *gyVC = [[GYZMViewController alloc]init];
    [manager.mainView.navigationController pushViewController:gyVC animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
-(void)tapMenu7:(UITapGestureRecognizer *)sender
{
    AQTSViewController *atVC = [[AQTSViewController alloc]init];
    [manager.mainView.navigationController pushViewController:atVC animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
-(void)tapMenu8:(UITapGestureRecognizer *)sender
{
    FaXianViewController *fxVC = [[FaXianViewController alloc]init];
    [manager.mainView.navigationController pushViewController:fxVC animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
-(void)tapMenu9:(UITapGestureRecognizer *)sender
{
    DbgLog(@"点击了设置");
    SettingViewController *settvc = [[SettingViewController alloc]init];
    [manager.mainView.navigationController pushViewController:settvc animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
-(void)tapMenu10:(UITapGestureRecognizer *)sender
{
    DbgLog(@"点击了消息中心");
    XXTableViewController *xxVC = [[XXTableViewController alloc]init];
    [manager.mainView.navigationController pushViewController:xxVC animated:YES];
    [_xiaoxiBiao setImage:[UIImage imageNamed:@"gerenxiaoxi"]];
    [self.sideMenuViewController hideMenuViewController];
}
#pragma mark 🎬重新加载界面，数据为从本地获取
-(void)reloadMenuDataAndView
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    if (userDic) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:userDic[@"uhimgurl"]] placeholderImage:[UIImage imageNamed:@"icon_logo"]];
        DbgLog(@"---ucredit :%@",userDic[@"ucredit"]);
        //设置菜单栏的信息
        _userNickNameLabel.text = userDic[@"unickname"];
        _userPhoneLabel.text = userDic[@"userName"];
        [_levelImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@dengjidun",userDic[@"ucredit"]]]];
    }else
    {
        _userNickNameLabel.text = @"请登录";
        _userPhoneLabel.text = @"请登录";
        [_levelImgView setImage:[UIImage imageNamed:@"icon_logo"]];
    }
}
-(void)prepareHongdian
{
    
}
-(void)reloadMenuDataAndViewVC:(int)type
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    if (userDic) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:userDic[@"uhimgurl"]] placeholderImage:[UIImage imageNamed:@"2"]];
        DbgLog(@"---ucredit :%@",userDic[@"ucredit"]);
        //设置菜单栏的信息
        _userNickNameLabel.text = userDic[@"unickname"];
        _userPhoneLabel.text = userDic[@"userName"];
        [_levelImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@dengjidun",userDic[@"ucredit"]]]];
    }else
    {
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
