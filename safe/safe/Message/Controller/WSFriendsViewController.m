//
//  WSFriendsViewController.m
//  demo1
//
//  Created by 张晓檬 on 15/9/7.
//  Copyright (c) 2015年 zhirongweituo.com. All rights reserved.
//

#import "WSFriendsViewController.h"

#import "ContactsViewController.h"
#import "ChatListViewController.h"
#import "AddFriendViewController.h"

#define ViewFrame CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)

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

// 添加sementcontrol
- (void)setUpNavigationItem
{
    //设置导航条titleView
    UISegmentedControl *titleV = [[UISegmentedControl alloc] initWithItems:@[@"消息", @"好友"]];
    [titleV setTintColor:[UIColor colorWithRed:26/255.0 green:163/255.0 blue:146/255.0 alpha:1.0]];
    titleV.frame = CGRectMake(0, 0, self.view.bounds.size.width * 0.5, 30);
    //文字设置
    NSMutableDictionary *attDic = [NSMutableDictionary dictionary];
    attDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    attDic[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [titleV setTitleTextAttributes:attDic forState:UIControlStateNormal];
    [titleV setTitleTextAttributes:attDic forState:UIControlStateSelected];
    
    //事件
    titleV.selectedSegmentIndex = 0;
    [titleV addTarget:self action:@selector(titleViewChange:) forControlEvents:UIControlEventValueChanged];
    _titleView = titleV;
    self.navigationItem.titleView = _titleView;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //右上角按钮初始化
    //添加好友
    UIButton  *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addButton.frame=CGRectMake(0, 0, 44, 44);
    [addButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    _addBar = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    //清空聊天记录
    UIButton *delebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    delebutton.frame=CGRectMake(0, 0, 44, 44);
    [delebutton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [delebutton addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _deleteBar = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    
}

// 添加控制器数组
- (void)addChildViewControllers{
    //    [self addChildViewController:[[OneTableViewController alloc] init]];
    //    [self addChildViewController:[[TwoViewController alloc] init]];
    
    
    [self addChildViewController:[[ChatListViewController alloc] initWithNibName:nil bundle:nil]];
    [self addChildViewController:[[ContactsViewController alloc] initWithNibName:nil bundle:nil]];
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
        self.navigationItem.rightBarButtonItem = _deleteBar;
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
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:addController animated:YES];
}

@end
