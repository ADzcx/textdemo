//
//  YEDetailTableViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/25.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "YEDetailTableViewController.h"
#import "YECell.h"
@interface YEDetailTableViewController ()

@property (nonatomic,copy)NSMutableArray *dataSource;

@end

@implementation YEDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    _dataSource = [[NSMutableArray alloc]init];
    
    self.navigationItem.title = @"余额明细";
    [self.navigationItem.leftBarButtonItem setTitle:@"钱包"];
    [self prepareYEDetail];

}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"我";
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

-(void)prepareYEDetail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/account/findAccountType"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:@"4" forKey:@"type"];
   
     DbgLog(@"发送的数据是:%@",param);
     
     UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
     
     [MBProgressHUD showHUDAddedTo:window animated:YES];
     
     [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        [MBProgressHUD hideHUDForView:window animated:YES];
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
         
         if ([[NSString stringWithFormat:@"%@",rspDic[@"code"]] isEqualToString:@"201"]) {
             NSArray *rspData = rspDic[@"data"];
             for (NSDictionary *rec in rspData) {
                 [_dataSource addObject:rec];
//                 cmoney cnote ctime cunickname
             }
             [self.tableView reloadData];
         }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YECell *cell = [tableView dequeueReusableCellWithIdentifier:@"yeCellID" ];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"YECell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = _dataSource[indexPath.row];
    
    cell.noteLabel.text = [NSString stringWithFormat:@"%@",dic[@"cnote"]];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@",dic[@"cmoney"]];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",dic[@"ctime"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
