//
//  FriendAndGroupViewController.m
//  safe
//
//  Created by andun on 15/10/1.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "FriendAndGroupViewController.h"
#import "AllUrl.h"
#import "AFNetworking.h"
#import "FriendList.h"

@interface FriendAndGroupViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@end

@implementation FriendAndGroupViewController
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
    self.navigationItem.title = @"选择要查看的人";
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
    NSDictionary *param = @{@"token":userDic[@"token"]};
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/list"];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"ssss%s",[responseObject bytes]);
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *friendArray = rspDic[@"data"];
        if ([rspDic[@"code"] integerValue] == 201) {
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _searBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
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
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    if(_tableView != tableView)
    {
        FriendList *friendModel = _searchResults[indexPath.row];
        
        cell.textLabel.text = friendModel.rbnickname;
    }else
    {
        FriendList *friendModel = _groupArray[indexPath.row];
        
        cell.textLabel.text = friendModel.rbnickname;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2, 45);
    [leftBtn setTitle:@"好友" forState:UIControlStateNormal];
//    leftBtn.layer.cornerRadius = 5;
    leftBtn.clipsToBounds = YES;
    leftBtn.layer.borderWidth = 1;
//    leftBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    
    [leftBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 45);
    [rightBtn setTitle:@"群组" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    rightBtn.layer.cornerRadius = 5;
    rightBtn.clipsToBounds = YES;
    rightBtn.layer.borderWidth = 1;
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
//    rightBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    
    //[view addSubview:leftBtn];
    //[view addSubview:rightBtn];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 45)];
    lable.text = @"我的全部好友";
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = [UIColor orangeColor];
    
    [view addSubview:lable];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
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
    if([self.delegate respondsToSelector:@selector(friendAndGroupViewController:changeFriendId:)])
    {
        NSString *friendId;
        if(_tableView != tableView)
        {
            FriendList *friendModel = _searchResults[indexPath.row];
            
            friendId = friendModel.rbid;
            
        }else
        {
            FriendList *friendModel = _groupArray[indexPath.row];
            
            friendId = friendModel.rbid;
        }
        
        [self.delegate friendAndGroupViewController:self changeFriendId:friendId];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
