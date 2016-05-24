/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "AddFriendViewController.h"

#import "ApplyViewController.h"
#import "UIViewController+HUD.h"
#import "AddFriendCell.h"
#import "InvitationManager.h"

@interface AddFriendViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation AddFriendViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.title = @"添加好友";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    self.tableView.tableFooterView = footerView;
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [searchButton setTitle:@"添加" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:searchButton]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backButton setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self.view addSubview:self.textField];
    
    [self getTongXunLun];
}

-(void)getTongXunLun
{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [usf objectForKey:@"TongXunLu"];
    for (NSDictionary *dic in arr) {
        NSLog(@"%@:%@",dic[@"userName"],dic[@"phoneNumber"]);
    }
    self.dataSource = arr;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 0.5;
        _textField.layer.cornerRadius = 3;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"输入您要添加好友的手机号";
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }
    
    return _textField;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
        _headerView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
        
        [_headerView addSubview:_textField];
    }
    
    return _headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddFriendCell";
    AddFriendCell *cell = (AddFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"icon_logo"];
    NSDictionary *dic = _dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"userName"],dic[@"phoneNumber"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//添加好友
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:userDic[@"token"],@"token", nil];
    NSDictionary *dic = _dataSource[indexPath.row];
    NSString *userID = userDic[@"uid"];
    NSString *userIdB = dic[@"phoneNumber"];
    if ([userID isEqualToString:userIdB]) {
        [self showHint:@"不能添加自己为好友！" yOffset:-100];
        return;
    }
    [param setValue:dic[@"phoneNumber"] forKey:@"userIdB"];
    DbgLog(@"sender :%@",param);
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/addreq"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    
        //            发起请求加好友
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        [MBProgressHUD showHUDAddedTo:window animated:YES];
        [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
            [MBProgressHUD hideHUDForView:window animated:YES];
            DbgLog(@"%@  date:%@",dic,dic[@"date"]);
            
            if ((int)dic[@"code"] == 200) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请求已发送" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
            }else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:dic[@"msg"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请求失败！" message:error.localizedDescription delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            DbgLog(@"failure :%@",error.localizedDescription);
        }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action

- (void)searchAction
{
    [_textField resignFirstResponder];
    if (_textField.text.length != 11) {
        [self showHint:@"请输入正确的手机号码！" yOffset:-10];
        return;
    }
    if(_textField.text.length > 0)
    {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSDictionary *userDic = [userDef objectForKey:@"info"];
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:userDic[@"token"],@"token", nil];
        [param setValue:_textField.text forKey:@"userIdB"];
        DbgLog(@"sender :%@",param);
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/addreq"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
        
        if (_textField.text.length == 11) {
//            发起请求加好友
            UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
            [MBProgressHUD showHUDAddedTo:window animated:YES];
            [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
                [MBProgressHUD hideHUDForView:window animated:YES];
                DbgLog(@"%@  date:%@",dic,dic[@"date"]);

                if ((int)dic[@"code"] == 200) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请求已发送" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alertView show];
                }else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:dic[@"msg"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:window animated:YES];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请求失败！" message:error.localizedDescription delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
                DbgLog(@"failure :%@",error.localizedDescription);
            }];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机号不正确" message:@"请输入11位手机号" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (BOOL)hasSendBuddyRequest:(NSString *)buddyName
{
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState == eEMBuddyFollowState_NotFollowed &&
            buddy.isPendingApproval) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)didBuddyExist:(NSString *)buddyName
{
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState != eEMBuddyFollowState_NotFollowed) {
            return YES;
        }
    }
    return NO;
}
//点添加的时候
- (void)showMessageAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"saySomething", @"say somthing")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                                          otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
        NSString *messageStr = @"";
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        if (messageTextField.text.length > 0) {
            messageStr = [NSString stringWithFormat:@"%@：%@", username, messageTextField.text];
        }
        else{
            messageStr = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyInvite", @"%@ invite you as a friend"), username];
        }
        [self sendFriendApplyAtIndexPath:self.selectedIndexPath
                                 message:messageStr];
    }
}

- (void)sendFriendApplyAtIndexPath:(NSIndexPath *)indexPath
                           message:(NSString *)message
{
    NSString *buddyName = [self.dataSource objectAtIndex:indexPath.row];
    if (buddyName && buddyName.length > 0)
    {
        [self showHudInView:self.view hint:NSLocalizedString(@"friend.sendApply", @"sending application...")];
        EMError *error;
        /*!
         @method
         @brief 申请添加某个用户为好友
         @discussion
         @param username 需要添加为好友的username
         @param message  申请添加好友时的附带信息
         @param pError   错误信息
         @result 好友申请是否发送成功
         */
        [[EaseMob sharedInstance].chatManager addBuddy:buddyName message:message error:&error];
        [self hideHud];
        
    }
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userDic[@"token"],@"token", nil];
    [dic setValue:buddyName forKey:@"userIdB"];
    [dic setValue:message forKey:@"note"];
    
    DbgLog(@"send %@",dic);
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/addreq"];
    DbgLog(@"url :%@",url);
    [[AFHTTPSessionManager manager] POST:url parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSUInteger statue = [responseObject[@"code"] integerValue];
        
        if (statue == 200) {
            DbgLog(@"发送成功112");
            [self showHint:NSLocalizedString(@"friend.sendApplyFail", @"send application fails, please operate again")];
        }else{
            DbgLog(@"发送失败");
            [self showHint:NSLocalizedString(@"friend.sendApplyFail", @"send application fails, please operate again")];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DbgLog(@"发送失败%@",error);
        [self showHint:NSLocalizedString(@"friend.sendApplyFail", @"send application fails, please operate again")];
    }];
    
    
}

@end
