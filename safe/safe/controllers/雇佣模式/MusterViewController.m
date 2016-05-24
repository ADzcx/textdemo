//
//  MusterViewController.m
//  safe
//
//  Created by andun on 15/10/5.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "MusterViewController.h"
#import "UrgentFriendViewController.h"
#import "PlistListViewController.h"
#import "UIButton+EMWebCache.h"
#import "Manager.h"

@interface MusterViewController () <ZHPickViewDelegate,UrgentFriendViewControllerDelegate,PlistlistViewControllerDelegate,UITextViewDelegate>
@property (nonatomic,copy)NSMutableArray *imagesArray;
@property (nonatomic,copy)NSMutableArray *friendsArray;
@property (nonatomic,copy)NSString *longitude;
@property (nonatomic,copy)NSString *altitude;
@property (nonatomic,copy)NSString *meetTime;
@property (weak, nonatomic) IBOutlet UIButton *shanchubtk;

@end

@implementation MusterViewController
{
    UIButton *addBtn;
    UIImage *image;
    int isDel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customUI];
    [self customNavigationBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    isDel = 0;
    _imagesArray = [[NSMutableArray alloc]init];
    _friendsArray = [[NSMutableArray alloc]init];
    _noteTextView.delegate = self;
//    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    addBtn.frame = CGRectMake(0, 0, 60, 60);
//    addBtn.layer.cornerRadius = addBtn.frame.size.width / 2;
//    addBtn.clipsToBounds = YES;
//    [addBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
//    [addBtn addTarget:self action:@selector(onAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_middleScrollView addSubview:addBtn];
    
    Manager *manager = [Manager manager];
    
    if ( manager.mainView.localAddress) {
        self.placeTitleLable.text = manager.mainView.localAddress;
    }
    
    self.longitude = [NSString stringWithFormat:@"%f",manager.mainView.localCoordinate.longitude];
    self.altitude = [NSString stringWithFormat:@"%f",manager.mainView.localCoordinate.latitude];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_pickview remove];
}

- (void)customUI
{
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(10, 20, 30, 30);
    addBtn.layer.cornerRadius = addBtn.frame.size.width / 2;
    addBtn.clipsToBounds = YES;
    [addBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(onAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_middleScrollView addSubview:addBtn];
    
}

- (void)customNavigationBar
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"发起召集";
    lable.font = [UIFont systemFontOfSize:20];
    lable.textColor = [UIColor blackColor];
    self.navigationItem.titleView = lable;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 80);
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtnSendClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

#pragma mark －－－🔌textView的代理
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [_pickview remove];
    if ([_noteTextView.text isEqualToString:@"请输入召集内容"]) {
        _noteTextView.text = @"";
    }
}
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onBtnSendClick:(UIButton *)sender
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    [_pickview remove];
    //http://xxx.xxx.xxx.xxx:port/zrwt/aux/muster/friend/img?token=xxx&list=[“aaa”, “bbb”,”cccc”]&meetTime=20140304121212&note=XXXX&longitude=xxx&altitude=xxx   /aux/muster/friend/img?token=xxx&list=[
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if (_noteTextView.text.length < 1) {
        [self showHint:@"召集内容过少" yOffset:-100];
        return;
    }
    if (_longitude.length < 1) {
        [self showHint:@"请选择地址" yOffset:-100];
        return;
    }
    if (_meetTime.length < 5) {
        [self showHint:@"请选择时间" yOffset:-100];
        return;
    }
    if (_friendsArray.count < 1) {
        [self showHint:@"请选择好友" yOffset:-100];
        return;
    }
    Manager *mng = [Manager manager];
    
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_noteTextView.text forKey:@"note"];
    [param setValue:_longitude forKey:@"longitude"];
    [param setValue:_altitude forKey:@"altitude"];
    [param setValue:_meetTime forKey:@"meetTime"];
    [param setValue:self.placeTitleLable.text forKey:@"pos"];

    NSMutableString *str = [[NSMutableString alloc] init];
    NSString *straaa = [NSString stringWithFormat:@"%@",_friendsArray];
    if (_friendsArray.count > 0) {
        [str appendFormat:@"[%@",_friendsArray[0]];
    }
    for (int i = 1; i<_friendsArray.count; i++) {
        [str appendFormat:@",%@",_friendsArray[i] ];
    }
    [str appendFormat:@"]"];

    NSString *list = [NSString stringWithFormat:@"%@",str];
    DbgLog(@"好友列表:%@",list);
    [param setValue:[NSString stringWithFormat:@"%@",list] forKey:@"list"];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    if (_imagesArray.count>0) {
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/muster/friend/img"];
        DbgLog(@"发送的数据是 %@ : %@",strUrl,param);
        [manager POST:strUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if(_imagesArray.count > 0)
            {
                for (NSInteger i = 0; i < _imagesArray.count; i++) {
                    UIImage *image11 = _imagesArray[i];
                    NSData *data = UIImageJPEGRepresentation(image11, 1);
                    NSString *imageName = [NSString stringWithFormat:@"1%ld.jpg",(long)i];
                    [formData appendPartWithFileData:data name:@"images" fileName:imageName mimeType:@"image/jpeg"];
                    
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
            [MBProgressHUD hideHUDForView:window animated:YES];
            if ([rspDic[@"code"] integerValue] == 200) {
                [self showHint:@"等待好友响应..." yOffset:-100];
                //取出本地用户信息
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [self showHint:rspDic[@"msg"] yOffset:-100];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:window animated:YES];
            NSLog(@"failure------------->>>>> :%@",error.localizedDescription);
            [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
            
        }];
    }else
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/muster/friend"];
        DbgLog(@"发送的数据是 %@ : %@",strUrl,param);
        [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
            if ([rspDic[@"code"] integerValue] == 200) {
                [self showHint:@"等待好友响应..." yOffset:-100];
                //取出本地用户信息
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [self showHint:rspDic[@"msg"] yOffset:-100];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            NSLog(@"failure :%@",error.localizedDescription);
            [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
        }];
    }
}

- (void)onAddBtnClick:(UIButton *)sender
{
    
    [_pickview remove];
        UrgentFriendViewController *urVC = [[UrgentFriendViewController alloc] init];
        
        urVC.delegate = self;
        
        urVC.currentType = 105;
        
        [self.navigationController pushViewController:urVC animated:YES];

}

- (void)urgentFriendViewController:(UrgentFriendViewController *)urgentFriendViewController changefriendId:(NSString *)friendId
{
    
}

- (void)urgentFriendViewController:(UrgentFriendViewController *)urgentFriendViewController needChangeDic:(NSDictionary *)dic
{
    DbgLog(@"%@",dic);
    
    for (UIView *subView in _middleScrollView.subviews) {
        CGRect rect = subView.frame;
        rect.origin.x += 50;
        subView.frame = rect;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 10, 40, 40);
    
    btn.layer.cornerRadius = btn.frame.size.width / 2;
    
    btn.clipsToBounds = YES;
    if ([dic objectForKey:@"imageUrl"]) {
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:dic[@"imageUrl"]] forState:UIControlStateNormal];
    }else
    {
        [btn setImage:[UIImage imageNamed:@"icon_logo"] forState:UIControlStateNormal];
    }
    
    [_friendsArray addObject:dic[@"rbid"]];
    //[btn addTarget:self action:@selector(onAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_middleScrollView addSubview:btn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnImageClick:(UIButton *)sender {
    
    [_pickview remove];
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
    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        image = info[UIImagePickerControllerEditedImage];
// 把得到的的图片添加到图片数组里
        [_imagesArray addObject:image];
        if(image)
        {
            UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imageBtn.frame = CGRectMake(_onBtnPhotoImage.frame.origin.x + _onBtnPhotoImage.frame.size.width + 10, _onBtnPhotoImage.frame.origin.y, 40, 40);
            [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
            [_mainView addSubview:imageBtn];
            
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_pickview remove];
    [self.view endEditing:YES];
}



- (IBAction)onBtnTimeClick:(UIButton *)sender {
    
    NSDate *date=[NSDate date];
    [_pickview remove];
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
//    //设置转换后的目标日期时区
//    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//    //得到源日期与世界标准时间的偏移量
//    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
//    //目标日期与本地时区的偏移量
//    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
//    //得到时间偏移量的差值
//    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
//    //转为现在时间
//    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    if (!_pickview) {
        _pickview = [[ZHPickView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDateAndTime isFromeNow:YES isHaveNavControler:NO];
    }
    
    _pickview.delegate=self;
    
    [_pickview show];
}

- (IBAction)onBtnPlaceClick:(UIButton *)sender {
    
    PlistListViewController *plistVC = [[PlistListViewController alloc] init];
    
    plistVC.delegate = self;
    
    plistVC.plistType = 105;
    
    [self.navigationController pushViewController:plistVC animated:YES];
    
}

- (void)plistlistViewController:(PlistListViewController *)plistVC andNeedChangeLatitude:(CGFloat)latitude andNeedChangeLongitude:(CGFloat)longgitude
{
    _longitude = [NSString stringWithFormat:@"%lf",longgitude];
    _altitude = [NSString stringWithFormat:@"%lf",latitude];
}

- (void)plistListViewController:(PlistListViewController *)plistVC addNeedChangeName:(NSString *)name
{
    self.placeTitleLable.text = name;
}

- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    DbgLog(@"时间选择器返回的数据:%@",resultString);
    NSString *year = [resultString substringWithRange:NSMakeRange(0, 4)];
    NSString *mon = [resultString substringWithRange:NSMakeRange(5,2)];
    NSString *day = [resultString substringWithRange:NSMakeRange(8, 2)];
    NSString *hor = [resultString substringWithRange:NSMakeRange(11, 2)];
    NSString *min = [resultString substringWithRange:NSMakeRange(14, 2)];

    NSString *timeText = [NSString stringWithFormat:@"%@%@%@%@%@00",year,mon,day,hor,min];
    self.timaLable.text = [resultString substringWithRange:NSMakeRange(0, 16)];
    _meetTime = timeText;
}
- (IBAction)onDelClick:(UIButton *)sender {
    if (isDel == 1) {
        isDel =0;
        [_shanchubtk setTitle:@"删除好友" forState:UIControlStateNormal];
    }else
    {
        isDel = 1;
        [_shanchubtk setTitle:@"完成" forState:UIControlStateNormal];
        [self showHint:@"请点击要删除的好友头像" yOffset:-120];
    }
}

//点击删除按钮后，再次点击头像将会触发删除操作
-(void)onDelFriend:(UIButton *)sender
{
    //    [_friendsArray removeObjectAtIndex:];
    if (isDel == 1) {
        DbgLog(@"点击了 %d",sender.tag -100);
        [sender removeFromSuperview];
        int i = 1;
        for (UIView *view in _middleScrollView.subviews) {
            view.tag = 100+i;
        }
        i=1;
        [_friendsArray removeObjectAtIndex:sender.tag - 100 -1];
        for (int i= sender.tag -100 ; i > 0 ; i--) {
            UIView *subView = _middleScrollView.subviews[i];
            
            CGRect rect = subView.frame;
            rect.origin.x -= 50;
            subView.frame = rect;
            
            CGRect adbtnRect = addBtn.frame;
            adbtnRect.origin.x -= 50;
            addBtn.frame = adbtnRect;
        }
    }
}



@end
