//
//  SettingViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/21.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIScrollView *backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backScrollView.backgroundColor = [UIColor darkGrayColor];
    backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:backScrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *bodyview = [[[NSBundle mainBundle]loadNibNamed:@"SetView" owner:self options:nil]lastObject];
    bodyview.frame = self.view.bounds;
    [backScrollView addSubview:bodyview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onLogoutBtnClick:(UIButton *)sender {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef removeObjectForKey:@"info"];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            DbgLog(@"退出成功");
            [self showHint:@"退出成功" yOffset:-200];
        }
    } onQueue:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
