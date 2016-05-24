//
//  CZViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/25.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "CZViewController.h"

@interface CZViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ddjeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hxzfLabel;
@property (weak, nonatomic) IBOutlet UILabel *ddmcLabel;
@property (weak, nonatomic) IBOutlet UIButton *zfbBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIView *zfbTapView;
@property (weak, nonatomic) IBOutlet UIView *wxTapView;

@end

@implementation CZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"支付订单";
    [self addTapOnView];
}
-(void)addTapOnView
{
    UITapGestureRecognizer *tapZfb = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];
    _zfbTapView.tag = 100;
    [_zfbTapView addGestureRecognizer:tapZfb];
    
    UITapGestureRecognizer *tapWx = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];
    _wxTapView.tag = 200;
    [_wxTapView addGestureRecognizer:tapWx];
    
}
-(void)onTapView:(UITapGestureRecognizer *)sender
{
    NSInteger index = sender.view.tag;
    if (index == 100) {
        _zfbBtn.selected = YES;
        _wxBtn.selected = NO;
    }else if (index == 200){
        _zfbBtn.selected = NO;
        _wxBtn.selected = YES;
    }else
    {
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)onZFBClick:(UIButton *)sender {
//    if (sender.selected) {
//        sender.selected = NO;
//    }else{
//    sender.selected = YES;
//    }
//}
//- (IBAction)onWXClick:(UIButton *)sender {
//    if (sender.selected) {
//        sender.selected = NO;
//    }else{
//        sender.selected = YES;
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
