//
//  WalletViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/25.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "WalletViewController.h"
#import "JFdetailTableViewController.h"
#import "YEDetailTableViewController.h"
#import "ZKJTableViewController.h"
#import "CZViewController.h"
#import "TXViewController.h"

@interface WalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *yueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIView *jifenView;
@property (weak, nonatomic) IBOutlet UIView *youhuijuanView;
@property (weak, nonatomic) IBOutlet UIView *yueView;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTapOnView];
}
-(void)addTapOnView
{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    _yueView.tag = 100;
     [_yueView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    _jifenView.tag = 200;
    [_jifenView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    _youhuijuanView.tag = 300;
    [_youhuijuanView addGestureRecognizer:tap3];
    
}
-(void)tapView:(UITapGestureRecognizer *)sender
{
    DbgLog(@"tap :%ld",(long)sender.view.tag);
    if (sender.view.tag == 100) {
        YEDetailTableViewController *yeVC = [[YEDetailTableViewController alloc]init];
        [self.navigationController pushViewController:yeVC animated:YES];
    }else if (sender.view.tag ==200){
        JFdetailTableViewController *jfvc = [[JFdetailTableViewController alloc]init];
        [self.navigationController pushViewController:jfvc animated:YES];
    }else if (sender.view.tag == 300){
        ZKJTableViewController *zkVC = [[ZKJTableViewController alloc]init];
        [self.navigationController pushViewController:zkVC animated:YES];
    }else
    {
        [self showHint:@"无触发事件" yOffset:-100];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onCZBtnClick:(UIButton *)sender {
    CZViewController *czVC = [[CZViewController alloc]init];
    [self.navigationController pushViewController:czVC animated:YES];
}
- (IBAction)onTXBtnClick:(UIButton *)sender {
    TXViewController *txVC = [[TXViewController alloc]init];
    [self.navigationController pushViewController:txVC animated:YES];
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
