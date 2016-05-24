#import "RegisterViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "AFNetWorking.h"
#import "AllURL.h"
#import "ViewController.h"
#import "Manager.h"
#import "LoginViewController.h"
#import "CoreTFManagerVC.h"

@interface RegisterViewController () <UITextFieldDelegate>
@end

@implementation RegisterViewController
{
    NSInteger _currentCount;
    AFHTTPRequestOperationManager *manager;
    NSTimer *timer;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tm1 = [TFModel modelWithTextFiled:_userNameTextField inputView:nil name:@"请输入手机号" insetBottom:5];
        TFModel *tm2 = [TFModel modelWithTextFiled:_testField inputView:nil name:@"请输入手机号" insetBottom:5];
        TFModel *tm3 = [TFModel modelWithTextFiled:_passWordTextField inputView:nil name:@"请输入手机号" insetBottom:5];
        TFModel *tm4 = [TFModel modelWithTextFiled:_makeSurePassWord inputView:nil name:@"请输入手机号" insetBottom:5];
        return @[tm1,tm2,tm3,tm4];
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [CoreTFManagerVC uninstallManagerForVC:self];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimerClick) userInfo:nil repeats:YES];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    if (_isForGetPW == YES) {
        lable.text = @"忘记密码";
    }else
    {
        lable.text = @"新用户注册";
    }
    
    lable.font = [UIFont systemFontOfSize:18];
    //lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    _textButton.layer.cornerRadius = 5;
    _textButton.clipsToBounds = YES;
    _userNameTextField.layer.cornerRadius = 5;
    _userNameTextField.clipsToBounds = YES;
    _userNameTextField.layer.borderWidth = 1;
    _userNameTextField.layer.borderColor = [UIColor orangeColor].CGColor;
    
//    
//    _testField.enabled = NO;
//    _passWordTextField.enabled = NO;
//    _makeSurePassWord.enabled = NO;
    //_textButton.userInteractionEnabled = NO;

    _makeSurePassWord.delegate = self;
    _userNameTextField.delegate = self;
    
    manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(_makeSurePassWord == textField)
    {
        [_onBtnStart setBackgroundColor:[UIColor orangeColor]];
        
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_isForGetPW == YES) {
        
    }else
    {
        if(_userNameTextField == textField)
        {
            if (_userNameTextField.text.length == 11) {
                NSDictionary *dic = @{@"uid":_userNameTextField.text};//参数
                NSLog(@"%@",dic);
                
                NSString *strUrl =  [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/isUserByName"];
                UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
                
                [MBProgressHUD showHUDAddedTo:window animated:YES];
                
                
                [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%s",[responseObject bytes]);
                    [MBProgressHUD hideHUDForView:window animated:YES];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic[@"date"]);
                    DbgLog(@"msg %@",dic[@"msg"]);
                    if ([dic[@"code"] integerValue] == 102 && [dic[@"msg"] isEqualToString:@"用户名已经存在"]) {//用户已存在
                        [self showHint:@"用户已存在，请直接登录" yOffset:-200];
                        
                        double delayInSeconds = 0.3;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(dispatch_time(popTime, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            LoginViewController *lvc = [sb instantiateViewControllerWithIdentifier:@"Login"];
                            lvc.userName = _userNameTextField.text;
                            [self.navigationController pushViewController:lvc animated:YES];
                        });
                    }else if([dic[@"code"] integerValue] == 200)
                    {
                        _testField.enabled = YES;
                        _passWordTextField.enabled = YES;
                        _makeSurePassWord.enabled = YES;
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [MBProgressHUD hideHUDForView:window animated:YES];
                    NSLog(@"failure :%@",error.localizedDescription);
                }];
            }else
            {
                [self showHint:@"请正确填写手机号" yOffset:-400];
                _testField.enabled = NO;
                _passWordTextField.enabled = NO;
                _makeSurePassWord.enabled = NO;
                [_userNameTextField becomeFirstResponder];
            }
        }
        
    }
    
}

- (void)onTimerClick
{
    if(_currentCount > 0)
    {
        
        [_textButton setTitle:[NSString stringWithFormat:@"%ld",(long)_currentCount] forState:UIControlStateNormal];
        _textButton.userInteractionEnabled = NO;
        _textButton.backgroundColor = [UIColor grayColor];
        _currentCount--;
    }else
    {
        [_textButton setTitle:@"验证" forState:UIControlStateNormal];
        _textButton.userInteractionEnabled = YES;
        _textButton.backgroundColor = [UIColor orangeColor];
        
        //[timer invalidate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)onBtnTestClick:(UIButton *)sender {
    _textButton.userInteractionEnabled = NO;
    
    _currentCount = 60;
    
    [sender setTitle:[NSString stringWithFormat:@"%ld",(long)_currentCount] forState:UIControlStateNormal];
    
    NSDictionary *dic = @{@"UID":_userNameTextField.text};//参数
    DbgLog(@"sendIdc %@",dic);
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/postISMSS"];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        [MBProgressHUD hideHUDForView:window animated:YES];
        DbgLog(@"rspDic %@",rspDic);
        if ([rspDic[@"code"] integerValue] == 200 ) {
            [self showHint:@"验证码已发送"];
        }else
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"发送失败"
                                                          message:[NSString stringWithFormat:@"状态码:%@ ,错误描述:%@",rspDic[@"code"],rspDic[@"msg"]]
                                                         delegate:self
                                                cancelButtonTitle:@"好的"
                                                otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        DbgLog(@"failure :%@",error.localizedDescription);
    }];

}

#pragma mark --🎈点击“开始”发送请求


- (IBAction)onBtnStartClcik:(UIButton *)sender {
    
    if(_passWordTextField.text.length == 0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请输入密码"
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:@"好"
                                            otherButtonTitles:nil, nil];
        [alert show];

    }else if (_makeSurePassWord.text.length == 0)
    {
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请确认密码"
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:@"好"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        NSDictionary *dic = [[NSDictionary alloc]init];
        NSString *strUrl;
        if (_isForGetPW == YES) {
            dic = @{@"uid":_userNameTextField.text,@"newpwd":_passWordTextField.text,@"scont":_testField.text};//参数
            NSLog(@"%@",dic);
            strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/upUserPWD"];
        }else
        {
            dic = @{@"UID":_userNameTextField.text,@"UPWD":_passWordTextField.text,@"scont":_testField.text};//参数
            NSLog(@"%@",dic);
            strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/addUser"];
        }
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        
        [MBProgressHUD showHUDAddedTo:window animated:YES];
        [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
            DbgLog(@"rspDic %@",rspDic);
            [MBProgressHUD hideHUDForView:window animated:YES];
            if (( (_isForGetPW == NO)&&([rspDic[@"code"] integerValue] == 201) )||((_isForGetPW == YES)&&([rspDic[@"code"] integerValue] == 200) )) {
//                DbgLog(@"%@",rspDic[@"data"]);
//                LoginViewController *logVc = [[LoginViewController alloc]init];
//                logVc.userNameTextFierld.text = _userNameTextField.text;
//                logVc.passwordTextField.text = _passWordTextField.text;
//                [self.navigationController pushViewController:logVc animated:YES];
                NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/loginUser"];
                NSDictionary *param = @{@"UID":_userNameTextField.text,@"UPWD":_passWordTextField.text};
            
                AFHTTPRequestOperationManager *manager11 = [AFHTTPRequestOperationManager manager];
                manager11.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager11.requestSerializer.timeoutInterval = 8;
                
                UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
                [MBProgressHUD showHUDAddedTo:window animated:YES];
                
                [manager11 POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                        DbgLog(@"userdef :%@  userDic %@",userDef,userDic);
                        [userDef synchronize];
                        Manager *UserManager = [Manager manager];
                        [UserManager.menuVC reloadMenuDataAndView];
                        [UserManager.menuVC reloadMenuDataAndViewVC:0];
                        
                        [UserManager.mainView customFriendAnnotationWithCoordinate:CLLocationCoordinate2DMake(0, 0)];
                        
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
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [MBProgressHUD hideHUDForView:window animated:YES];
                    NSLog(@"failure :%@",error.localizedDescription);
                }];
            }else
            {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败"
                                                              message:[NSString stringWithFormat:@"状态码:%@ ,错误描述:%@",rspDic[@"code"],rspDic[@"msg"]]
                                                             delegate:self
                                                    cancelButtonTitle:@"好的"
                                                    otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:window animated:YES];
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
    //
    //
    //    NSString *uage =  [self getTureStringWith:dic[@"uage"] withType:1];
    //    NSString* ubirth = dic[@"ubirth"];
    //    NSString* ucredit = dic[@"ucredit"];
    //    NSString* uemtoken = dic[@"uemtoken"];
    //    NSString* unote = dic[@"unote"];
    //    NSString* ufreezedate = dic[@"ufreezedate"];
    //    NSString* uid = dic[@"uid"];
    //    NSString* uidcard = dic[@"uidcard"];
    //    NSString* ulevel = dic[@"ulevel"];
    //    NSString* uname = dic[@"uname"];
    //    NSString* unickname = dic[@""];
    //    NSString* uonline = dic[@""];
    //    NSString* upwd = dic[@""];
    //    NSString* urefid = dic[@""];
    //    NSString* urefname = dic[@""];
    //    NSString* uregdate = dic[@""];
    //    NSString* urest = dic[@""];
    //    NSString* usex = dic[@""];
    //    NSString* usignname = dic[@""];
    //    NSString* ustatus = dic[@""];
    //    NSString* utoken = dic[@""];
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


@end
