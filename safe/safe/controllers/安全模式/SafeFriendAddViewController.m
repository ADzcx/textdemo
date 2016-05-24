//
//  SafeFriendAddViewController.m
//  safe
//
//  Created by andun on 15/10/14.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "SafeFriendAddViewController.h"
#import "UrgentFriendViewController.h"
#import "UIImageView+EMWebCache.h"
#import "FriendListCell.h"

@interface SafeFriendAddViewController () <UrgentFriendViewControllerDelegate>

@end

@implementation SafeFriendAddViewController
{
    NSMutableArray *_dataSource;
    NSMutableDictionary *_ourUserDetailDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];
    _ourUserDetailDic = [[NSMutableDictionary alloc]init];
    _friendTableView.dataSource = self;
    _friendTableView.delegate = self;

    [self customNavigation];
//    [self prepareDpFriendData];
//    [self prepareOurUser];
    
    [self prepareThisPlace];
    
}

- (void)customNavigation
{
    _addressLable.text = [NSString stringWithFormat:@"地址:%@",_addressDic[@"subtitle"]];
    
     UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    self.navigationItem.title = @"新的好友";
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 80, 30);
    [right setTitle:@"添加提醒" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:13];
    [right setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [right setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtnClick:(UIButton *)sender
{
    DbgLog(@"添加提醒成功－－－－－－－》》》》》》》");
    UrgentFriendViewController *urVC = [[UrgentFriendViewController alloc] init];
    
    urVC.currentType = 105;
    
    urVC.delegate = self;
    
    [self.navigationController pushViewController:urVC animated:YES];
    
}

- (void)urgentFriendViewController:(UrgentFriendViewController *)urgentFriendViewController changefriendId:(NSString *)friendId
{
    
    DbgLog(@"得到的friendId= %@",friendId);
    
}

- (void)urgentFriendViewController:(UrgentFriendViewController *)urgentFriendViewController needChangeDic:(NSDictionary *)dic
{
    
    DbgLog(@"返回的Cell －－－－－－－》》》》》》》%@",dic);
    
    NSDictionary *newDic = @{@"headImage":dic[@"imageUrl"],@"name":dic[@"name"],@"id":dic[@"rbid"]};
    [_dataSource addObject:newDic];
    [self updateFriendId:dic];
    
    [_friendTableView reloadData];
    
}

- (void)prepareDpFriendData
{
    NSString *cfidlist = _addressDic[@"cfidlist"];
    NSArray *frinedArray = [cfidlist componentsSeparatedByString:@","];
    for (NSString *phone in frinedArray) {
        if (phone.length == 11) {
            [_dataSource addObject:phone];
        }
    }
}

-(void)prepareThisPlace
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/chassis/findFriends"];
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [userdef valueForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userdic[@"token"] forKey:@"token"];
    [param setValue:_addressDic[@"cid"] forKey:@"cid"];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        DbgLog(@"我们服务器返回的用户信息:%@",rspDic);
        if ([rspDic[@"code"] integerValue] == 201) {
            NSString *str = [NSString stringWithFormat:@"%@",rspDic[@"data"]];
            if (str.length == 6) {
                return ;
            }
            NSArray *friendsArray = rspDic[@"data"];
            for (NSDictionary *userInfoDic  in friendsArray) {
                DbgLog(@"user ----->>>> %@",userInfoDic);
                
                NSDictionary *friendDic = @{@"id":userInfoDic[@"rbid"],@"name":userInfoDic[@"rbnickname"],@"headImage":userInfoDic[@"rburl"]};
                
                [_dataSource addObject:friendDic];
            }
            DbgLog(@"现在保存的我的好友信息 -> %@",_ourUserDetailDic);
            [_friendTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
    }];
}
//-(void)prepareOurUser
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 20.0;
//    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/list"];
//    
//    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userdic = [userdef valueForKey:@"info"];
//    
//    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:userdic[@"token"],@"token", nil];
//    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
//        DbgLog(@"我们服务器返回的用户信息:%@",rspDic);
//        NSArray *friendsArray = rspDic[@"data"];
//        for (NSDictionary *userInfoDic  in friendsArray) {
//            DbgLog(@"user ----->>>> %@",userInfoDic);
//            
//            NSArray *friend = @[userInfoDic[@"rbnickname"],userInfoDic[@"rburl"]];
//            
//            [_ourUserDetailDic setValue:friend forKey:userInfoDic[@"rbid"]];
//            
//        }
//        DbgLog(@"现在保存的我的好友信息 -> %@",_ourUserDetailDic);
//        [_friendTableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"failure :%@",error.localizedDescription);
//    }];
//}
//-(NSString *)want:(int)type who:(NSString *)UserId
//{
//    NSArray *User = [_ourUserDetailDic objectForKey:UserId];
//    DbgLog(@"取出的user是= %@",User);
//    if (type == 1) {//取昵称
//        return User[0];
//    }else//取头像
//    {
//        NSString *str = [NSString stringWithFormat:@" %@",User[1]];
//        if (str.length < 8) {
//            return @"icon_logo";
//        }
//        return User[1];
//    }
//}

- (void)updateFriendId:(NSDictionary *)updateDic
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSDictionary *dic = @{@"token":userDic[@"token"],@"cid":_addressDic[@"cid"],@"fid":updateDic[@"rbid"]};//参数
   
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/chassis/saveFidlist"];
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"ssss%s",[responseObject bytes]);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        
        NSLog(@"%@",dic[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure ------>>>>>> :%@",error.localizedDescription);
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCellID"];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendListCell" owner:self options:nil]lastObject];
        
    }
    
    NSDictionary *user = _dataSource[indexPath.row];
    DbgLog(@"%@",_dataSource[indexPath.row]);
    
    NSString *userHeadImg = user[@"headImage"];
    NSString *userNicName = user[@"name"];
    
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:userHeadImg] placeholderImage:[UIImage imageNamed:@"ICON80-01"]];
    
    cell.usNameLabel.text = userNicName;
    
    CGRect rect = cell.contentView.frame;
    
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    
    rect.size.height = 60;
    
    cell.contentView.frame = rect;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSDictionary *user = _dataSource[indexPath.row];
        [self DeleFriend:user[@"id"]];
        
        [_dataSource removeObjectAtIndex:indexPath.row];
        
        [_friendTableView reloadData];
        
//        [_friendTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)DeleFriend:(NSString *)friendId
{
//    删除 我的地盘好友
//    接口地址： /chassis/delFidlist
//    @param token
//    @param fid; 好友id
//    @param cid	地盘id
//    @throws Exception
//    返回值： ode：201;
//    msg：删除成功
//				data： 用户信息
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];

    NSDictionary *param = @{@"token":userDic[@"token"],@"cid":_addressDic[@"cid"],@"fid":friendId};//参数
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/chassis/delFidlist"];
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        DbgLog(@"%@",rspDic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DbgLog(@"获取网络位置failure :%@",error.localizedDescription);
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
