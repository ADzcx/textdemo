//
//  GYZMViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/26.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "GYZMViewController.h"
@interface GYZMViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIView *cityCoverView;
@property (weak, nonatomic) IBOutlet UITextField *trueNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *SFZTextField;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (nonatomic,strong) HZAreaPickerView *locatePicker;
@property (weak, nonatomic) IBOutlet UIButton *subMitBtn;
@property (nonatomic,copy) NSUserDefaults *userDef;
@property (weak, nonatomic) IBOutlet UIButton *xieyiBtn;
@property (nonatomic,copy)NSString *sexString;
@end

@implementation GYZMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    _userDef = [NSUserDefaults standardUserDefaults];
    _sexString = @"0";
    
    // Do any additional setup after loading the view from its nib.
    [self prepareUI];
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"xiabiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"雇员报名";
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

-(void)prepareUI
{
    _boyBtn.tag = 100;
    [_boyBtn addTarget:self action:@selector(touchSexBtn:) forControlEvents:UIControlEventTouchUpInside];
    _girlBtn.tag = 200;
    [_girlBtn addTarget:self action:@selector(touchSexBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapCity = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getPickerView)];
    [_cityCoverView addGestureRecognizer:tapCity];
    
    NSMutableDictionary *userDic = [_userDef objectForKey:@"info"];
//    if ([userDic[@"uname"] isEqualToString:@"未设置"]) {
//        
//    }else
//    {
        _trueNameTextField.text = userDic[@"uname"];
//        _trueNameTextField.userInteractionEnabled = NO;
//        _trueNameTextField.enabled = NO;
////    }
//    if ([userDic[@"uidcard"] isEqualToString:@"未设置"]) {
//        
//    }else
//    {
        _SFZTextField.text = userDic[@"uidcard"];
//        _SFZTextField.userInteractionEnabled = NO;
//        _SFZTextField.enabled = NO;
//    }
    if ([userDic[@"uapply"] isEqualToString:@"1"]) {
        [_xieyiBtn setTitle:@"解除后将不会收到任何的雇用信息。" forState:UIControlStateNormal];
       
        [_xieyiBtn setBackgroundColor:[UIColor clearColor]];
 
//        if ([userDic[@"usex"] isEqualToString:@"1"]) {
//            _girlBtn.hidden = YES;
//        }else
//        {
//            _boyBtn.hidden = YES;
//        }
//        
//        _boyBtn.enabled = NO;
//        _girlBtn.enabled = NO;
        
        [_subMitBtn setTitle:@"解除可被雇佣状态" forState:UIControlStateNormal];
    
    }
}
-(void)touchSexBtn:(UIButton *)sender
{
    if (sender.tag == 100) {
        _girlBtn.selected = NO;
        _boyBtn.selected = YES;
        _sexString = @"0";
    }else if(sender.tag == 200)
    {
        _girlBtn.selected = YES;
        _boyBtn.selected = NO;
        _sexString = @"1";
    }else{
        
    }
}
-(void)getPickerView
{
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict withDelegate:self andDatasource:self];
    
    //UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [self.locatePicker showInView:self.view];
}
//提交申请
- (IBAction)onSubmitCiick:(UIButton *)sender {
    if (_SFZTextField.text.length != 18) {
        [self showHint:@"请正确填写身份证号" yOffset:-10];
        return;
    }
    if (_trueNameTextField.text.length < 2) {
        [self showHint:@"请正确填写真实姓名" yOffset:-10];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *userDic = [_userDef objectForKey:@"info"];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_trueNameTextField.text forKey:@"name"];
    [param setValue:_sexString forKey:@"sex"];
    [param setValue:@"2" forKey:@"hireable"];
 
    [param setValue:_SFZTextField.text forKey:@"id"];
    if ([userDic[@"uapply"] isEqualToString:@"1"]) {//已经是可雇佣
        [param setValue:@"0" forKey:@"apply"];//设置为不可雇佣
    }else{
       [param setValue:@"1" forKey:@"apply"];
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/hire/hireable"];
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DbgLog(@"response :%@",rspDic);
        
        if ([rspDic[@"code"] integerValue] == 200) {
            [self showHint:@"操作成功！" yOffset:-100];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_userDef objectForKey:@"info"]];
            if ([dic[@"uapply"] isEqualToString:@"1"]) {//如果本来就是可雇用的
                [dic setValue:@"0" forKey:@"uapply"];//更新资料为不可雇用
            }else
            {
                [dic setValue:@"1" forKey:@"uapply"];
            }
            
            [dic setValue:_sexString forKey:@"usex"];
            [dic setValue:_trueNameTextField.text forKey:@"uname"];
            [dic setValue:_SFZTextField.text forKey:@"uidcard"];
            [_userDef setObject:dic forKey:@"info"];
            [_userDef synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self showHint:rspDic[@"msg"] yOffset:-100];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure :%@",error.localizedDescription);
        
    }];
}
-(void)dealloc
{
    _userDef = nil;
}
- (NSArray *)areaPickerData:(HZAreaPickerView *)picker
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSArray *data = [[NSArray alloc] initWithContentsOfFile:path];
    return data;
}
- (IBAction)onXieYiClick:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
         _subMitBtn.enabled = YES;
        _subMitBtn.backgroundColor = [UIColor redColor];
    }else
    {
        sender.selected = NO;
         _subMitBtn.enabled = NO;
        _subMitBtn.backgroundColor = [UIColor lightGrayColor];
    }
   
}

- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    _cityLabel.text = [NSString stringWithFormat:@"%@ %@ %@",picker.locate.state,picker.locate.city,picker.locate.district];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
