//
//  NewFriendsTableViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/19.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "NewFriendsTableViewController.h"
#import "FriendTableViewCell.h"

@interface NewFriendsTableViewController ()
@property (nonatomic,copy)NSMutableArray *dataSource;


@end

@implementation NewFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新的朋友";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self prepareData];
}
-(void)prepareData
{
    _dataSource = [[NSMutableArray alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/req/list"];
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [userdef valueForKey:@"info"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:userdic[@"token"],@"token", nil];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        
        if ( [rspDic[@"code"] intValue] == 201) {
            NSArray *friends = rspDic[@"data"];
            for (NSDictionary *friend in friends) {
                DbgLog(@"add friends %@",friend);
                
                [_dataSource addObject:friend];
            }
            [self.tableView reloadData];
        }else
        {
            [self showHint:@"没有好友请求记录" yOffset:-100];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    NSLog(@"%lu",(unsigned long)_dataSource.count);
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indetfer = @"friendCellID";
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetfer];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendTableViewCell" owner:self options:nil]firstObject];
    }
    NSDictionary *people = _dataSource[indexPath.row];
    if ([people isKindOfClass:[NSDictionary class]]) {
        DbgLog(@"%@",people);
        
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        NSDictionary *userdic = [userdef valueForKey:@"info"];

        if ([people[@"ruid"] isEqualToString:userdic[@"userName"]]) {//是我发起的
            cell.nickNameLabel.text = [NSString stringWithFormat:@"%@:%@",people[@"rrelnickname"],people[@"rrelid"]];
            cell.phoneLabel.text = @"我向TA发起的好友请求";
            
            [cell.actionBtn setTitle:[self typeOfReq:[people[@"rstatus"] integerValue]] forState:UIControlStateNormal];
            cell.actionBtn.userInteractionEnabled = NO;
            cell.actionBtn.enabled = NO;
        }else{
            if (people[@"ruid"]) {
                cell.phoneLabel.text = [NSString stringWithFormat:@"%@" ,people[@"ruid"]];
                DbgLog(@"ruid%@",people[@"ruid"]);
            }else{
                cell.phoneLabel.text = @"no phone";
            }
            if (people[@"runickname"]) {
                cell.nickNameLabel.text = [NSString stringWithFormat:@"%@" ,people[@"runickname"]];
                DbgLog(@"runickname:%@",people[@"runickname"]);
            }else{
                cell.nickNameLabel.text = @"安顿用户";
            }
            if ([people[@"rstatus"] intValue] == 1) {
                [cell.actionBtn setTitle:@"已同意" forState:UIControlStateNormal];
                [cell.actionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                cell.actionBtn.userInteractionEnabled = NO;
            }else if ([people[@"rstatus"] intValue] == 2){
                [cell.actionBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                [cell.actionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                cell.actionBtn.userInteractionEnabled = NO;
            }else
            {
                
            }
        }
        
    }
    cell.actionBtn.tag = [people[@"ruid"] integerValue];
    [cell.actionBtn addTarget:self action:@selector(onActionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(NSString *)typeOfReq:(NSInteger )num
{
    switch (num) {
        case 0:
            return @"未处理";
        case 1:
            return @"已同意";
        case 2:
            return @"已拒绝";
        default:
            break;
    }
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DbgLog(@"%ld",(long)indexPath.row);
}
//http://xxx.xxx.xxx.xxx:port/zrwt/friend/add?token=xxx&userIdB=xxx
-(void)onActionBtnClick:(UIButton *)sender
{
    NSString *userIdB = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    DbgLog(@"%@",userIdB);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/add"];
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [userdef valueForKey:@"info"];

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:userdic[@"token"],@"token",userIdB,@"userIdB", nil];
    DbgLog(@"send param %@",param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        DbgLog(@"%@",dic);
        
        DbgLog(@"%@",dic[@"code"]);
        
        if ( [dic[@"code"] intValue] == 200) {
            DbgLog(@"ok :%@",dic[@"msg"]);
            [self.tableView reloadData];
        }else
        {
            UIAlertView *alv = [[UIAlertView alloc]initWithTitle:dic[@"msg"] message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alv show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
    }];
}

@end
