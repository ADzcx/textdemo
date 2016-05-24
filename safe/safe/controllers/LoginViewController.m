#import "LoginViewController.h"
#import "AFNetWorking.h"
#import "AllURL.h"
#import "ViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            DbgLog(@"response :%@",rspDic);
            if ([rspDic[@"code"] integerValue] == 201) {
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                NSDictionary *data = rspDic[@"data"];
                NSDictionary *dic11 = @{@"userName":_userNameTextFierld.text,@"passWord":_passwordTextField.text,@"token":data[@"utoken"],@"HXPWD":data[@"upwd"]};
                [userDef setValue:dic11 forKey:@"info"];
                [userDef synchronize];
                
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
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else
            {
                UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"抱歉！" message:rspDic[@"msg"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alv show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure :%@",error.localizedDescription);
        }];
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


@end

