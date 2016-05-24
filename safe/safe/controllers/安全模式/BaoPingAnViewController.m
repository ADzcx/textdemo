//
//  BaoPingAnViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/9.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "BaoPingAnViewController.h"
#import "UrgentFriendViewController.h"
#import "PlistListViewController.h"
#import "Manager.h"

@interface BaoPingAnViewController ()<UrgentFriendViewControllerDelegate,PlistlistViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *middleScrollView;
@property (nonatomic,copy)NSMutableArray *friendsArray;
@property (weak, nonatomic) IBOutlet UILabel *mudidiLabel;
@property (nonatomic,copy)NSString *longitude;
@property (nonatomic,copy)NSString *altitude;
@property (weak, nonatomic) IBOutlet UIButton *shanchubtk;


@end

@implementation BaoPingAnViewController
{
    UIButton *addBtn;
    int isDel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self custSlider];
    [self customUI];
    [self custNaviItm];
    isDel = 0;
    _friendsArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"报平安";
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
-(void)custSlider
{
    [_timeSlider addTarget:self action:@selector(timeSliderChange) forControlEvents:UIControlEventValueChanged];
    _timeSlider.continuous = YES;
    _timeSlider.value = 30;
    
}
- (void)customUI
{
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(10, 5, 40, 40);
    addBtn.layer.cornerRadius = addBtn.frame.size.width / 2;
    addBtn.clipsToBounds = YES;
    [addBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(onAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_middleScrollView addSubview:addBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapMDD)];
    [_mudidiLabel addGestureRecognizer:tap];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendBtn.frame = CGRectMake(0, 0, 40, 30);
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(onSendClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
}
#pragma mark 🔌---点击了目的地
-(void)onTapMDD
{
    PlistListViewController *plistVC = [[PlistListViewController alloc] init];
    
    plistVC.delegate = self;
    [self.navigationController pushViewController:plistVC animated:YES];
}
#pragma mark 🔌---点击了发送按钮
-(void)onSendClick:(UIButton *)sender
{
    if (_friendsArray.count < 1) {
        [self showHint:@"请选择要通知的好友" yOffset:-100];
        return;
    }
    if ((_longitude.length < 1 )||(_altitude.length < 1 )) {
        [self showHint:@"请选择目的地" yOffset:-100];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/SafeWell/save"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
//    Manager *safemng = [Manager manager];
//    NSString *la = [NSString stringWithFormat:@"%f",safemng.mainView.localCoordinate.latitude];
//    NSString *lo = [NSString stringWithFormat:@"%f",safemng.mainView.localCoordinate.longitude];
//    NSString *po = [NSString stringWithFormat:@"%@",safemng.mainView.localAddress];

    NSString *map = [NSString stringWithFormat:@"{lng:%@,lat:%@}",_longitude,_altitude];
    NSMutableString *sphones = [[NSMutableString alloc]initWithString:_friendsArray[0]];
    
    for (int i=1; i<_friendsArray.count; i++) {
        [sphones appendFormat:@",%@",_friendsArray[i]];
    }
    
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:map forKey:@"map"];
    [param setValue:_mudidiLabel.text forKey:@"spos"];
    [param setValue:[NSString stringWithFormat:@"%d",(int)_timeSlider.value] forKey:@"ss"];
    [param setValue:sphones forKey:@"sphones"];
    DbgLog(@"发送的数据-------->%@",param);
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        [self showHint:@"到达时将会通知您！" yOffset:-100];
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)timeSliderChange
{
    int h = ((int)_timeSlider.value)/60;
    int m = ((int)_timeSlider.value)%60;
    DbgLog(@"h=%d",h);
    if (h>0) {
        _timeLabel.text = [NSString stringWithFormat:@"%d小时%d分钟",h,m];
    }else
    {
        _timeLabel.text = [NSString stringWithFormat:@"%d分钟",m];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ChooseByTXL:(NSMutableArray *)friendIdArray
{
    for (NSString *friendId in friendIdArray) {
        for (UIButton *subView in _middleScrollView.subviews) {
            CGRect rect = subView.frame;
            rect.origin.x += 50;
            subView.frame = rect;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(0, 5, 40, 40);
        
        btn.layer.cornerRadius = btn.frame.size.width / 2;
        
        btn.clipsToBounds = YES;
        
        [btn setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
        [_friendsArray addObject:friendId];
        btn.tag = _friendsArray.count+100;
        [btn addTarget:self action:@selector(onDelFriend:) forControlEvents:UIControlEventTouchUpInside];
        [_middleScrollView addSubview:btn];
    }
}
- (void)onAddBtnClick:(UIButton *)sender
{
    UrgentFriendViewController *urVC = [[UrgentFriendViewController alloc] init];
    
    urVC.delegate = self;
    urVC.currentType = 201;
    [self.navigationController pushViewController:urVC animated:YES];
}
#pragma mark 🔌---好友选择列表的代理
- (void)urgentFriendViewController:(UrgentFriendViewController *)urgentFriendViewController changefriendId:(NSString *)friendId
{
    for (UIButton *subView in _middleScrollView.subviews) {
        CGRect rect = subView.frame;
        rect.origin.x += 50;
        subView.frame = rect;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 5, 40, 40);
    
    btn.layer.cornerRadius = btn.frame.size.width / 2;
    
    btn.clipsToBounds = YES;
    
    [btn setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
    [_friendsArray addObject:friendId];
    btn.tag = _friendsArray.count+100;
    [btn addTarget:self action:@selector(onDelFriend:) forControlEvents:UIControlEventTouchUpInside];
    [_middleScrollView addSubview:btn];

}
- (void)urgentFriendViewController:(UrgentFriendViewController *)urgentFriendViewController needChangeDic:(NSDictionary *)dic
{
    DbgLog(@"%@",dic);
    
    for (UIButton *subView in _middleScrollView.subviews) {
        CGRect rect = subView.frame;
        rect.origin.x += 50;
        subView.frame = rect;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 5, 40, 40);
    
    btn.layer.cornerRadius = btn.frame.size.width / 2;
    
    btn.clipsToBounds = YES;
    if (dic[@"imageUrl"]) {
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:dic[@"imageUrl"]] forState:UIControlStateNormal];
    }else
    {
        [btn setImage:[UIImage imageNamed:@"icon_logo"] forState:UIControlStateNormal];
    }
    
    [_friendsArray addObject:dic[@"id"]];
    //[btn addTarget:self action:@selector(onAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = _friendsArray.count+100;
    [btn addTarget:self action:@selector(onDelFriend:) forControlEvents:UIControlEventTouchUpInside];
    [_middleScrollView addSubview:btn];
    
}
#pragma mark 🔌---地址选择列表的代理
- (void)plistlistViewController:(PlistListViewController *)plistVC andNeedChangeLatitude:(CGFloat)latitude andNeedChangeLongitude:(CGFloat)longgitude
{
    _longitude = [NSString stringWithFormat:@"%lf",longgitude];
    _altitude = [NSString stringWithFormat:@"%lf",latitude];
}

- (void)plistListViewController:(PlistListViewController *)plistVC addNeedChangeName:(NSString *)name
{
    _mudidiLabel.text = name;
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
        
        for (UIView *view in _middleScrollView.subviews) {
            DbgLog(@"view in subviews : %@",view);
            if (view.tag != sender.tag&&view.tag < sender.tag) {
                CGRect rect = view.frame;
                rect.origin.x -= 50;
                view.frame = rect;
            }
        }
//        CGRect adbtnRect = addBtn.frame;
//        adbtnRect.origin.x -= 50;
//        addBtn.frame = adbtnRect;
        
        [sender removeFromSuperview];
        [_friendsArray removeObjectAtIndex:sender.tag - 100 -1];
    }
    
}






@end
