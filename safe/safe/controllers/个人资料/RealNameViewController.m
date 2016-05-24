//
//  RealNameViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/1.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "RealNameViewController.h"
#import "CoreTFManagerVC.h"

@interface RealNameViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *bodyScrollView;
@property (strong,nonatomic)UIView *bodyView;
@property (weak, nonatomic) IBOutlet UITextField *realNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *sfzHaoLabel;


@end

@implementation RealNameViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *rn1 = [TFModel modelWithTextFiled:_realNameLabel inputView:nil name:@"请输入真实姓名" insetBottom:5];
        TFModel *sfz = [TFModel modelWithTextFiled:_sfzHaoLabel inputView:nil name:@"请输入身份证号" insetBottom:5];
        return @[rn1,sfz];
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [CoreTFManagerVC uninstallManagerForVC:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    _bodyView = [[[NSBundle mainBundle]loadNibNamed:@"RealNameView" owner:self options:nil]lastObject];
    _bodyScrollView.contentSize = CGSizeMake(0, _bodyView.bounds.size.height-64);
    [_bodyScrollView addSubview:_bodyView];
    // Do any additional setup after loading the view from its nib.
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"实名认证申请";
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
- (IBAction)subBtnClick:(UIButton *)sender {
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[userdef objectForKey:@"info"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (_sfzHaoLabel.text.length != 18) {
        [self showHint:@"请正确填写18位身份证号！" yOffset:-100];
        return;
    }
    if (_realNameLabel.text.length < 2||_realNameLabel.text.length > 10) {
        [self showHint:@"请正确填写真实姓名！" yOffset:-10];
        return;
    }

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/hire/hireable"];
    NSDictionary *param = @{@"token":userDic[@"token"],@"name":_realNameLabel.text,@"id":_sfzHaoLabel.text};

    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DbgLog(@"response :%@",rspDic);
        
        if ([rspDic[@"code"] integerValue] == 200) {
            [self showHint:@"已提交！" yOffset:-20];
            
            //同步到本地
            [userDic setValue:_realNameLabel.text forKey:@"uname"];
            [userDic setValue:_sfzHaoLabel.text forKey:@"uidcard"];
            [userdef setObject:userDic forKey:@"info"];
            [userdef synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self showHint:rspDic[@"msg"] yOffset:-10];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure :%@",error.localizedDescription);
        
    }];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
