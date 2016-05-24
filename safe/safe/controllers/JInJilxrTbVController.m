//
//  JInJilxrTbVController.m
//  safe
//
//  Created by 薛永伟 on 15/10/10.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "JInJilxrTbVController.h"
#import "UrgentFriendViewController.h"

@interface JInJilxrTbVController ()<UrgentFriendViewControllerDelegate>

@property (nonatomic,copy)NSMutableArray *dataSource;
@property (nonatomic,copy)NSMutableArray *friendJJlxrArr;

@end

@implementation JInJilxrTbVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc]init];
    _friendJJlxrArr = [[NSMutableArray alloc]init];
    
    [self custNaviItm];
//    [self prepareData];
    [self prepareOurUser];
    
}
-(void)prepareOurUser
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/list"];
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [userdef valueForKey:@"info"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:userdic[@"token"],@"token", nil];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        [_friendJJlxrArr removeAllObjects];
        [_dataSource removeAllObjects];
        DbgLog(@"我们服务器返回的用户信息:%@",rspDic);
        if ([rspDic[@"code"] integerValue] == 201) {
            NSArray *friendsArray = rspDic[@"data"];
            for (NSDictionary *userInfoDic  in friendsArray) {
                if ([userInfoDic[@"rstatus"] isEqualToString:@"2"]||[userInfoDic[@"rstatus"] isEqualToString:@"8"]) {
                    //加入到紧急联系人数组里
                    [_friendJJlxrArr addObject:@{@"id":userInfoDic[@"rbid"],@"name":userInfoDic[@"rbnickname"]}];
                    [_dataSource addObject:@{@"id":userInfoDic[@"rbid"],@"name":userInfoDic[@"rbnickname"],@"friend":@"YES"}];
                }
                DbgLog(@"%@",userInfoDic);
            }
//            [self.tableView reloadData];
        }
        //先获取好友的紧急联系人，排在前面
        [self prepareData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
    }];
}

-(void)prepareData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    manager.requestSerializer.timeoutInterval = 6;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/sos/contact/get"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        if ([rspDic[@"code"] integerValue] == 201 ) {
          
            for (NSDictionary *jjlxrDic in rspDic[@"data"]) {
                [_dataSource addObject:@{@"id":jjlxrDic[@"sphone"],@"name":jjlxrDic[@"sname"]}];
            }
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        [self prepareOurUser];
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}

-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"紧急联系人";
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
}
-(void)onAddClick:(UIButton *)sender
{
    UrgentFriendViewController *urVC = [[UrgentFriendViewController alloc] init];
    
    urVC.delegate = self;
    urVC.currentType = 201;
    [self.navigationController pushViewController:urVC animated:YES];
}
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 🔌---好友选择列表的代理
- (void)urgentFriendViewController:(UrgentFriendViewController *)urgentFriendViewController changefriendId:(NSString *)friendId
{
    if (![self doesHave:friendId]) {
//        [self AddLXR:friendId];
//        [_dataSource addObject:friendId];
    }
    [self.tableView reloadData];
}
- (void)urgentFriendViewController:(UrgentFriendViewController *)urgentFriendViewController needChangeDic:(NSDictionary *)dic
{
    DbgLog(@"%@",dic);
    NSUserDefaults *uDf = [NSUserDefaults standardUserDefaults];
    NSDictionary *uDic = [uDf objectForKey:@"info"];
    if ([dic[@"id"] isEqualToString:uDic[@"uid"]]) {
        [self showHint:@"不能添加自己哦！" yOffset:-100];
        return;
    }
    if (![self doesHave:dic[@"id"]]) {
//        [_dataSource addObject:@{@"id":dic[@"rbid"],@"name":dic[@"name"],@"friend":@"YES"}];
        [_dataSource addObject:dic];
        if (dic[@"friend"]) {//如果是好友
            [_friendJJlxrArr addObject:@{@"id":dic[@"id"],@"name":dic[@"name"]}];
            //覆盖式更新
            [self setJJLxr];
        }else
        {
            //新增紧急联系人
            [self AddLXR:dic[@"id"] and:dic[@"name"]];
        }
        
    }
    [self.tableView reloadData];
}
-(void)ChooseByTXL:(NSMutableArray *)friendIdArray
{
    for (NSString *friendId in friendIdArray) {
        if (![self doesHave:friendId]) {
            [self AddLXR:friendId];
//            [_dataSource addObject:friendId];
        }
    }
    [self.tableView reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    NSDictionary *dic = _dataSource[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"name"],dic[@"id"]];
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         
         NSDictionary *usDic = _dataSource[indexPath.row];
         NSString *thisOne = usDic[@"id"];
         
         [_dataSource removeObjectAtIndex:indexPath.row];
         
         if (usDic[@"friend"]) {//如果来自好友
             //因为好友的在上面
             [_friendJJlxrArr removeObjectAtIndex:indexPath.row];
             //覆盖式更新
             [self setJJLxr];
         }else
         {
             [self deleteLXR:thisOne];
         }
         [self.tableView reloadData];
     }
 }
-(BOOL)doesHave:(NSString *)str
{
    for (NSDictionary *dic in _dataSource) {
        if ([dic[@"id"] isEqualToString:str]) {
            [self showHint:@"紧急联系人已存在" yOffset:-10];
            return YES;
        }
    }
    return NO;
}
//设置紧急联系人，覆盖式更新
-(void)setJJLxr
{
//xxx.xxx.xxx.xxx:port/zrwt/friend/set/status?token=xxx&list=[xxx,xxxx]
    NSMutableString *listStr = [NSMutableString stringWithString:@"["];
    DbgLog(@"收集到的数据是:%@",_friendJJlxrArr);
    for (int i = 0; i<_friendJJlxrArr.count; i++) {
        if (i==0) {
            NSDictionary *userDic = _friendJJlxrArr[i];
            NSString *userId = userDic[@"id"];
            [listStr appendFormat:@"%@",userId ];
        }else
        {
            NSDictionary *userDic = _friendJJlxrArr[i];
            NSString *userId = userDic[@"id"];
            [listStr appendFormat:@",%@",userId];
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
    [param setValue:@"1" forKey:@"type"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/set/status"];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    DbgLog(@"发送的数据= %@",param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"ssss%s",[responseObject bytes]);
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([rspDic[@"code"] integerValue] == 200) {
            DbgLog(@"200成功");
            
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
    }];

}
////xxx.xxx.xxx.xxx:port/zrwt/sos/contact/phones?token=xxx&listAdd=[xxx:name,xxxx:name]&listDel=[xxxx,xxx]
-(void)AddLXR:(NSString *)user
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/sos/contact/phones"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSString *listAdd = [NSString stringWithFormat:@"[%@:user]",user];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:listAdd forKey:@"listAdd"];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    DbgLog(@"发送的数据=  %@ ",param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
        [self.tableView reloadData];
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}

//添加非好友为紧急联系人
-(void)AddLXR:(NSString *)user and:(NSString *)Name
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/sos/contact/phones"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSString *listAdd = [NSString stringWithFormat:@"[%@:%@]",user,Name];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:listAdd forKey:@"listAdd"];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    DbgLog(@"发送的数据=  %@ ",param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
        [self.tableView reloadData];
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}

-(void)deleteLXR:(NSString *)user
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/sos/contact/phones"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSString *listDel = [NSString stringWithFormat:@"[%@]",user];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:listDel forKey:@"listDel"];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    DbgLog(@"发送的数据=  %@ ",param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];

}

@end
