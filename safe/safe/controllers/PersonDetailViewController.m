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

@interface PersonDetailViewController () <UIAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,ChangeViewControllerDelegate,UIActionSheetDelegate,ZHPickViewDelegate>

@property(nonatomic,strong)ZHPickView *pickview;

@end

@implementation PersonDetailViewController
{
    UIImage *image;
    NSInteger _currentCount;
    NSArray *_array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showUserDetail];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapClick:)];
    [_headImageView addGestureRecognizer:tap];
    [self customView];
    
    _headImage.layer.cornerRadius = _headImage.frame.size.width / 2;
    _headImage.clipsToBounds = YES;
    
    
    [self customTap];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDef objectForKey:@"info"];
    NSLog(@"%@",dic[@"token"]);
    
}
//@property (weak, nonatomic) IBOutlet UIView *headImageView;
//
//@property (weak, nonatomic) IBOutlet UIImageView *headImage;
//
//@property (weak, nonatomic) IBOutlet UIView *nickerView;
//
//@property (weak, nonatomic) IBOutlet UILabel *nickNameLable;
//
//@property (weak, nonatomic) IBOutlet UIView *genderView;
//
//@property (weak, nonatomic) IBOutlet UILabel *genderLable;
//
//@property (weak, nonatomic) IBOutlet UIView *ageView;
//
//@property (weak, nonatomic) IBOutlet UILabel *ageLable;
//
//@property (weak, nonatomic) IBOutlet UIView *phoneView;
//
//@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
//
//@property (weak, nonatomic) IBOutlet UIView *signView;
//@property (weak, nonatomic) IBOutlet UILabel *signLable;
//
//@property (weak, nonatomic) IBOutlet UIView *realNameView;
//@property (weak, nonatomic) IBOutlet UILabel *realNameLable;
//
//@property (weak, nonatomic) IBOutlet UIView *trueView;
//
//@property (weak, nonatomic) IBOutlet UIView *refereeView;
//
//@property (weak, nonatomic) IBOutlet UILabel *refereeLable;

-(void)showUserDetail
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/UserBytoken"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    //如果已经登录过
    if (userDic) {
        NSDictionary *parma = @{@"token":userDic[@"token"]};
        NSLog(@"token---->%@",parma);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:strUrl parameters:parma success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *user = rspDic[@"data"];
            NSLog(@"rspDIC -- %@",user);

            
            [_headImage sd_setImageWithURL:[NSURL URLWithString:user[@"uhimgurl"]] placeholderImage:[UIImage imageNamed:@"2"]];
            _nickNameLable.text = user[@"unickname"];
            _genderLable.text = [user[@"usex"] isEqualToString:@"1"] ? @"男":@"女";
            
            _ageLable.text = [self getDateFromTimeString:user[@"ubirth"] andFormater:@"MM-dd"];
            
            DbgLog(@"ok");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure :%@",error.localizedDescription);
        }];
    }
    
}
-(NSString *)getDateFromTimeString: (NSString *)timeString andFormater:(NSString*) Formatter
{
    DbgLog(@"rec time=%@ formater=%@",timeString,Formatter);
    
    NSTimeInterval time = [timeString integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    DbgLog(@"date %@",date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:Formatter];
    
    NSString *reStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    DbgLog(@"return %@",reStr);
    return reStr;
}
- (void)customTap
{
    _array = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapChangeViewClick:)];
    [_nickerView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapChangeViewClick:)];
    [_signView addGestureRecognizer:tap1];
    
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapActionClick:)];
    [_genderView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapActionClick:)];
    [_ageView addGestureRecognizer:tap3];
}

- (void)onTapChangeViewClick:(UITapGestureRecognizer *)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ChangeViewController *changeVC = [story instantiateViewControllerWithIdentifier:@"Change"];
    
    _currentCount = sender.view.tag;
    
    changeVC.delegate = self;
    
    [self.navigationController pushViewController:changeVC animated:YES];
    
}

- (void)onTapActionClick:(UITapGestureRecognizer *)sender
{
    _currentCount = sender.view.tag;
    
    if(sender.view.tag == 101)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [actionSheet showInView:self.view];
        

    }else if (sender.view.tag == 103)
    {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"90",@"80", nil];
//        [actionSheet showInView:self.view];
        
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
        _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        _pickview.delegate=self;
        
        [_pickview show];

    }
    
}

- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    _ageLable.text = resultString;
}


- (void)changeViewController:(ChangeViewController *)changeViewController needChangeTitle:(NSString *)title
{
    if(_currentCount == 100)
    {
        _nickNameLable.text = title;
        NSDictionary *dic = @{@"UNICKNAME":title};
        [self prepareDataWithDic:dic];
        
        
    }else if (_currentCount == 102)
    {
        _signLable.text = title;
        
        NSDictionary *dic = @{@"UNICKNAME":title};
        [self prepareDataWithDic:dic];

        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(_currentCount == 101)
    {
        if(buttonIndex == 0)
        {
            _genderLable.text = @"男";
            
            NSDictionary *dic = @{@"USEX":@"男"};
            [self prepareDataWithDic:dic];

            
            
        }else if (buttonIndex == 1)
        {
            _genderLable.text = @"女";
            NSDictionary *dic = @{@"USEX":@"女"};
            [self prepareDataWithDic:dic];

        }
        
        
    }else if (_currentCount == 103)
    {
        if(buttonIndex == 0)
        {
            
            _ageLable.text = @"90";
            NSDictionary *dic2 = @{@"UBIRTH":@"90"};
            
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic11 = [userDef objectForKey:@"info"];
            NSDictionary *dic = @{@"map1":dic2,@"token":dic11[@"token"]};

            
            [self prepareDataWithDic:dic];

            
            
        }else if (buttonIndex == 1)
        {
            _ageLable.text = @"80";
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic11 = [userDef objectForKey:@"info"];
            
            NSDictionary *dic2 = @{@"UBIRTH": @"80"};
            NSDictionary *dic = @{@"U_NICKNAME":@"bsb",@"token":dic11[@"token"]};
            [self prepareDataWithDic:dic];
        }
    }
}

- (void)customView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"token":@"KzuUOmhL"};//参数
    NSLog(@"%@",dic);
    //NSString *strUrl = @"http://172.16.0.63:8080/zrwt/login/loginUser";//请求网址
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/UserBytoken"];
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"ssss%s",[responseObject bytes]);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        NSLog(@"%@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
    }];

}

- (void)prepareDataWithDic:(NSDictionary *)sender
{
    NSLog(@"%@",sender);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/upDateUser"];
    
    [manager POST:strUrl parameters:sender success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"ssss%s",[responseObject bytes]);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        NSLog(@"%@  date:%@",dic,dic[@"date"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
    }];

}

- (void)onTapClick:(UITapGestureRecognizer *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"本地相册",@"相机拍照", nil];
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
        {
            UIImagePickerController *photoLibraryPicker = [[UIImagePickerController alloc] init];
            photoLibraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            photoLibraryPicker.allowsEditing = YES;
            photoLibraryPicker.delegate = self;
            [self presentViewController:photoLibraryPicker animated:YES completion:nil];
            
        }else if(buttonIndex ==  2)
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
            [formData appendPartWithFileData:data name:@"photo" fileName:@"123456.jpg" mimeType:@"image/jpeg"];
            
            
        }success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *str = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",str);
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"failure:%@",error.localizedDescription);
            
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
    [self.delegate reloadData];
}


@end
