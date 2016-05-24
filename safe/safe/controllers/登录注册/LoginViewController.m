#import "LoginViewController.h"
#import "AFNetWorking.h"
#import "AllURL.h"
#import "ViewController.h"
#import "MenuViewManger.h"
#import "Manager.h"
#import "CoreTFManagerVC.h"
#import "RegisterViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tm1 = [TFModel modelWithTextFiled:_userNameTextFierld inputView:nil name:@"请输入手机号" insetBottom:5];
        TFModel *tm2 = [TFModel modelWithTextFiled:_passwordTextField inputView:nil name:@"请输入手机号" insetBottom:5];

        return @[tm1,tm2];
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [CoreTFManagerVC uninstallManagerForVC:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    _userNameTextFierld.text = _userName;

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"用户登录";
    lable.font = [UIFont systemFontOfSize:18];
    //lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    self.onButton.layer.cornerRadius = 5;
    self.onButton.clipsToBounds = YES;
    
    _passwordTextField.delegate = self;
    
    [self customHaveLogined];
    
}
-(void)customHaveLogined
{
    NSUserDefaults *usDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *usDic = [usDef objectForKey:@"HaveLogined"];
    if (usDic) {
        _userNameTextFierld.text = usDic[@"uid"];
        _passwordTextField.text = usDic[@"upwd"];
    }
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"登录";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    bkbtn.enabled = NO;
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
}
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [_onButton setBackgroundColor:[UIColor orangeColor]];
    
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)onBtnClick:(UIButton *)sender {
    
    if(_userNameTextFierld.text.length == 0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请输入用户名"
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:@"好"
                                            otherButtonTitles:nil, nil];
        [alert show];
        
    }else if (_passwordTextField.text.length == 0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请输入密码"
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:@"好"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/loginUser"];
        NSDictionary *param = @{@"UID":_userNameTextFierld.text,@"UPWD":_passwordTextField.text};
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        
        [MBProgressHUD showHUDAddedTo:window animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 8.0;
        [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            DbgLog(@"response :%@",rspDic);
            if ([rspDic[@"code"] integerValue] == 201) {
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                NSDictionary *data = rspDic[@"data"];
                NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary: [self transToAllStringInDic:data]];
                //以下三个设置为了兼容设置本地存储之前设置的一些参数--薛永伟
                [userDic setValue:data[@"utoken"] forKey:@"token"];
                [userDic setValue:data[@"uid"] forKey:@"userName"];
                [userDic setValue:data[@"uid"] forKey:@"uid"];
                [userDic setValue:data[@"upwd"] forKey:@"HXPWD"];
                
                [userDef setValue:userDic forKey:@"info"];
                
                if ([userDef objectForKey:@"HaveLogined"]) {
                    [userDef removeObjectForKey:@"HaveLogined"];
                }
                
                NSDictionary *havaLogined = @{@"uid":_userNameTextFierld.text,@"upwd":_passwordTextField.text};
                [userDef setValue:havaLogined forKey:@"HaveLogined"];
                
                DbgLog(@"userdef :%@  userDic %@",userDef,userDic);
                [userDef synchronize];
                Manager *UserManager = [Manager manager];
                [UserManager.menuVC reloadMenuDataAndView];
                [UserManager.menuVC reloadMenuDataAndViewVC:0];
                [UserManager.mainView friendReal];
                
//                [UserManager.mainView customFriendAnnotationWithCoordinate:CLLocationCoordinate2DMake(0, 0)];
                
                BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
                if (!isAutoLogin) {
                    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:data[@"uid"]
                                                                        password:data[@"upwd"]
                                                                      completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                          if (!error) {
                                                                              [self showHint:@"登录成功" yOffset:-200];
                                                                          }
                                                                      } onQueue:nil];
                }
                
                //设置当前用户的手机号为alias(极光推送)
                [APService setTags:[NSSet setWithObjects:data[@"uid"],nil] alias:data[@"uid"] callbackSelector:nil object:nil];
                //获取一下有多少条惊喜数
                Manager *mng = [Manager manager];
                [mng.mainView CountOfJingXI];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else
            {
                UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"抱歉！" message:rspDic[@"msg"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alv show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            [self showHint:error.localizedDescription yOffset:-100];
            NSLog(@"failure :%@",error.localizedDescription);
        }];
    }
}

-(NSDictionary *)transToAllStringInDic:(NSDictionary *)dic
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc]init];
    [retDic setValue:[self getTureStringWith:dic[@"uage"] withType:1] forKey:@"uage"];
    [retDic setValue:[self getTureStringWith:dic[@"ubirth"] withType:1] forKey:@"ubirth"];
    [retDic setValue:[self getTureStringWith:dic[@"ucredit"] withType:1] forKey:@"ucredit"];
    [retDic setValue:[self getTureStringWith:dic[@"uemtoken"] withType:1] forKey:@"uemtoken"];
    [retDic setValue:[self getTureStringWith:dic[@"ufreezedate"] withType:1] forKey:@"ufreezedate"];
    [retDic setValue:[self getTureStringWith:dic[@"uhimgurl"] withType:1] forKey:@"uhimgurl"];
    [retDic setValue:[self getTureStringWith:dic[@"uidcard"] withType:1] forKey:@"uidcard"];
    [retDic setValue:[self getTureStringWith:dic[@"ulevel"] withType:1] forKey:@"ulevel"];
    [retDic setValue:[self getTureStringWith:dic[@"uname"] withType:1] forKey:@"uname"];
    [retDic setValue:[self getTureStringWith:dic[@"unickname"] withType:1] forKey:@"unickname"];
    [retDic setValue:[self getTureStringWith:dic[@"unote"] withType:1] forKey:@"unote"];
    [retDic setValue:[self getTureStringWith:dic[@"usignname"] withType:1] forKey:@"usignname"];
    [retDic setValue:[self getTureStringWith:dic[@"uonline"] withType:1] forKey:@"uonline"];
    [retDic setValue:[self getTureStringWith:dic[@"upwd"] withType:1] forKey:@"upwd"];
    [retDic setValue:[self getTureStringWith:dic[@"urefid"] withType:1] forKey:@"urefid"];
    [retDic setValue:[self getTureStringWith:dic[@"urefname"] withType:1] forKey:@"urefname"];
    [retDic setValue:[self getTureStringWith:dic[@"uregdate"] withType:1] forKey:@"uregdate"];
    [retDic setValue:[self getTureStringWith:dic[@"urest"] withType:1] forKey:@"urest"];
    [retDic setValue:[self getTureStringWith:dic[@"usex"] withType:1] forKey:@"usex"];
    [retDic setValue:[self getTureStringWith:dic[@"usignname"] withType:1] forKey:@"usignname"];
    [retDic setValue:[self getTureStringWith:dic[@"ustatus"] withType:1] forKey:@"ustatus"];
    [retDic setValue:[self getTureStringWith:dic[@"utoken"] withType:1] forKey:@"utoken"];
    
    DbgLog(@"retrun dic: %@",retDic);
    return retDic;

}
-(NSString *)getTureStringWith:(NSObject *)obj withType:(int) type
{
    DbgLog(@"get string %@",obj);
    if (obj) {
        if ([[NSString stringWithFormat:@"%@",obj] isEqualToString:@"<null>"]) {
            if (type == 1) {
                return @"未设置";
            }else if (type == 2){
                return @"未认证";
            }else
            {
                return @"未填写";
            }
        }else
        {
            return [NSString stringWithFormat:@"%@",obj];
        }
    }else
    {
        return @"未设置";
    }
}
//后台登录环信聊天服务器
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    DbgLog(@"username :%@  pwd:%@ ",username,password);
    
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [self hideHud];
         if (loginInfo && !error) {
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
             [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             //获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //发送自动登陆状态通知
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
         }
         else
         {
             switch (error.errorCode)
             {
                 case EMErrorNotFound:
                     TTAlertNoTitle(error.description);
                     break;
                 case EMErrorNetworkNotConnected:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                     break;
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                     break;
                 case EMErrorServerAuthenticationFailure:
                     TTAlertNoTitle(error.description);
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                     break;
                 default:
                     TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                     break;
             }
         }
     } onQueue:nil];
}
- (IBAction)onForgetPswClick:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     RegisterViewController *regVC = [story instantiateViewControllerWithIdentifier:@"Register"];
    regVC.isForGetPW = YES;
    [self.navigationController pushViewController:regVC animated:YES];
}

@end

