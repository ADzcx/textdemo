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

#import "CreateGroupViewController.h"

#import "ContactSelectionViewController.h"
#import "EMTextView.h"

@interface CreateGroupViewController ()<UITextFieldDelegate, UITextViewDelegate, EMChooseViewDelegate>

@property (strong, nonatomic) UIView *switchView;
@property (strong, nonatomic) UIBarButtonItem *rightItem;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) EMTextView *textView;

@property (nonatomic) BOOL isPublic;
@property (strong, nonatomic) UILabel *groupTypeLabel;//群组类型

@property (nonatomic) BOOL isMemberOn;
@property (strong, nonatomic) UILabel *groupMemberTitleLabel;
@property (strong, nonatomic) UISwitch *groupMemberSwitch;
@property (strong, nonatomic) UILabel *groupMemberLabel;

@end

@implementation CreateGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isPublic = NO;
        _isMemberOn = NO;
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
    self.title = NSLocalizedString(@"title.createGroup", @"Create a group");
//    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    addButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [addButton setTitle:NSLocalizedString(@"group.create.addOccupant", @"add members") forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addContacts:) forControlEvents:UIControlEventTouchUpInside];
    _rightItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    [self.navigationItem setRightBarButtonItem:_rightItem];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backButton setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.switchView];
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
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 40)];
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 0.5;
        _textField.layer.cornerRadius = 3;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:12.0];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = NSLocalizedString(@"group.create.inputName", @"please enter the group name");
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }
    
    return _textField;
}

- (EMTextView *)textView
{
    if (_textView == nil) {
        _textView = [[EMTextView alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 80)];
        _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textView.layer.borderWidth = 0.5;
        _textView.layer.cornerRadius = 3;
        _textView.font = [UIFont systemFontOfSize:12.0];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeholder = NSLocalizedString(@"group.create.inputDescribe", @"please enter a group description");
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
    }
    
    return _textView;
}

- (UIView *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UIView alloc] initWithFrame:CGRectMake(10, 160, SCREEN_WIDTH-20, 90)];
        _switchView.backgroundColor = [UIColor clearColor];
        
        CGFloat oY = 0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, oY, 100, 35)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.numberOfLines = 2;
        label.text = NSLocalizedString(@"group.create.groupPermission", @"group permission");
        [_switchView addSubview:label];
        
        UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(100, oY, 50, _switchView.frame.size.height)];
        [switchControl addTarget:self action:@selector(groupTypeChange:) forControlEvents:UIControlEventValueChanged];
        [_switchView addSubview:switchControl];
        
        _groupTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(switchControl.frame.origin.x + switchControl.frame.size.width + 5, oY, 100, 35)];
        _groupTypeLabel.backgroundColor = [UIColor clearColor];
        _groupTypeLabel.font = [UIFont systemFontOfSize:12.0];
        _groupTypeLabel.textColor = [UIColor grayColor];
        _groupTypeLabel.text = NSLocalizedString(@"group.create.private", @"private group");
        _groupTypeLabel.numberOfLines = 2;
        [_switchView addSubview:_groupTypeLabel];
        
        oY += (35 + 20);
        _groupMemberTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, oY, 100, 35)];
        _groupMemberTitleLabel.font = [UIFont systemFontOfSize:12.0];
        _groupMemberTitleLabel.backgroundColor = [UIColor clearColor];
        _groupMemberTitleLabel.text = NSLocalizedString(@"group.create.occupantPermissions", @"members invite permissions");
        _groupMemberTitleLabel.numberOfLines = 2;
        [_switchView addSubview:_groupMemberTitleLabel];
        
        _groupMemberSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, oY, 50, 20)];
        [_groupMemberSwitch addTarget:self action:@selector(groupMemberChange:) forControlEvents:UIControlEventValueChanged];
        [_switchView addSubview:_groupMemberSwitch];
        
        _groupMemberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_groupMemberSwitch.frame.origin.x + _groupMemberSwitch.frame.size.width + 5, oY, 150, 35)];
        _groupMemberLabel.backgroundColor = [UIColor clearColor];
        _groupMemberLabel.font = [UIFont systemFontOfSize:12.0];
        _groupMemberLabel.textColor = [UIColor grayColor];
        _groupMemberLabel.numberOfLines = 2;
        _groupMemberLabel.text = NSLocalizedString(@"group.create.unallowedOccupantInvite", @"don't allow group members to invite others");
        [_switchView addSubview:_groupMemberLabel];
    }
    
    return _switchView;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - EMChooseViewDelegate

- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
#pragma mark 🔌---设置群组的最大人数
    NSInteger maxUsersCount = 20;
    if ([selectedSources count] > (maxUsersCount - 1)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"group.maxUserCount", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        
        return NO;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"group.create.ongoing", @"create a group...")];
    
    NSMutableArray *source = [NSMutableArray array];
    for (EMBuddy *buddy in selectedSources) {
        [source addObject:buddy.username];
    }
    
    EMGroupStyleSetting *setting = [[EMGroupStyleSetting alloc] init];
    setting.groupMaxUsersCount = maxUsersCount;
    
    if (_isPublic) {
        if(_isMemberOn)
        {
            setting.groupStyle = eGroupStyle_PublicOpenJoin;
        }
        else{
            setting.groupStyle = eGroupStyle_PublicJoinNeedApproval;
        }
    }
    else{
        if(_isMemberOn)
        {
            setting.groupStyle = eGroupStyle_PrivateMemberCanInvite;
        }
        else{
            setting.groupStyle = eGroupStyle_PrivateOnlyOwnerInvite;
        }
    }
    
    __weak CreateGroupViewController *weakSelf = self;
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *username = [loginInfo objectForKey:kSDKUsername];
    NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join groups \'%@\'"), username, self.textField.text];
    
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:self.textField.text description:self.textView.text invitees:source initialWelcomeMessage:messageStr styleSetting:setting completion:^(EMGroup *group, EMError *error) {
        [weakSelf hideHud];
        if (group && !error) {
            [weakSelf showHint:NSLocalizedString(@"group.create.success", @"create group success")];
            DbgLog(@"环信返回的group:%@",group);
//            token：用户token
//        emId:群组号,不是环信群组号,是系统群组好
//        groupName:群名称，可选
//        note:备注信息。可选
//        members:成员id列表（手机号)
//        access:访问权限，群是公开(TRUE)的还是私有（FALSE）的，TRUE或者FALSE ，可选
//        approval:申请加群是否需要同意。TRUE是，FALSE否，
            
//
#pragma mark 🔌环信添加群组成功后向自己的服务器发起创建群组的请求
            NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[userDef objectForKey:@"info"]];
            
            [param setValue:userDic[@"token"] forKey:@"token"];
            [param setValue:group.groupId forKey:@"emId"];
            DbgLog(@"返回的群组id%@",group.groupId);
            [param setValue:_textField.text forKey:@"groupName"];
            [param setValue:_textView.text forKey:@"note"];
            for (NSString *member in source) {
                [param setValue:member forKey:@"members"];
            }
             NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/group/byclient/create"];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
            [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
                DbgLog(@"修改成功 %@  date:%@",rspDic,rspDic[@"data"]);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"failure :%@",error.localizedDescription);
                [self showHint:@"群组信息同步失败，请联系客服同步！" yOffset:-10];
            }];
            //操作完成，返回
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            [weakSelf showHint:NSLocalizedString(@"group.create.fail", @"Failed to create a group, please operate again")];
        }
    } onQueue:nil];
    
    return YES;
}
#pragma mark - action

- (void)groupTypeChange:(UISwitch *)control
{
    _isPublic = control.isOn;
    
    [_groupMemberSwitch setOn:NO animated:NO];
    [self groupMemberChange:_groupMemberSwitch];
    
    if (control.isOn) {
        _groupTypeLabel.text = NSLocalizedString(@"group.create.public", @"public group");
    }
    else{
        _groupTypeLabel.text = NSLocalizedString(@"group.create.private", @"private group");
    }
}

- (void)groupMemberChange:(UISwitch *)control
{
    if (_isPublic) {
        _groupMemberTitleLabel.text = NSLocalizedString(@"group.create.occupantJoinPermissions", @"members join permissions");
        if(control.isOn)
        {
            _groupMemberLabel.text = NSLocalizedString(@"group.create.open", @"random join");
        }
        else{
            _groupMemberLabel.text = NSLocalizedString(@"group.create.needApply", @"you need administrator agreed to join the group");
        }
    }
    else{
        _groupMemberTitleLabel.text = NSLocalizedString(@"group.create.occupantPermissions", @"members invite permissions");
        if(control.isOn)
        {
            _groupMemberLabel.text = NSLocalizedString(@"group.create.allowedOccupantInvite", @"allows group members to invite others");
        }
        else{
            _groupMemberLabel.text = NSLocalizedString(@"group.create.unallowedOccupantInvite", @"don't allow group members to invite others");
        }
    }
    
    _isMemberOn = control.isOn;
}
#pragma mark ---添加联系人
- (void)addContacts:(id)sender
{
    if (self.textField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"group.create.inputName", @"please enter the group name") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        return;
    } 
    
    [self.view endEditing:YES];
    
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] init];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

@end
