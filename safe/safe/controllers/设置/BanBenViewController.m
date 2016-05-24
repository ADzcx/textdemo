//
//  BanBenViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/17.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "BanBenViewController.h"

@interface BanBenViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *bodyScrollView;

@end

@implementation BanBenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    UIImage *img = [UIImage imageNamed:@"banbenjies"];
    DbgLog(@"这个图片%@",img);
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (img.size.height*SCREEN_WIDTH)/img.size.width)];
    [imgView setImage:img];
    _bodyScrollView.contentSize = CGSizeMake(0, imgView.frame.size.height);
    [_bodyScrollView addSubview:imgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"xiabiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"版本介绍";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
