//
//  SendPhotoViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/23.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "SendPhotoViewController.h"

@interface SendPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIView *photoView;

@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

@property (nonatomic,copy)NSMutableDictionary *param;
@end

@implementation SendPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    _param = [[NSMutableDictionary alloc]initWithObjectsAndKeys:userDic[@"token"],@"token", nil];
    
    [self custUIWithGeData];
    
    
}

-(void)custUIWithGeData
{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    [_param setValue:userDic[@"token"] forKey:@"token"];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:_image];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.frame = CGRectMake(0, 0,300, 300);
    [_photoView addSubview:imgView];
    
    UIButton *SendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    SendBtn.frame = CGRectMake(0, 0, 30, 30);
    [SendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [SendBtn addTarget:self action:@selector(sendNewPhoto) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:SendBtn];
    
}

-(void)sendNewPhoto
{
    DbgLog(@"ohyeah!");

    AFHTTPRequestOperationManager *managger = [AFHTTPRequestOperationManager manager];
    managger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [_param setValue:_noteTextField.text forKey:@"note"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/upload/image/photo"];
    [managger POST:strUrl parameters:_param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        DbgLog(@"sendpar :%@",_param);
        NSData *data = UIImageJPEGRepresentation(_image, 1);
        [formData appendPartWithFileData:data name:@"photo" fileName:@"123456.jpg" mimeType:@"image/jpeg"];
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DbgLog(@"rspdic --- %@",rspDic);
        if ([rspDic[@"code"] intValue] == 200) {
            [self showHint:@"发布成功!" yOffset:-100];
        }else
        {
             [self showHint:rspDic[@"msg"] yOffset:-100];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure:%@",error.localizedDescription);
        [self showHint:error.localizedDescription yOffset:-100];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
