//
//  FriendListViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/15.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "FriendListViewController.h"
#import "AllUrl.h"
#import "AFNetworking.h"
#import "FriendList.h"
#import "FriendListHeadView.h"
#import "NewFriendsTableViewController.h"
#import "GroupListViewController.h"
#import "ChatViewController.h"
#import "FriendListCell.h"

@interface FriendListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@end

@implementation FriendListViewController
{
    NSMutableArray *_groupArray;
    NSMutableArray *_searchResults;
    UITableView *_tableView;
    UISearchBar *_searBar;
    UISearchDisplayController *_searchDisp;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self custNaviItm];
    // Do any additional setup after loading the view.
    
    [self prepareData];
    [self customTableView];
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
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
- (void)prepareData
{
    _groupArray = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    NSDictionary *dic = @{@"token":userDic[@"token"]};
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/list"];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"ssss%s",[responseObject bytes]);

        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([rspDic[@"code"] integerValue] == 201) {
            NSArray *friendArray = rspDic[@"data"];
            for (NSDictionary *dic in friendArray) {
                
                FriendList *friendModel = [[FriendList alloc] init];
                
                [friendModel setValuesForKeysWithDictionary:dic];
                
                [_groupArray addObject:friendModel];
            }
            [_tableView reloadData];
            DbgLog(@"friend------->>>>>%@ %@",_groupArray,((FriendList *)_groupArray[0]).rbnickname);
        }
        [MBProgressHUD hideHUDForView:window animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure :%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:window animated:YES];
    }];
    _searchResults = [[NSMutableArray alloc] init];
}

- (void)customTableView
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    _searBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    _searBar.placeholder = @"请输入好友昵称";
    _searBar.delegate = self;
    _tableView.tableHeaderView = _searBar;
    _searchDisp = [[UISearchDisplayController alloc] initWithSearchBar:_searBar contentsController:self];
    _searchDisp.searchResultsDelegate = self;
    _searchDisp.searchResultsDataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [_searchResults removeAllObjects];
    if(_tableView != tableView)
    {
        for (FriendList *friendModel in _groupArray) {
            
            NSRange range = [friendModel.rbnickname rangeOfString:_searBar.text];
            if(range.location != NSNotFound)
            {
                [_searchResults addObject:friendModel];
            }
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_tableView != tableView)
    {
        return _searchResults.count;
    }
    
    return _groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"FriendListCellID";
    FriendListCell *cell = (FriendListCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendListCell" owner:self options:nil]lastObject];
    }
    if(_tableView != tableView)
    {
        FriendList *friendModel = _searchResults[indexPath.row];
        cell.textLabel.text = friendModel.rbnickname;
    }else
    {
        if (_groupArray.count >0) {
            FriendList *friendModel = _groupArray[indexPath.row];
            NSString *himgUrl = [NSString stringWithFormat:@"%@",friendModel.rburl];
            [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:himgUrl] placeholderImage:[UIImage imageNamed:@"icon_logo"]];
            cell.usNameLabel.text = friendModel.rbnickname;
        }else
        {
            [cell.headImgView setImage:[UIImage imageNamed:@"icon_logo"]];
            cell.usNameLabel.text = @"安顿用户";
        }
        
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FriendListHeadView *fhv = [[[NSBundle mainBundle]loadNibNamed:@"FriendListHeadView" owner:self options:nil]lastObject];
    fhv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 115);
    return fhv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 115;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    [self customSearchBar];
}

- (void)customSearchBar
{
    for (UIView *view in [_searBar.subviews[0] subviews]) {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)view;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendList *friendModel = _groupArray[indexPath.row];
    ChatViewController *ctvc = [[ChatViewController alloc]initWithChatter:friendModel.rbid isGroup:NO];
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [userdef valueForKey:@"info"];
    NSString *myHeadImage = userdic[@"uhimgurl"];
    
    ctvc.title = friendModel.rbnickname;
    ctvc.rbHeadImgUrl = friendModel.rburl;
    ctvc.myHeadImgUrl = myHeadImage;
    ctvc.rauth = friendModel.rauth;
    
    [self.navigationController pushViewController:ctvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onNewFriendClick:(UIButton *)sender {
    NewFriendsTableViewController *newfvc = [[NewFriendsTableViewController alloc]init];
    
    [self.navigationController pushViewController:newfvc animated:YES];
}
- (IBAction)onGroupClick:(UIButton *)sender {
    GroupListViewController *grpVc = [[GroupListViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:grpVc animated:YES];
}



@end
