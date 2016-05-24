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

@interface MenuViewController ()
//菜单视图的列表视图
@property (weak, nonatomic) IBOutlet UIScrollView *bodyScrollView;
@property (weak, nonatomic) IBOutlet UIView *lastMenu;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;

@end

@implementation MenuViewController
{
    UIView *Menuview;
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
    
    
    self.navigationController.navigationBarHidden = YES;
    
    //    取出视图
    Menuview = [[[NSBundle mainBundle]loadNibNamed:@"MenuView" owner:self options:nil]lastObject];
    
    UIView *MenuADview = [[[NSBundle mainBundle]loadNibNamed:@"MenuADView" owner:self options:nil]lastObject];
    
    //    加入菜单底部的广告视图
    UITapGestureRecognizer *tapAD = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAD:)];
    
    MenuADview.frame = CGRectMake(20, self.view.bounds.size.height-80, self.view.bounds.size.width-40, 70);
    
    MenuADview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:MenuADview];
    [self.view bringSubviewToFront:MenuADview];
    [MenuADview addGestureRecognizer:tapAD];
    
    //添加菜单视图到背景滑动视图
#warning ❌menu增加时在xib里重新选择最后一个菜单为laseMenu
    _bodyScrollView.contentSize = CGSizeMake(self.view.frame.size.width-180, _lastMenu.frame.origin.y+_lastMenu.frame.size.height);
    //_bodyScrollView.backgroundColor = [UIColor yellowColor];
    
    NSLog(@"scrollView%@   scrollView%@  bounds:%@",NSStringFromCGSize(_bodyScrollView.contentSize),NSStringFromCGRect(_bodyScrollView.frame),NSStringFromCGRect(_bodyScrollView.bounds));
    
    
    Menuview.frame = CGRectMake(_bodyScrollView.bounds.origin.x, _bodyScrollView.bounds.origin.y,_bodyScrollView.bounds.size.width , _bodyScrollView.bounds.size.height-(CGFloat)MenuADview.bounds.size.height);
    
    //    _bodyScrollView.backgroundColor = [UIColor greenColor];
    [_bodyScrollView addSubview:Menuview];
    
    //    给菜单视图添加滑动返回手势
    UISwipeGestureRecognizer *MenuBack = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipGoBack:)];
    MenuBack.direction = UISwipeGestureRecognizerDirectionLeft;
    [Menuview addGestureRecognizer:MenuBack];
    
    //    循环给这些菜单视图添加点击事件
    int i=100;
    for (UIView *view in Menuview.subviews) {
        view.tag = i++;
        [self addTapOnView:view];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
}
-(void)reloadData
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/UserBytoken"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    //如果已经登录过
    if (userDic) {
        NSDictionary *parma = @{@"token":userDic[@"token"]};
        NSLog(@"token---->%@",parma);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:strUrl parameters:parma success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *user = rspDic[@"data"];
            NSLog(@"rspDIC -- %@",user);
    
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:user[@"uhimgurl"]] placeholderImage:[UIImage imageNamed:@"2"]];
            _userNickNameLabel.text = user[@"unickname"];
            _userPhoneLabel.text = user[@"uid"];
            DbgLog(@"set ok");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure :%@",error.localizedDescription);
        }];
    }

}
#pragma mark ---👋手势的添加与处理
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
//给菜单项添加手势
-(void)addTapOnView:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu:)];
    [view addGestureRecognizer:tap];
}
//手势触发的事件
-(void)tapMenu:(UITapGestureRecognizer *)sender
{
    Manager *manager = [Manager manager];
    DbgLog(@"点击了:%ld",(long)sender.view.tag);
    switch (sender.view.tag) {
        case 100://个人
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PersonDetailViewController *perVC = [story instantiateViewControllerWithIdentifier:@"PersonDetail"];
            NSLog(@"%@",manager.mainView);
            perVC.delegate = self;
            [manager.mainView.navigationController pushViewController:perVC animated:YES];
        }
            break;
        case 101://相册
        {
            alumTableViewController *alv = [[alumTableViewController alloc]init];
            [manager.mainView.navigationController pushViewController:alv animated:YES];

        }
            break;
        case 102://好友
        {
            WSFriendsViewController *fvc = [[WSFriendsViewController alloc]init];
              [manager.mainView.navigationController pushViewController:fvc animated:YES];
        }
            break;
        case 103://钱包
        {
            WalletViewController *waVC = [[WalletViewController alloc]init];
            [manager.mainView.navigationController pushViewController:waVC animated:YES];
        }
            break;
        case 104://推荐
        {
            
        }
            break;
        case 105://雇员
        {
            
        }
            break;
        case 106://贴士
        {
            
        }
            break;
        case 107://发现
        {
            
        }
            break;
        case 110://设置
        {
            SettingViewController *settvc = [[SettingViewController alloc]init];
            
            [manager.mainView.navigationController pushViewController:settvc animated:YES];
        }
            break;
        default:
            break;
    }
    [self.sideMenuViewController hideMenuViewController];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
