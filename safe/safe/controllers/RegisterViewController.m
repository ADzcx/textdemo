#import "RegisterViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "AFNetWorking.h"
#import "AllURL.h"
#import "ViewController.h"
#import "Manager.h"
#import "LoginViewController.h"

@interface RegisterViewController () <UITextFieldDelegate>
@end

@implementation RegisterViewController
{
    NSInteger _currentCount;
    AFHTTPRequestOperationManager *manager;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimerClick) userInfo:nil repeats:YES];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"新用户注册";
    lable.font = [UIFont systemFontOfSize:18];
    //lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    _textButton.layer.cornerRadius = 5;
    _textButton.clipsToBounds = YES;
    _userNameTextField.layer.cornerRadius = 5;
    _userNameTextField.clipsToBounds = YES;
    _userNameTextField.layer.borderWidth = 1;
    _userNameTextField.layer.borderColor = [UIColor orangeColor].CGColor;
    
    
    _testField.enabled = NO;
    _passWordTextField.enabled = NO;
    _makeSurePassWord.enabled = NO;
    _textButton.userInteractionEnabled = NO;

    _makeSurePassWord.delegate = self;
    _userNameTextField.delegate = self;
    
    manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
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
    if(_userNameTextField == textField)
    {
        if (_userNameTextField.text.length == 11) {
            NSDictionary *dic = @{@"uid":_userNameTextField.text};//参数
            NSLog(@"%@",dic);
            
            NSString *strUrl =  [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/isUserByName"];
            
            [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%s",[responseObject bytes]);
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic[@"date"]);
                DbgLog(@"msg %@",dic[@"msg"]);
                if ([dic[@"code"] integerValue] == 102 && [dic[@"msg"] isEqualToString:@"用户名已经存在"]) {//用户已存在
                    [self showHint:@"用户已存在，请直接登录" yOffset:-400];
                    
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

- (void)onTimerClick
{
    if(_currentCount > 0)
    {
        
        [_textButton setTitle:[NSString stringWithFormat:@"%ld",_currentCount] forState:UIControlStateNormal];
        _textButton.enabled = NO;
        _textButton.backgroundColor = [UIColor grayColor];
        _currentCount--;
    }else
    {
        [_textButton setTitle:@"验证" forState:UIControlStateNormal];
        _textButton.userInteractionEnabled = YES;
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
    
    [sender setTitle:[NSString stringWithFormat:@"%ld",_currentCount] forState:UIControlStateNormal];
    NSDictionary *dic = @{@"UID":_userNameTextField.text};//参数
    DbgLog(@"sendIdc %@",dic);
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/postISMSS"];
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
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
        DbgLog(@"failure :%@",error.localizedDescription);
    }];

}


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
        NSDictionary *dic = @{@"UID":_userNameTextField.text,@"UPWD":_passWordTextField.text,@"scont":_testField.text};//参数
        NSLog(@"%@",dic);
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/addUser"];
        [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
            DbgLog(@"rspDic %@",rspDic);
            if ([rspDic[@"code"] integerValue] == 201 ) {
//                DbgLog(@"%@",rspDic[@"data"]);
                LoginViewController *logVc = [[LoginViewController alloc]init];
                logVc.userNameTextFierld.text = _userNameTextField.text;
                logVc.passwordTextField.text = _passWordTextField.text;
                [self.navigationController pushViewController:logVc animated:YES];
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
            NSLog(@"failure :%@",error.localizedDescription);
        }];
    }
}

@end
