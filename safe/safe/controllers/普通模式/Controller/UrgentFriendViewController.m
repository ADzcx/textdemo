//
//  UrgentFriendViewController.m
//  safe
//
//  Created by andun on 15/9/30.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "UrgentFriendViewController.h"
#import "AFNetworking.h"
#import "AllUrl.h"
#import "FriendList.h"
#import "TXLTableViewController.h"

@interface UrgentFriendViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (nonatomic,copy)NSString *userByInput;
@property (nonatomic,strong)UITextField *tfield;
@property (nonatomic,strong)UITextField *nField;
@end

@implementation UrgentFriendViewController
{
    
    NSMutableArray *_urgentFriends;
    NSMutableArray *_searchResult;
    UITableView *_tableView;
    UISearchBar *_searBar;
    UISearchDisplayController *_searchDisp;
    NSString *_pushFriendId;
    
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
    self.navigationItem.title = @"添加联系人";
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
    _urgentFriends = [[NSMutableArray alloc] init];
    
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
        if ([rspDic[@"code"] integerValue] == 201) {
            NSArray *friendArray = rspDic[@"data"];
            for (NSDictionary *dic in friendArray) {
                
                FriendList *friendModel = [[FriendList alloc] init];
                
                [friendModel setValuesForKeysWithDictionary:dic];
                
                [_urgentFriends addObject:friendModel];
            }
            
            [_tableView reloadData];
            
            DbgLog(@"friend------->>>>>%@ %@",_urgentFriends,((FriendList *)_urgentFriends[0]).rbnickname);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
    }];
    
    _searchResult = [[NSMutableArray alloc] init];
}

- (void)customTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _searBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    _searBar.delegate = self;
    _tableView.tableHeaderView = _searBar;
    _searchDisp = [[UISearchDisplayController alloc] initWithSearchBar:_searBar contentsController:self];
    _searchDisp.searchResultsDataSource = self;
    _searchDisp.searchResultsDelegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [_searchResult removeAllObjects];
    if(_tableView != tableView)
    {
        for (FriendList *friendModel in _urgentFriends) {
            
            NSRange range = [friendModel.rbnickname rangeOfString:_searBar.text];
            if((range.location != NSNotFound))
            {
                [_searchResult addObject:friendModel];
            }
        }
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_tableView != tableView)
    {
        return _searchResult.count;
    }
    
    DbgLog(@"%d",_urgentFriends.count);
    
    return _urgentFriends.count;
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
        FriendList *friendModel = _searchResult[indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",friendModel.rbnickname,friendModel.rbid];
        
    }else
    {
        FriendList *friendModel = _urgentFriends[indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",friendModel.rbnickname,friendModel.rbid];

    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    imageView.image = [UIImage imageNamed:@"sousuotiao_03.png"];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    //[view addSubview:imageView];
#pragma mark 🔌---安全设置里的选择通知人时定制头视图如下
    if (_currentType == 201) {//安全设置选择通知联系人
        //手动输入电话号码
        _tfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, SCREEN_WIDTH/2-10, 40)];
        _tfield.font = [UIFont systemFontOfSize:13];
        _tfield.delegate = self;
        _tfield.placeholder = @"请输入联系人号码";
        _tfield.keyboardType = UIKeyboardTypeNumberPad;
        _tfield.borderStyle = UITextBorderStyleRoundedRect;
        //手动输入联系人姓名
        _nField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+10, 2, SCREEN_WIDTH/2-60, 40)];
        _nField.font = [UIFont systemFontOfSize:13];
        _nField.delegate = self;
        _nField.placeholder = @"联系人姓名";
        _nField.keyboardType = UIKeyboardTypeDefault;
        _nField.borderStyle = UITextBorderStyleRoundedRect;
//        //确定按钮
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        okBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 2, 50, 45);
        [okBtn setTitle:@"添加" forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(addFriendByTextField) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:_tfield];
        [view addSubview:_nField];
        [view addSubview:okBtn];
//        //右上角从通讯录选择
//        UIButton *TxlBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        TxlBtn.frame = CGRectMake(0, 0, 80, 45);
//        [TxlBtn setTitle:@"手机通讯录" forState:UIControlStateNormal];
//        [TxlBtn addTarget:self action:@selector(chooseFromTXL) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:TxlBtn];
        
    }else if (_currentType == 108)//首页选择特别关注联系人
    {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 45)];
        lable.font = [UIFont systemFontOfSize:13];
        lable.text = @"请点选您特别关心的人（多选）";
        [view addSubview:lable];
    }
    else
    {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 45)];
        lable.text = @"我的全部好友";
        lable.font = [UIFont systemFontOfSize:13];
        [view addSubview:lable];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
#pragma mark 🔌---textField的代理事件
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _userByInput = textField.text;
    
}
#pragma mark 🎬--－按钮点击事件
-(void)addFriendByTextField
{
    [_tfield resignFirstResponder];
    [_nField resignFirstResponder];
    DbgLog(@"%@",_userByInput);
    if (_tfield.text.length != 11) {
        [self showHint:@"请输入正确的手机号！" yOffset:-150];
        return;
    }
    if (_nField.text.length < 1) {
        [self showHint:@"请输入联系人姓名！" yOffset:-150];
        return;
    }
    NSDictionary *dic = @{@"name":_nField.text,@"id":_tfield.text};
    [self.delegate urgentFriendViewController:self needChangeDic:dic];

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---点击了从通讯录选择按钮 
-(void)chooseFromTXL
{
    TXLTableViewController *txlVC = [[TXLTableViewController alloc]init];
    txlVC.currentType = 201;
    [self.navigationController pushViewController:txlVC animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *friendId;
    if(_tableView != tableView)
    {
        FriendList *friendModel = _searchResult[indexPath.row];
        
        friendId = friendModel.rbid;
    }else
    {
        FriendList *friendModel = _urgentFriends[indexPath.row];
        
        friendId = friendModel.rbid;
    }
    _pushFriendId = friendId;
#pragma mark 🎈追随选择好友后
    if(self.currentType == 101)
    {
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"将会向好友发起追随请求"
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else if(self.currentType == 103)
    {

        if([self.delegate respondsToSelector:@selector(urgentFriendViewController:changefriendId:)])
        {
            
                DbgLog(@"friend---->>%@",friendId);
                
                [self.delegate urgentFriendViewController:self changefriendId:friendId];
                
                [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    else if(self.currentType == 108)//选择特别关心的人
    {
        
        if([self.delegate respondsToSelector:@selector(urgentFriendViewController:changefriendId:)])
        {
            
            DbgLog(@"friend---->>%@",friendId);
            
            [self.delegate urgentFriendViewController:self changefriendId:friendId];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }else if (self.currentType == 105)
    {
        
        if([self.delegate respondsToSelector:@selector(urgentFriendViewController:needChangeDic:)])
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            if(_tableView != tableView)
            {
                FriendList *friendModel = _searchResult[indexPath.row];
                [dic setValue:friendModel.rbnickname forKey:@"name"];
                [dic setValue:friendModel.rburl forKey:@"imageUrl"];
                [dic setValue:friendModel.rbid forKey:@"rbid"];
            }else
            {
                FriendList *friendModel = _urgentFriends[indexPath.row];
                [dic setValue:friendModel.rbnickname forKey:@"name"];
                [dic setValue:friendModel.rburl forKey:@"imageUrl"];
                [dic setValue:friendModel.rbid forKey:@"rbid"];
            }
            
            [self.delegate urgentFriendViewController:self needChangeDic:dic];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (self.currentType == 201)//选择紧急联系人
    {
        if([self.delegate respondsToSelector:@selector(urgentFriendViewController:needChangeDic:)])
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            if(_tableView != tableView)
            {
                FriendList *friendModel = _searchResult[indexPath.row];
                [dic setValue:friendModel.rbnickname forKey:@"name"];
                [dic setValue:friendModel.rburl forKey:@"imageUrl"];
                [dic setValue:friendModel.rbid forKey:@"rbid"];
            }else
            {
                FriendList *friendModel = _urgentFriends[indexPath.row];
                [dic setValue:friendModel.rbnickname forKey:@"name"];
                [dic setValue:friendModel.rburl forKey:@"imageUrl"];
                [dic setValue:friendModel.rbid forKey:@"id"];
                [dic setValue:@"YES" forKey:@"friend"];
            }
            
            [self.delegate urgentFriendViewController:self needChangeDic:dic];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        
        [MBProgressHUD showHUDAddedTo:window animated:YES];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/follow/FollowUser"];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSDictionary *userDic = [userDef objectForKey:@"info"];
        
        NSDictionary *dic = @{@"UID":_pushFriendId,@"token":userDic[@"token"]};
        
        [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            NSLog(@"%s",[responseObject bytes]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            NSLog(@"failure :%@",error.localizedDescription);
        }];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
