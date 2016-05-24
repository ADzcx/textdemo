//
//  PersonDetailViewController.m
//  safe
//
//  Created by XueYongWei on 15/9/14.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "AFNetWorking.h"
#import "AllUrl.h"
#import "ChangeViewController.h"
#import "ZHPickView.h"
#import "RealNameViewController.h"
#import "LevelViewController.h"
#import "JFdetailTableViewController.h"

@interface PersonDetailViewController () <UIAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,ChangeViewControllerDelegate,UIActionSheetDelegate,ZHPickViewDelegate>

@property(nonatomic,strong)ZHPickView *pickview;
@property (nonatomic,strong)UIView *BodyView;
@property (nonatomic,copy)NSUserDefaults *UserDef;
@property (weak, nonatomic) IBOutlet UIView *lastView;

@end

@implementation PersonDetailViewController
{
    UIImage *image;
    NSInteger _currentCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    
    _BodyView = [[[NSBundle mainBundle]loadNibNamed:@"PersonDetailView" owner:self options:nil]lastObject];
    
    _BodyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _lastView.frame.origin.y+_lastView.frame.size.width + 40);
    _bodyScrollView.bounces = YES;
    _bodyScrollView.userInteractionEnabled = YES;
    _bodyScrollView.clipsToBounds = NO;
    _bodyScrollView.contentSize = CGSizeMake(0, _BodyView.frame.size.height);
    [_bodyScrollView addSubview:_BodyView];
    
    _UserDef = [NSUserDefaults standardUserDefaults];
    
    _headImage.layer.cornerRadius = _headImage.frame.size.width / 2;
    _headImage.clipsToBounds = YES;

    [self customTap];
    [self showUserDetail];
    
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"我";
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


-(void)showUserDetail
{
    NSDictionary *userDic = [NSDictionary dictionaryWithDictionary:[_UserDef objectForKey:@"info"]];
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:userDic[@"uhimgurl"]] placeholderImage:[UIImage imageNamed:@"icon_logo"]];
    
    _nickNameLable.text = userDic[@"unickname"];
    _genderLable.text = [userDic[@"usex"] isEqualToString:@"0"] ? @"男":@"女";
    _ageLable.text = userDic[@"ubirth"];
    _phoneLable.text = userDic[@"uid"];
    
    _signLable.text = userDic[@"usignname"];
    _levelLabel.text = [NSString stringWithFormat:@"%@盾",userDic[@"ucredit"]];
    if ([userDic[@"uidcard"] isEqualToString:@"未设置"]) {
        _realNameLable.text = @"请实名认证";
    }else
    {
        _realNameLable.text = userDic[@"uname"];
    }
    if ([userDic[@"urefid"] isEqualToString:@""]) {
        _refereeLable.text = @"未填写";
        
    }else
    {
        _refereeLable.text = userDic[@"urefid"];
    }
}

- (void)customTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapChangeViewClick:)];
    [_nickerView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapChangeViewClick:)];
    [_signView addGestureRecognizer:tap1];
    
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapActionClick:)];
    [_genderView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapActionClick:)];
    [_ageView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapActionClick:)];
    [_levelView addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapActionClick:)];
    [_realNameView addGestureRecognizer:tap5];
    
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapChangeViewClick:)];
    [_refereeView addGestureRecognizer:tap6];
    
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapActionClick:)];
    [_headImageView addGestureRecognizer:tap7];
}
#pragma mark 🔌changeViewContriller代理设置
- (void)onTapChangeViewClick:(UITapGestureRecognizer *)sender
{
    _currentCount = sender.view.tag;

//    if (_currentCount == 106 && (![_refereeLable.text isEqualToString:@"未设置"]))
//    {
//        [self showHint:@"推荐人已设置！" yOffset:-10];
//    }else
//    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ChangeViewController *changeVC = [story instantiateViewControllerWithIdentifier:@"Change"];
        
        _currentCount = sender.view.tag;
        
        changeVC.delegate = self;
        
        [self.navigationController pushViewController:changeVC animated:YES];
//    }
}


#pragma mark ---🔌修改本地缓存
// NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:[_UserDef objectForKey:@"info"]];
// [tmp setValue:title forKey:@"unickname"];
//[_UserDef setValue:tmp forKey:@"info"];
//[_UserDef synchronize];
//[self showUserDetail];

- (void)changeViewController:(ChangeViewController *)changeViewController needChangeTitle:(NSString *)title
{
    DbgLog(@"get %@",title);
    DbgLog(@"_currentCount %d",_currentCount);
    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:[_UserDef objectForKey:@"info"]];
    
    
    
    NSDictionary *userDic = [NSDictionary dictionaryWithDictionary:[_UserDef objectForKey:@"info"]];
    if(_currentCount == 100)//昵称
    {
        _nickNameLable.text = title;
        NSDictionary *dic = @{@"nickName":title,@"token":userDic[@"token"]};
        [self prepareDataWithDic:dic];
        [tmp setValue:title forKey:@"unickname"];
        
    }else if (_currentCount == 102)//签名
    {
        _signLable.text = title;
        NSDictionary *dic = @{@"userSign":title,@"token":userDic[@"token"]};
        [self prepareDataWithDic:dic];
        [tmp setValue:title forKey:@"usignname"];
    }else if (_currentCount == 106)//推荐人
    {
        _refereeLable.text = title;
        NSDictionary *dic = @{@"urefid":title,@"token":userDic[@"token"]};
        [self prepareDataWithDic:dic];
        [tmp setValue:title forKey:@"urefid"];
//   以下各自发起网络请求，不要再在此发起请求修改了
    }else if (_currentCount == 202)//实名认证
    {
        DbgLog(@"实名认证");
        _realNameLable.text = title;
        [tmp setValue:title forKey:@"uname"];
    }
    [_UserDef setValue:tmp forKey:@"info"];
    [_UserDef synchronize];
    [self showUserDetail];
}
- (void)onTapActionClick:(UITapGestureRecognizer *)sender
{
    [_pickview remove];
    _currentCount = sender.view.tag;
    
    if(sender.view.tag == 101)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [actionSheet showInView:self.view];
    }else if (sender.view.tag == 103)
    {
        NSDate *date=[NSDate date];
        
        _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        _pickview.delegate=self;
        
        [_pickview show];
        
    }else if (sender.view.tag == 201)//我的等级
    {
        
        LevelViewController *leVC = [[LevelViewController alloc]initWithNibName:@"LevelViewController" bundle:nil];
        
        [self.navigationController pushViewController:leVC animated:YES];
    }else if (sender.view.tag == 202)//实名认证
    {
        RealNameViewController *prlnVC = [[RealNameViewController alloc]initWithNibName:@"RealNameViewController" bundle:nil];
//        if ([_realNameLable.text isEqualToString:@"未设置"]) {
            [self.navigationController pushViewController:prlnVC animated:YES];
//        }else
//        {
//            [self showHint:@"您已成功认证！" yOffset:-10];
//        }
    }else if (sender.view.tag == 10)//上传头像
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册选取",@"相机拍照", nil];
        [actionSheet showInView:self.view];
    }
    
}
#pragma mark ---时间选择器选择时间
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    NSDictionary *userDic = [NSDictionary dictionaryWithDictionary:[_UserDef objectForKey:@"info"]];
    
    _ageLable.text = [resultString substringWithRange:NSMakeRange(0, 10)];
    NSDictionary *dic = @{@"birth":resultString ,@"token":userDic[@"token"]};
    
    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:[_UserDef objectForKey:@"info"]];
    [tmp setValue:_ageLable.text forKey:@"ubirth"];
    [_UserDef setValue:tmp forKey:@"info"];
    [_UserDef synchronize];
    [self showUserDetail];
    
    [self prepareDataWithDic:dic];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
     NSDictionary *userDic = [NSDictionary dictionaryWithDictionary:[_UserDef objectForKey:@"info"]];
    if(_currentCount == 10)
    {
        if(buttonIndex == 0)
        {
            UIImagePickerController *photoLibraryPicker = [[UIImagePickerController alloc] init];
            photoLibraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            photoLibraryPicker.allowsEditing = YES;
            photoLibraryPicker.delegate = self;
            [self presentViewController:photoLibraryPicker animated:YES completion:nil];
        }else if (buttonIndex == 1)
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
                cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                cameraPicker.allowsEditing = YES;
                cameraPicker.delegate = self;
                [self presentViewController:cameraPicker animated:YES completion:nil];
            }
        }
    }else if(_currentCount == 101)
    {
        NSString *sexStr;
        if(buttonIndex == 0)
        {
            _genderLable.text = @"男";
            sexStr = @"0";
            NSDictionary *dic = @{@"sex":@"0",@"token":userDic[@"token"]};
            [self prepareDataWithDic:dic];
        }else if (buttonIndex == 1)
        {
            _genderLable.text = @"女";
            sexStr = @"1";
            NSDictionary *dic = @{@"sex":@"1",@"token":userDic[@"token"]};
            [self prepareDataWithDic:dic];
        }
        NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:[_UserDef objectForKey:@"info"]];
        [tmp setValue:sexStr forKey:@"usex"];
        [_UserDef setValue:tmp forKey:@"info"];
        [_UserDef synchronize];
        [self showUserDetail];
    }
}

- (void)prepareDataWithDic:(NSDictionary *)sender
{
    DbgLog(@"修改个人信息：%@",sender);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/upDateUser"];
    [manager POST:strUrl parameters:sender success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"修改成功 %@  date:%@",rspDic,rspDic[@"data"]);
        
//        NSUserDefaults *usDef = [NSUserDefaults standardUserDefaults];
//        NSMutableDictionary *usDic = [NSMutableDictionary dictionaryWithDictionary:[usDef objectForKey:@"info"]];
//        
////        NSDictionary *trsDic = [self transToAllStringInDic:rspDic];
//        
//        NSMutableDictionary *nowDic = [[NSMutableDictionary alloc]initWithDictionary:usDic];
//        [nowDic addEntriesFromDictionary:rspDic[@"data"]];
//        
////        NSDictionary *defDic = [[NSDictionary alloc]initWithDictionary:nowDic];
//
//        [usDef setValue:nowDic forKey:@"info"];
//        [usDef synchronize];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:@"设置失败，稍后再试" yOffset:-10];
    }];
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
    return retDic;
}
-(NSString *)getTureStringWith:(NSString *)string withType:(int) type
{
    DbgLog(@"get string %@",string);
    if (string) {
        if ([[NSString stringWithFormat:@"%@",string] isEqualToString:@"<null>"]) {
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
            return [NSString stringWithFormat:@"%@",string];
        }
    }else
    {
        return @"未设置";
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
        image = info[UIImagePickerControllerOriginalImage];
        self.headImage.image = image;
        
        AFHTTPRequestOperationManager *managger = [AFHTTPRequestOperationManager manager];
        managger.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSDictionary *userDic = [userDef objectForKey:@"info"];
        
        NSDictionary *dic = @{@"token":userDic[@"token"]};
        
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/upload/image/head"];
        
        [managger POST:strUrl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSData *data = UIImageJPEGRepresentation(image, 1);
            NSString *HdImgUrl = [NSString stringWithFormat:@"%@",[NSDate date]];
            [formData appendPartWithFileData:data name:@"photo" fileName:[NSString stringWithFormat:@"%@.jpg",HdImgUrl] mimeType:@"image/jpeg"];
            
        }success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            DbgLog(@"success------>>>>>>%@",rspDic);
            if ([rspDic[@"code"] integerValue] == 201) {
               [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
//                NSMutableDictionary *udic = [NSMutableDictionary dictionaryWithDictionary:[userDef objectForKey:@"info"]] ;
//                [udic setValue:rspDic[@"data"] forKey:@"uhimgurl"];
//                [userDef setValue:udic forKey:@"info"];
//                [userDef synchronize];
                [self showUserDetail];
//                [_headImage setImage:image];
            }
            
  
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            DbgLog(@"failure:%@",error.localizedDescription);
            
        }];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_pickview remove];
    [self.delegate reloadMenuDataAndView];
}


@end
