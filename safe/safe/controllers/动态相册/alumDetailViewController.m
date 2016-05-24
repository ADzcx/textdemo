//
//  alumDetailViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/17.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "alumDetailViewController.h"
#import "albumShowViewController.h"
#import "PingLunViewController.h"
#import "CustNavIew.h"

@interface alumDetailViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *bodyScrollView;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel;
@property (nonatomic,copy)NSMutableArray *BigImgurlArray;
@property (weak, nonatomic) IBOutlet UIView *DetailbottomView;
@property (weak, nonatomic) IBOutlet UIButton *ZanAndPingBtn;
@property (weak, nonatomic) IBOutlet UIButton *dianzanshuBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinglunshuBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinglunBtn;
@property (weak, nonatomic) IBOutlet UIView *albumTopView;

@property (nonatomic,copy)NSMutableArray *photoIdArray;
@property (nonatomic,assign)NSInteger currentIndex;
@end

@implementation alumDetailViewController
{
    BOOL _isHiden;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isHiden = NO;
    [self custNaviItm];
    [self getBigImgUrlArray:_imgArray];
    [self customUI];
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"xiabiaoqian"]forBarMetrics:UIBarMetricsDefault];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(alumDetaionBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
    
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
}
-(void)alumDetaionBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getBigImgUrlArray:(NSArray *)imgArray
{
    if (!_BigImgurlArray) {
        _BigImgurlArray = [[NSMutableArray alloc]init];
    }
    _photoIdArray = [[NSMutableArray alloc]init];
    for (NSDictionary *img in imgArray) {
        DbgLog(@"Before Img :%@",img);
        
        NSArray *array = [img[@"url"] componentsSeparatedByString:@"_250x250"]; //从字符A中分隔成2个元素的数组
        NSString *BigImageurl = [NSString stringWithFormat:@"%@%@",array[0],@".jpg"];
        NSString *bigImageId = img[@"photoId"];
        DbgLog(@"添加id %@的照片",bigImageId);
        [_BigImgurlArray addObject:BigImageurl];
        [_photoIdArray addObject:bigImageId];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex =   _bodyScrollView.contentOffset.x/SCREEN_WIDTH;
    DbgLog(@"当前%d图片的id%@",_currentIndex,_photoIdArray[_currentIndex]);
}
-(void)customUI
{
    for (UIView *view in _bodyScrollView.subviews) {
        [view removeFromSuperview];
    }
    _bodyScrollView.pagingEnabled = YES;
    _bodyScrollView.showsHorizontalScrollIndicator = NO;
    _bodyScrollView.delegate = self;
    _bodyScrollView.bounces = NO;
    _bodyScrollView.contentSize = CGSizeMake(_BigImgurlArray.count*SCREEN_WIDTH, 0);
    DbgLog(@"_BigImgurlArray count ;%lu",(unsigned long)_BigImgurlArray.count);
    _detailTextLabel.text = [NSString stringWithFormat:@"    %@",_content];

    [_dianzanshuBtn setTitle:[NSString stringWithFormat:@"%@",_laudCount] forState:UIControlStateNormal];
    [_pinglunshuBtn setTitle:[NSString stringWithFormat:@"%@",_commentCount] forState:UIControlStateNormal];
    if ([_isMyLaud isEqualToString:@"1"]) {
        [_zanBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    int i = 0;
   
    for (NSString *BigImgUrl in _BigImgurlArray) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapImgaeView:)];
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView addGestureRecognizer:tap];
        [imgView sd_setImageWithURL:[NSURL URLWithString:BigImgUrl] placeholderImage:[UIImage imageNamed:@"imgPlaceHd"]];
        
        [_bodyScrollView addSubview:imgView];
        i++;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onZanClick:(UIButton *)sender {//点赞
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary: [userDef objectForKey:@"info"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/laud"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_photoIdArray[_currentIndex]  forKey:@"photoId"];
    if ([_isMyLaud isEqualToString:@"1"]) {//是我赞的,取消赞
        [param setValue:@"1" forKey:@"laud"];
        [_zanBtn setTitle:@"赞" forState:UIControlStateNormal];
        _isMyLaud = @"0";
    }else
    {
        [param setValue:@"0" forKey:@"laud"];
        [_zanBtn setTitle:@"取消" forState:UIControlStateNormal];
        _isMyLaud = @"1";
    }
    
    DbgLog(@"发的参数%@",param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"修改成功 %@  date:%@",rspDic,rspDic[@"data"]);
        [self showHint:@"成功" yOffset:-200];
        int landIntVlu = _laudCount.intValue;
        if ([_isMyLaud isEqualToString:@"1"]) {
             [_dianzanshuBtn setTitle:[NSString stringWithFormat:@"%d",++landIntVlu] forState:UIControlStateNormal];
            _laudCount = [NSString stringWithFormat:@"%d",landIntVlu];
        }else
        {
             [_dianzanshuBtn setTitle:[NSString stringWithFormat:@"%d",--landIntVlu] forState:UIControlStateNormal];
            _laudCount = [NSString stringWithFormat:@"%d",landIntVlu];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}
- (IBAction)onComClick:(UIButton *)sender {
    
    PingLunViewController *plVC = [[PingLunViewController alloc]init];
    plVC.photoID = _photoIdArray[_currentIndex];

    [self presentViewController:plVC animated:YES completion:nil];

}
- (IBAction)onZanAndPingClick:(UIButton *)sender {
    albumShowViewController *alsVC = [[albumShowViewController alloc]initWithNibName:@"albumShowViewController" bundle:nil];
    DbgLog(@"%@%@%@%@",_ownerId,_imgArray,_commentCount,_content);
    alsVC.content = _content;
    alsVC.ownerId = _ownerId;
    alsVC.imgArray = _imgArray;
    alsVC.commentCount = _commentCount;
    alsVC.laudCount = _laudCount;
    alsVC.date = _date;
    alsVC.groupId = _groupId;
    alsVC.isMyLaud = _isMyLaud;
    alsVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:alsVC animated:YES completion:nil];
}

-(void)onTapImgaeView:(UITapGestureRecognizer *)sender
{
    if (_isHiden == YES) {
         CGRect newBrect = CGRectMake(0, SCREEN_HEIGHT-80,SCREEN_WIDTH,100);
        CGRect newTopRect = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        [UIView animateWithDuration:0.2 animations:^{
            _DetailbottomView.frame = newBrect;
            _albumTopView.frame = newTopRect;
        }];
        _isHiden = NO;
    }else
    {
        CGRect newBrect = CGRectMake(0, SCREEN_HEIGHT-50,SCREEN_WIDTH,100);
        CGRect newTopRect = CGRectMake(0, -64, SCREEN_WIDTH, 64);
        [UIView animateWithDuration:0.2 animations:^{
            _DetailbottomView.frame = newBrect;
            _albumTopView.frame = newTopRect;
        }];
        _isHiden = YES;
    }
}
- (IBAction)onBackClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
