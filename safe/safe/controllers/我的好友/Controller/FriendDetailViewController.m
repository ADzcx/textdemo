//
//  FriendDetailViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/3.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "alumTableViewController.h"
#import "FriendMoreDtlVController.h"
#import "ChatViewController.h"
#import "Manager.h"

@interface FriendDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *bodyScrollView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSigLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userSexImageView;
@property (weak, nonatomic) IBOutlet UIView *beizhuView;
@property (weak, nonatomic) IBOutlet UISwitch *weizhiyinshenSwitch;
@property (weak, nonatomic) IBOutlet UIView *gerenxiangceView;
@property (weak, nonatomic) IBOutlet UIView *zujiView;
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrView;
@property (nonatomic,copy)NSMutableArray *hisPhotoArray;
@property (weak, nonatomic) IBOutlet UIImageView *jidunImgView;


@property (nonatomic,strong)UIView *bodyView;
@end

@implementation FriendDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    [self addTapOnViews];
    [self friendsDetail:_chatterName];
    [self HisPhoto];
    DbgLog(@"权限值是:%@",_rauth);
    _hisPhotoArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
}
-(void)addTapOnViews
{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [_beizhuView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [_gerenxiangceView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [_zujiView addGestureRecognizer:tap3];
    
}
-(void)tapView:(UITapGestureRecognizer *)sender
{
    DbgLog(@"%ld",(long)sender.view.tag);
    switch (sender.view.tag) {
        case 102:
        {
            alumTableViewController *altVC = [[alumTableViewController alloc]init];
            altVC.isSelf = NO;
            DbgLog(@"当前用户是%@",_chatterName);
            altVC.userId = _chatterName;
            [self.navigationController pushViewController:altVC animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"xiabiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"详细资料";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
    
//    UIButton *morebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    morebtn.frame = CGRectMake(0, 0, 25, 25);
//    [morebtn setBackgroundImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
//    [morebtn addTarget:self action:@selector(onMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:morebtn];
    
    _bodyView = [[[NSBundle mainBundle]loadNibNamed:@"FriendDetailView" owner:self options:nil]lastObject];
    [_bodyScrollView addSubview:_bodyView];
    _bodyScrollView.showsVerticalScrollIndicator = NO;
    _bodyScrollView.contentSize = CGSizeMake(0, _bodyView.frame.size.height );
}
-(void)friendsDetail:(NSString *)fid
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_chatterName forKey:@"userIdB"];
    NSLog(@"%@",_chatterName);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/info"];
    //    DbgLog(@"发起请求的网址;%@ %@ %@",strUrl,userDic[@"token"],_ownerId);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        //        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        if ([rspDic[@"code"] integerValue ] == 201) {
            NSDictionary *dataDic = rspDic[@"data"];
            DbgLog(@"data里面的内容是;%@",dataDic);
            NSString *userBheadImageUrl = [NSString stringWithFormat:@"%@",dataDic[@"uhimgurl"]];
            [_userHeadImageView sd_setImageWithURL:[NSURL URLWithString:userBheadImageUrl] placeholderImage:[UIImage imageNamed:@"3"]];
            _userNameLabel.text = dataDic[@"uid"];
            _userNickNameLabel.text = dataDic[@"unickname"];
            _userSigLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"usignname"]];
            _rauth = dataDic[@"uemtoken"];
            if ([self.rauth isEqualToString:@"0000"]) {
                _weizhiyinshenSwitch.on = NO;
            }else
            {
                _weizhiyinshenSwitch.on = YES;
            }
            NSString *hisSexStr = [NSString stringWithFormat:@"%@",dataDic[@"usex"]];
            if ([hisSexStr isEqualToString:@"1"]) {//1是女
                [_userSexImageView setImage:[UIImage imageNamed:@"nvGrzl"]];
            }else
            {
                [_userSexImageView setImage:[UIImage imageNamed:@"nanGrzl"]];
            }
            NSString *dengjiStr = [NSString stringWithFormat:@"%@",dataDic[@"ucredit"]];
            NSString *djDunStr = [NSString stringWithFormat:@"%@dengjidun",dengjiStr];
            [_jidunImgView sd_setImageWithURL:[NSURL URLWithString:djDunStr] placeholderImage:[UIImage imageNamed:@"0dengjidun"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
    
}

-(void)HisPhoto
{
//xxx.xxx.xxx.xxx:port/zrwt/aux/photo/list/get?token=TestZhuff01&userIdB=xxx
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_chatterName forKey:@"userIdB"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/list/get"];
    //    DbgLog(@"发起请求的网址;%@ %@ %@",strUrl,userDic[@"token"],_ownerId);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        //        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        if ([rspDic[@"code"] integerValue] == 201) {
            NSArray *dataArr = rspDic[@"data"];
            
            NSDictionary *pt1 = dataArr[0];
            NSArray *photoRec1 = pt1[@"photoRecords"];
            for (NSDictionary *pt in photoRec1) {
                NSString *imgUrl =  pt[@"url"];
                [_hisPhotoArray addObject:imgUrl];
                
            }
            DbgLog(@"_hisPhotoArray里面的内容是;%@",_hisPhotoArray);
            for (int i=0; i<_hisPhotoArray.count; i++) {
                UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(i*60, 5, 50, 50)];
                [imgv sd_setImageWithURL:[NSURL URLWithString:_hisPhotoArray[i]] placeholderImage:[UIImage imageNamed:@"icon_logo"]];
                [_photoScrView addSubview:imgv];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}

-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onMoreBtnClick:(UIButton *)sender
{
    FriendMoreDtlVController *fmVC = [[FriendMoreDtlVController alloc]init];
    [self.navigationController pushViewController:fmVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)weizhiYSValueChange:(id)sender {
//    type :
//    1000:足迹禁止，-1000足迹开放
//    100：实时位置禁止，-100实时位置开放
//    禁止时，需要传递longitude,altitude
//xxx.xxx.xxx.xxx:port/zrwt/friend/set/auth?token=xxx&userIdB=xxx
    NSString *type = @"";
    if (_weizhiyinshenSwitch.on == YES) {
        type = @"100";
    }else
    {
        type = @"-100";
    }
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDef objectForKey:@"info"];
    
    if ([userDic[@"uid"] isEqualToString:_chatterName]) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"不能对自己设置" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
        return;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_chatterName forKey:@"userIdB"];
    [param setValue:type forKey:@"type"];
    Manager *mng = [Manager manager];
    NSString *la = [NSString stringWithFormat:@"%f", mng.mainView.localCoordinate.latitude];
    NSString *lo = [NSString stringWithFormat:@"%f",mng.mainView.localCoordinate.longitude];
    NSString *po = [NSString stringWithFormat:@"%@",mng.mainView.localAddress];
    
    [param setValue:lo forKey:@"longitude"];
    [param setValue:la forKey:@"altitude"];
    [param setValue:po forKey:@"pos"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/set/auth"];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        [MBProgressHUD hideHUDForView:window animated:YES];
        if ([rspDic[@"code"] integerValue] == 200) {
            
            if ([param[@"type"] isEqualToString:@"100"]) {
                [self showHint:@"对方将无法看到您的实时位置！" yOffset:-100];
                DbgLog(@"改变后的x:%@",_rauth);
            }else if ([param[@"type"] isEqualToString:@"-100"])
            {
                [self showHint:@"对方可以查看您的实时位置！" yOffset:-100];
            }
        }else
        {
            if (_weizhiyinshenSwitch.on == NO) {
                _weizhiyinshenSwitch.on = YES;
            }else
            {
                _weizhiyinshenSwitch.on = NO;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        DbgLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}
- (IBAction)sendMessageClick:(UIButton *)sender {
//    if (self.navigationController) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else
//    {
//        
//    }
    NSUserDefaults *usdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [usdef objectForKey:@"info"];
    
    if ([userdic[@"uid"] isEqualToString:_chatterName]) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"不能给自己聊天" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
        return;
    }
    ChatViewController *ctVC = [[ChatViewController alloc]initWithChatter:_chatterName isGroup:NO];
    [self.navigationController pushViewController:ctVC animated:YES];
    
}
- (IBAction)onCallClick:(UIButton *)sender {
    
    NSUserDefaults *usdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [usdef objectForKey:@"info"];
    
    if ([userdic[@"uid"] isEqualToString:_chatterName]) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"不能给自己打电话" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
        return;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_chatterName];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (IBAction)onDaoHangClick:(UIButton *)sender {
    
    NSUserDefaults *usdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [usdef objectForKey:@"info"];
    
    if ([userdic[@"uid"] isEqualToString:_chatterName]) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"不能对自己导航" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
        return;
    }
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_chatterName forKey:@"rbid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/mongo/findByUnames"];
    //    DbgLog(@"发起请求的网址;%@ %@ %@",strUrl,userDic[@"token"],_ownerId);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"%@",rspDic);
        if ([rspDic[@"code"] integerValue] == 201) {
            NSArray *data = rspDic[@"data"];
            NSDictionary *HisPo = data[0];
            NSString *hisLa = HisPo[@"c_ALTIT"];
            NSString *hisLo = HisPo[@"c_LONGIT"];
            Manager *manager = [Manager manager];
            
            //_lastCoordinate = CLLocationCoordinate2DMake([dic[@"data"][0][@"c_ALTIT"] doubleValue], [dic[@"data"][0][@"c_LONGIT"] doubleValue]);
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([hisLa doubleValue], [hisLo doubleValue]);
            if (manager.mainView.endAnnotation)
            {
                manager.mainView.endAnnotation.coordinate = coordinate;
            }
            else
            {
                manager.mainView.endAnnotation = [[NavPointAnnotation alloc] init];
                [manager.mainView.endAnnotation setCoordinate:coordinate];
                manager.mainView.endAnnotation.title        = @"终 点";
                manager.mainView.endAnnotation.navPointType = NavPointAnnotationEnd;
                [manager.mainView.mapView addAnnotation:manager.mainView.endAnnotation];
            }
            
            [manager.mainView.naviManager calculateDriveRouteWithEndPoints:@[[AMapNaviPoint locationWithLatitude:coordinate.latitude    longitude:coordinate.longitude]]
                                                                 wayPoints:nil
                                                           drivingStrategy:AMapNaviDrivingStrategyShortDistance];
        }else
        {
            [self showHint:rspDic[@"msg"] yOffset:-100];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];

    
}
- (IBAction)onDeleteFriend:(UIButton *)sender {
//xxx.xxx.xxx.xxx:port/zrwt/friend/del?token=xxx&userIdB=xxx
    NSUserDefaults *usdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [usdef objectForKey:@"info"];
    
    if ([userdic[@"uid"] isEqualToString:_chatterName]) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"不能删除自己" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
        return;
    }
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_chatterName forKey:@"userIdB"];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    DbgLog(@"%@",_chatterName);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/del"];
    //    DbgLog(@"发起请求的网址;%@ %@ %@",strUrl,userDic[@"token"],_ownerId);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        if ([rspDic[@"code"] integerValue] == 200) {
            [self showHint:@"已删除！" yOffset:-100];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        DbgLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
   
}

@end
