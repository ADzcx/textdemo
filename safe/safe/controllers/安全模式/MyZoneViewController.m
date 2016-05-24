//
//  MyZoneViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/10.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "MyZoneViewController.h"
#import "Manager.h"
#import "SafeFriendAddViewController.h"
#import "AFNetWorking.h"

@interface MyZoneViewController ()

@end

@implementation MyZoneViewController
{
    NSMutableDictionary *mutableDic;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _localSafeArray1 = [[NSMutableArray alloc] init];
    
    [self custNaviItm];
    [self prepareData];
    [self customTableView];
    
}

- (void)prepareData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSDictionary *dic = @{@"token":userDic[@"token"]};//参数
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/chassis/findUid"];
    NSLog(@"%@ \n %@",strUrl,dic);
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        [_localSafeArray1 removeAllObjects];
        
        if ([rspDic[@"code"] integerValue] == 201) {
            for (NSDictionary *placeDic in rspDic[@"data"]) {
                
                NSMutableDictionary *mutableDic1 = [[NSMutableDictionary alloc] init];
                
                [mutableDic1 setValue:placeDic[@"caltit"] forKey:@"latitude"];
                
                [mutableDic1 setValue:placeDic[@"clongit"] forKey:@"longitude"];
                
                [mutableDic1 setValue:placeDic[@"cplace"] forKey:@"subtitle"];
                [mutableDic1 setValue:placeDic[@"cname"] forKey:@"cname"];
                [mutableDic1 setValue:placeDic[@"cid"] forKey:@"cid"];
                [mutableDic1 setValue:placeDic[@"cfidlist"] forKey:@"cfidlist"];
                
                [_localSafeArray1 addObject:mutableDic1];
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        DbgLog(@"获取网络位置failure :%@",error.localizedDescription);
    }];
}

- (void)customTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)updateDictionNary:(NSDictionary *)dic
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSDictionary *param = @{@"token":userDic[@"token"],@"CUID":userDic[@"userName"],@"CNAME":dic[@"subtitle"],@"CPLACE":dic[@"subtitle"],@"CALTIT":dic[@"latitude"],@"CLONGIT":dic[@"longitude"]};//参数

    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/chassis/addChassis"];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"ssss%s",[responseObject bytes]);
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        if ([rspDic[@"code"] integerValue] == 201) {
            NSLog(@"%@",rspDic[@"data"]);
            [self prepareData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _localSafeArray1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    
//    cell.textLabel.text = [NSString stringWithFormat:@"名称：%@",_localSafeArray1[indexPath.row][@"cname"]];
    cell.textLabel.text = [NSString stringWithFormat:@"我的地盘"];
    
    cell.textLabel.textColor = [UIColor orangeColor];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"地址：%@",_localSafeArray1[indexPath.row][@"subtitle"]];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"我的地盘";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
    
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addbtn.frame = CGRectMake(0, 0, 25, 25);
    [addbtn setBackgroundImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [addbtn addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addbtn];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)onAddClick:(UIButton *)sender
{
#pragma mark ---🔌跳转到地图去选择位置，选择完后还得把位置（经纬度、名字）带回来
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请选择设置安全点的方式"
                                                  message:@"安顿为您提供地图选点和输入地址选点两种方式"
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"地图选点",@"地址输入",nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
        
        [self showHint:@"请拖动地图标记您的地盘!" yOffset:-100];
        if([self.delegate respondsToSelector:@selector(MyZoneViewController:)])
        {
            
            [self.delegate MyZoneViewController:self];
            
        }
        
    }else if (buttonIndex == 2)
    {
        PlistListViewController *plistVC = [[PlistListViewController alloc] init];
        
        plistVC.delegate = self;
        
        [self.navigationController pushViewController:plistVC animated:YES];
    }
}

- (void)plistListViewController:(PlistListViewController *)plistVC addNeedChangeName:(NSString *)name
{
    
    [mutableDic setValue:name forKey:@"subtitle"];
    
    [self updateDictionNary:mutableDic];
    
    Manager *manager = [Manager manager];
    [manager.mainView.safePlaceArrays addObject:mutableDic];
    
    [_tableView reloadData];
}

- (void)plistlistViewController:(PlistListViewController *)plistVC andNeedChangeLatitude:(CGFloat)latitude andNeedChangeLongitude:(CGFloat)longgitude
{
    
    mutableDic = [[NSMutableDictionary alloc] init];
    
    [mutableDic setValue:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    
    [mutableDic setValue:[NSString stringWithFormat:@"%f",longgitude] forKey:@"longitude"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = _localSafeArray1[indexPath.row];
    
    SafeFriendAddViewController *safeVC = [[SafeFriendAddViewController alloc] init];
    
    safeVC.addressDic = dic;
    
    [self.navigationController pushViewController:safeVC animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        [self deleteMyDomainWithIndexrow:_localSafeArray1[indexPath.row][@"cid"]];
        
        [_localSafeArray1 removeObjectAtIndex:indexPath.row];
        
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)deleteMyDomainWithIndexrow:(NSString *)row
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    //NSDictionary *cidAddress = _localSafeArray1[row];
    NSDictionary *dic = @{@"token":userDic[@"token"],@"cid":row};//参数
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/chassis/delChassis"];
    NSLog(@"%@ \n %@",strUrl,dic);
    
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DbgLog(@"%s",[responseObject bytes]);
        NSDictionary *sucessDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        DbgLog(@"%@",sucessDic[@"msg"]);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DbgLog(@"获取网络位置failure :%@",error.localizedDescription);
        
    }];
    
}

@end
