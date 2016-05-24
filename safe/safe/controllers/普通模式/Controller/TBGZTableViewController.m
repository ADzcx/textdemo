//
//  TBGZTableViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/28.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "TBGZTableViewController.h"
#import "tongxunluCell.h"
#import "tongxunluModel.h"
#import "FriendList.h"


@interface TBGZTableViewController ()

@property (nonatomic,copy) NSMutableArray *dateSource;
@property (nonatomic,copy) NSMutableArray *thosPeople;
@property (nonatomic,strong) UIButton *btnSendSMS;
@property (nonatomic,assign) int TBGXNb;
@end

@implementation TBGZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    [self prepareData];
    
    _TBGXNb = 0;
    _dateSource = [[NSMutableArray alloc]init];
    _thosPeople = [[NSMutableArray alloc]init];
    
}
- (void)prepareData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    NSDictionary *param = @{@"token":userDic[@"token"]};
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/list"];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"ssss%s",[responseObject bytes]);
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([rspDic[@"code"] integerValue ] == 201) {
            NSArray *friendArray = rspDic[@"data"];
            for (NSDictionary *dic in friendArray) {
                
                FriendList *friendModel = [[FriendList alloc] init];
                [friendModel setValuesForKeysWithDictionary:dic];
                
                [_dateSource addObject:friendModel];
                //如果已经是特别关心的人了，就先加入到特别关心的人数组里
                if ([friendModel.rstatus isEqualToString:@"4"]||[friendModel.rstatus isEqualToString:@"8"]) {
                    _TBGXNb ++;
                    [_thosPeople addObject:friendModel.rbid];
                }
            }
            
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
    }];
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"选择特别关心的人";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
    
    _btnSendSMS = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSendSMS.frame = CGRectMake(0, 0, 30, 30);
    
    [_btnSendSMS setTitle:@"完成" forState:UIControlStateNormal];
    [_btnSendSMS addTarget:self action:@selector(onjjSendClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:_btnSendSMS];
    self.navigationItem.rightBarButtonItem = btn;
}
#pragma mark 🔌---点击了返回键
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 🔌---点击了发送键
-(void)onjjSendClick:(UIButton *)sender
{
    
//xxx.xxx.xxx.xxx:port/zrwt/friend/set/status?token=xxx&list=[xxx,xxxx]
//    if (_thosPeople.count == 0) {
//        return;
//    }
    NSMutableString *listStr = [NSMutableString stringWithString:@"["];
    DbgLog(@"收集到的数据是:%@",_thosPeople);
    for (int i = 0; i<_thosPeople.count; i++) {
        if (i==0) {
            FriendList *friend0 = _thosPeople[0];
            [listStr appendFormat:@"%@",friend0];
        }else
        {
            FriendList *friendi = _thosPeople[i];
            [listStr appendFormat:@",%@",friendi];
        }
    }
    [listStr appendString:@"]"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:listStr forKey:@"list"];
    [param setValue:@"0" forKey:@"type"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/set/status"];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    DbgLog(@"发送的数据= %@",param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"ssss%s",[responseObject bytes]);
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([rspDic[@"code"] integerValue] == 200) {
            
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
    }];
}

-(NSArray *)arrayOfPeople
{
    return _thosPeople;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dateSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tongxunluCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tongxunluCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tongxunluCell" owner:self options:nil]lastObject];
    }
    FriendList *model = _dateSource[indexPath.row];

    NSString *name = [NSString stringWithFormat:@"%@:%@",model.rbnickname,model.rbid];
    if ([model.rstatus isEqualToString:@"4"]||[model.rstatus isEqualToString:@"8"]) {
        cell.StatusBtn.selected = YES;
    }
    
    cell.contentLabel.text = name;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    FriendList *model = _dateSource[indexPath.row];
    
    tongxunluCell *cell = (tongxunluCell*)[tableView cellForRowAtIndexPath:indexPath];
     if ((_TBGXNb<3)||((_TBGXNb>=3)&&(cell.StatusBtn.selected == YES))) {
        if (cell.StatusBtn.selected == YES) {
            cell.StatusBtn.selected = NO;
            [_thosPeople removeObject:model.rbid];
            _TBGXNb --;
            DbgLog(@"_thosPeople = %@",_thosPeople);
            
        }else{
            cell.StatusBtn.selected = YES;
            [_thosPeople addObject:model.rbid];
            _TBGXNb ++;
            DbgLog(@"_thosPeople = %@",_thosPeople);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
