//
//  WSFriendsViewController.m
//  demo1
//
//  Created by 薛永伟 on 15/9/7.
//  Copyright (c) 2015年 zhirongweituo.com. All rights reserved.
//

#import "WSFriendsViewController.h"

#import "ContactsViewController.h"
#import "ChatListViewController.h"
#import "AddFriendViewController.h"
#import "FriendListViewController.h"
#import "AddFriendTbVController.h"

#define ViewFrame CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)

@interface WSFriendsViewController ()

//** 导航titileView */
@property (nonatomic, weak) UISegmentedControl *titleView;
- (IBAction)return:(id)sender;

@property (nonatomic, strong) UIBarButtonItem *addBar;
@property (nonatomic,strong) UIBarButtonItem *deleteBar;
@end

@implementation WSFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 创建sementcontrol
    [self setUpNavigationItem];
    
    // 添加控制器到父控制器
    [self addChildViewControllers];
    
    // 默认选中第一个
    [self switchController:0];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加sementcontrol
- (void)setUpNavigationItem
{
    //设置导航条titleView
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;

    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
    
    UISegmentedControl *titleV = [[UISegmentedControl alloc] initWithItems:@[@"消息", @"好友"]];
    [titleV setTintColor:[UIColor blackColor]];
    [titleV setBackgroundColor:[UIColor clearColor]];
    
    titleV.frame = CGRectMake(0, 0, 90, 30);
    titleV.layer.cornerRadius = 4;
    titleV.clipsToBounds = YES;
    //文字设置
    NSMutableDictionary *attDic = [NSMutableDictionary dictionary];
    attDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize:14];
    attDic[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    [titleV setTitleTextAttributes:attDic forState:UIControlStateNormal];
    
    NSMutableDictionary *noDic = [NSMutableDictionary dictionary];
    noDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize:14];
    noDic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [titleV setTitleTextAttributes:noDic forState:UIControlStateSelected];
    
    //事件
    titleV.selectedSegmentIndex = 0;
    [titleV addTarget:self action:@selector(titleViewChange:) forControlEvents:UIControlEventValueChanged];
    _titleView = titleV;
    self.navigationItem.titleView = _titleView;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //右上角按钮初始化
    //添加好友
    UIButton  *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addButton.frame=CGRectMake(0, 0, 25, 25);
    [addButton setImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    addButton.tintColor = [UIColor lightGrayColor];
    [addButton addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    _addBar = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    //清空聊天记录
    UIButton *delebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    delebutton.frame=CGRectMake(0, 0, 44, 44);
    [delebutton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [delebutton addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _deleteBar = [[UIBarButtonItem alloc]initWithCustomView:delebutton];
    
}

// 添加控制器数组
- (void)addChildViewControllers{
    [self addChildViewController:[[ChatListViewController alloc] initWithNibName:nil bundle:nil]];
    [self addChildViewController:[[FriendListViewController alloc] init]];
}

// 监听点击
- (void)titleViewChange:(UISegmentedControl *)sender{
    [self switchController:sender.selectedSegmentIndex];
}

// 切换控制器
- (void)switchController:(NSUInteger)index{
    for (int i = 0; i< self.childViewControllers.count; i++)
    {
        if (i != index)
        {
            UIViewController *vc = self.childViewControllers[i];
            if ([vc isViewLoaded])
            {  // view被创建了，才去访问它
                [vc.view removeFromSuperview];
            }
        }
    }
    //    控制器右rightBarButtonItem显示
    if (index == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = _addBar;
    }
    [self.childViewControllers[index] view].frame = ViewFrame;
    [self.view addSubview:[self.childViewControllers[index] view]];
}


- (IBAction)return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addFriendAction
{
//    AddFriendTbVController *addController = [[AddFriendTbVController alloc]init];
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:addController animated:YES];
}

@end
