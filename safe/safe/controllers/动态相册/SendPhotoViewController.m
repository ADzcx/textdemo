//
//  SendPhotoViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/23.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "SendPhotoViewController.h"
#import "SendImageView.h"
#import "Manager.h"

@interface SendPhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (nonatomic,assign)NSInteger ImgSize;
@property (nonatomic,assign)NSInteger thisPhoto;
@property (nonatomic,copy)NSMutableDictionary *param;
@property (nonatomic,copy)NSMutableArray *imageArray;

@property (nonatomic,copy)NSString *la;
@property (nonatomic,copy)NSString *lo;
@property (nonatomic,copy)NSString *po;

@end

@implementation SendPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    _param = [[NSMutableDictionary alloc]initWithObjectsAndKeys:userDic[@"token"],@"token", nil];
    _thisPhoto = 0;
    _imageArray = [[NSMutableArray alloc]initWithObjects:nil];
    _imgScrollView.pagingEnabled = NO;
    _imgScrollView.contentSize = CGSizeMake(320, 120);
    
    UIButton *SendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    SendBtn.frame = CGRectMake(0, 0, 30, 30);
    [SendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [SendBtn addTarget:self action:@selector(sendNewPhoto) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:SendBtn];
    _ImgSize = 80;
    [_imageArray addObject:_image];
    [self custonImageSclView];
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"发布";
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
    
    Manager * mng = [Manager manager];
    _po = [NSString stringWithFormat:@"%@",mng.mainView.localAddress];
    _la = [NSString stringWithFormat:@"%f",mng.mainView.localCoordinate.latitude];
    _lo = [NSString stringWithFormat:@"%f",mng.mainView.localCoordinate.longitude];
    
    _positionLabel.text = _po;
    
}
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)custonImageSclView
{
    for (UIView *view in _imgScrollView.subviews) {
        DbgLog(@"delete one!");
        [view removeFromSuperview];
    }
    
//    循环添加已经选择的照片
    for (NSInteger i=0; i<_imageArray.count; i++) {
        DbgLog(@"添加了一张 %@",_imageArray[i]);
        
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(_ImgSize*i, 10, _ImgSize-2, _ImgSize-2)];
        view.tag = i+100 ;
        [view setImage:_imageArray[i]];
        [_imgScrollView addSubview:view];
    }
    _imgScrollView.contentSize = CGSizeMake(_imageArray.count*_ImgSize, 0);
}

-(void)onDeleteImgClick:(UIButton *)sender
{
    DbgLog(@"删除这个!");
}
-(void)sendNewPhoto
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    
    AFHTTPRequestOperationManager *managger = [AFHTTPRequestOperationManager manager];
    managger.responseSerializer = [AFHTTPResponseSerializer serializer];
    managger.requestSerializer.timeoutInterval = 8.0;
    [_param setValue:_noteTextField.text forKey:@"note"];
    [_param setValue:_lo forKey:@"longitude"];
    [_param setValue:_la forKey:@"altitude"];
    [_param setValue:_po forKey:@"pos"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/upload/image/photo"];
    DbgLog(@"_param %@",_param);
    [managger POST:strUrl parameters:_param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        DbgLog(@"sendpar :%@",_param);
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYMMddHHmmss"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        DbgLog(@"data:%@",locationString);
        int i=0;
        for (UIImage *image in _imageArray) {
            NSString *pname = [NSString stringWithFormat:@"%@_%d.jpg",locationString,i++];
            NSData *data = UIImageJPEGRepresentation(image, 1);
            DbgLog(@"add img ");
            [formData appendPartWithFileData:data name:@"photo" fileName:pname mimeType:@"image/jpeg"];
        }
        
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideHUDForView:window animated:YES];
        DbgLog(@"rspdic --- %@",rspDic);
        if ([rspDic[@"code"] intValue] == 200) {
            [self showHint:@"发布成功!" yOffset:-100];
        }else
        {
             [self showHint:rspDic[@"msg"] yOffset:-100];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure:%@",error.localizedDescription);
        [self showHint:error.localizedDescription yOffset:-100];
    }];
    
}
- (IBAction)addPhotoClick:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"发布图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionSheet showInView:self.view];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
}

//UIActionSheet协议里定义的方法，点其中的按钮时调用
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DbgLog(@"%ld",(long)buttonIndex);
    if(buttonIndex == 0)//从相册选择
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
            cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            cameraPicker.allowsEditing = YES;
            cameraPicker.delegate = self;
            [self presentViewController:cameraPicker animated:YES completion:nil];
        }
    }else if(buttonIndex == 1)//相机拍摄
    {
        UIImagePickerController *photoLibraryPicker = [[UIImagePickerController alloc] init];
        photoLibraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        photoLibraryPicker.allowsEditing = YES;
        photoLibraryPicker.delegate = self;
        [self presentViewController:photoLibraryPicker animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [_imageArray addObject:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self custonImageSclView];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
