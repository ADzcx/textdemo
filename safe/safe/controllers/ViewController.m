//
//  ViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/6.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "ViewController.h"
#import "AFNetWorking.h"
#import "AnimatedAnnotation.h"//动画指针
#import "AnimatedAnnotationView.h" //动画指针返回的View
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "SettingViewController.h"
#import "DongtaiView.h"
#import "testViewController.h"
#import "Manager.h"
#import "APPHeader.h"
#import "CoreUMeng.h"
#import "MenuViewController.h"
#import "XSportLight.h"
#import "LoadTeachView.h"
#import "FriendList.h"
#import "UIButton+EMWebCache.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "UrgentFriendViewController.h"
#import "FriendAndGroupViewController.h"
#import "SXImageCell.h"
#import "MusterViewController.h"
#import "SafeViewController.h"
#import "UrgentFriendViewController.h"
#import "PlistListViewController.h"
#import "DTModel.h"
#import "JCTopic.h"
#import "DTDetailViewController.h"
#import "QiuJiuViewController.h"
#import "GySendView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Toast+UIView.h"
#import "AppDelegate.h"
#import "ThisOne.h"
#import "fxsjView.h"
#import "ZDLAnnotation.h"
#import "GYZMViewController.h"
#import "RealNameViewController.h"
#import "MyZoneViewController.h"
#import <AddressBook/AddressBook.h>
#import "tongxunluModel.h"
#import "UIImage+GIF.h"

#import "TBGZTableViewController.h"


#define ModelBtnWith 50
#define ModelBtnHeight 50
#define GYVTAG 300

#pragma mark -🐶动态更改地方
@interface ViewController ()<XSportLightDelegate,MAMapViewDelegate,AMapSearchDelegate,UICollectionViewDataSource,UICollectionViewDelegate,SafeViewControllerDelegate,UrgentFriendViewControllerDelegate,friendAndGroupViewControllerDelegate,PlistlistViewControllerDelegate,JCTopicDelegate,UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *memberCenterBtn;
@property (weak, nonatomic) IBOutlet UIButton *dongTaiBtn;
@property (strong, nonatomic) IBOutlet DongtaiView *DongTaiView;
@property (nonatomic,assign)BOOL hasLogined;
@property (nonatomic,assign)int currentModel;
@property (nonatomic,copy)NSMutableDictionary *GYFBDic;
#pragma mark -🐶动态更改地方
@property (nonatomic, strong) NSMutableArray *DTimages;
@property (nonatomic, weak) UICollectionView *DTcollectionView;
@property (nonatomic, strong) NSMutableArray *DTModesArray;
@property(nonatomic,strong)JCTopic * Topic;
@property (nonatomic,strong)GySendView *gyV;
@property (nonatomic,copy)NSString *whichTouch;
@property (nonatomic,assign)NSInteger GYSexRsNum;
//通讯录
@property (nonatomic,copy)NSMutableArray *dataSourceTXL;



@end
#pragma mark -🐶动态更改地方
static NSString *const ID = @"DTimageID";
@implementation ViewController
{
    AMapSearchAPI *_searchAPI;
    double Latitude;
    double longitude;
    AnimatedAnnotation *_animatedCar;
    MAPointAnnotation *newPin;  //安全地点的选择大头针
    NSMutableArray *_pins;
    NSInteger _currentCount;
    NSInteger _currentCenter;
    NSInteger _currentTag;
    NSArray *_btnImages;
    UIView *_nearByView;
    NSArray *_btnSelectImages;
    UIButton *_selectBtn;
    NSInteger _currentLocation; //判断是不是第一次进入应用
    CLLocationCoordinate2D _coordinate; //记录当前的经纬度，防止反复上传
    NSInteger _updateLocationCurrent; //反编译传位置信息设置的参数
    UIView *_friendView; //普通模式下好友列表
    UIButton *_travelBtn; //出行模式下三个按钮上次点击Btn
    NSInteger _travelEat; //记录出行模式吃的状态
    NSInteger _travelLive; //记录出行模式的住
    NSInteger _travelTour; //记录出行模式下的行
    NSInteger _allTravelImages; //出行模式下实时的状态
    NSMutableArray *_eatArray; //搜索出来吃的列表
    NSMutableArray *_liveArray; //搜索出来住的列表
    NSMutableArray *_tourArray; //搜索出来出行的列表
    NSMutableArray *_friendList; //好友列表
    UISegmentedControl *_serchTypeSegCtl; //交通方式的选择
    NSInteger _currentFriend; //点击好友获得列表（用于发起一次网络请求)
    UIView *_currentView; //地图样式和返回原位置的View
    UIView *_trafficView; //步行，驾车，公交三个View
    AnimatedAnnotation *_animatedCar11; //好友的坐标，后期需要改
//    CGFloat _aimlatitude; //目的地的latitude
//    CGFloat _aimlongitude; //目的地的longitude
    UIButton *changeTypeBtn; //地图样式的改变；
    UIButton *backlocationBtn; //地图重新定位的Btn
    UIButton *changeAllow;//改变是否允许使用位置
    BOOL isAllowLocation;
    NSInteger Y; //记录当前定位和地图样式改变的Y值
    NSInteger keyboardhight;
    MAPointAnnotation *newPin11; //导航之后添加的大头针
   // NSMutableArray *_safePlaceArrays; //我的地盘，安全位置的设置.
    UITapGestureRecognizer *_mapViewTapGesture; //安全模式下的手势添加与删除
    UIAlertView *_alertView;  //安全模式是否需要进入导航
    MAPointAnnotation *_safeDestinationPin; //安全模式下目的地的大头针
    NSInteger _currentDistanceAnnotation; //安全模式目的地设置
    UIView *_safeView;  //进入安全模式加入的View
    NSInteger _safeState; //判断是否进入安全模式
    UIAlertView *_safeAlertView;  //是否需要进入安全模式的提醒
    NSString *_safeStr;  //目的地名称
    NSInteger _currentPolice; //安全模式下附近的警察厅
    NSInteger _currentHospiTal; //安全模式下的医院
    ZDLAnnotation *pinJC;//安全模式下附近的警察厅大头针
    ZDLAnnotation *pinYY;//安全模式下的医院大头针
    NSMutableArray *_currentSafePoliceAndHospital; //安全模式下保存警察和医院大头针的数组
    NSMutableArray *_friendsLocationArray; //好友经纬度列表
    NSMutableArray *_friendsAnnotations;  //所以好友的大头针
    NSMutableArray *_safeStateArray; //处于安全模式的好友列表
    
    UIView *_hireView;  //雇佣模式下的接单和雇佣view
    NSInteger _btnOrders;  //雇佣模式下的接单按钮
    NSInteger _currentModel3; //安全模式首次切换

    UIImage *gyImage;
    NSArray *_policeArray;  //安全模式下警察的调整
    NSArray *_photocolArray;  //安全模式下医院的调整
    UIImageView *_flashView;
    
    UIView *safeView111;  //右上角安全模式的View
    NSInteger _currentHireState; //进入雇佣模式的状态值
    NSMutableArray *_hirefriendsLocationArray; //雇佣模式下好友的经纬度
    NSMutableArray *_hirefriendsAnnotations; //雇佣模式下好友的大头针
    NSInteger _currentQuitHireState; //记录退出雇佣模式
    NSTimer *_realTimer;
    NSInteger _firstInSafe;
    UIScrollView *scrView;
}
#pragma mark -🐶动态更改地方
//返回要现实的数组
- (void)intDTimages
{
    if (!_DTimages) {
        _DTimages = [[NSMutableArray alloc] init];
        
        for (int i = 1; i<=3; i++) {
            [_DTimages addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    取一下可发送动画的次数
    [self CountOfJingXI];

    // 如果是首次使用，则加载教程界面
    //    [self showAD];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLoad"]) {
        
        [self TeachView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLoad"];
    }
    
#pragma mark ⚠只在这里添加一个定时器，循环获取好友。
    _realTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(friendReal) userInfo:nil repeats:YES];
    
    //    默认为模式4
    _currentModel = 3;
    //    添加一些手势
    [self.delegate reloadMenuDataAndViewVC:0];
    [self addGestureRecognizer];
}
-(void)LongPressAndun:(UILongPressGestureRecognizer *)sender
{
    QiuJiuViewController *qiujiuVC = [[QiuJiuViewController alloc]init];
    if (![[self modalViewController] isBeingPresented]) {
        [self presentViewController:qiujiuVC animated:YES completion:nil];
    }

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //给右下角按钮添加长按触发紧急求救手势
    UILongPressGestureRecognizer *pAD = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressAndun:)];
    [_YouxiaojiaoAndunBtn addGestureRecognizer:pAD];
    // Do any additional setup after loading the view, typically from a nib.
#pragma mark -🐶动态更改地方
    [self intDTimages];
    
    _currentTag = 103;
    
    [self showAD];
    
    _safePlaceArrays = [[NSMutableArray alloc] init];
    
    _DTModesArray = [[NSMutableArray alloc]init];
    _GYFBDic = [[NSMutableDictionary alloc]init];
    
    //self.view.backgroundColor = [UIColor yellowColor];
    
    _animatedCar11 = [[AnimatedAnnotation alloc] init];//好友的坐标，需要改
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    _btnImages = [[NSArray alloc] initWithObjects:@"fenxiangdian",@"zhuisuidian",@"anquandian",@"putongdian",@"chuxingdian",@"zhaojidian",@"guyongdian",nil];
    
    _btnSelectImages = [[NSArray alloc] initWithObjects:@"fenxiang",@"zhuisui",@"anquan",@"putong",@"chuxing",@"zhaoji",@"guyong",nil];
    
    [self prepareUI];
    [self prepareLefBarBtn:0];
    Manager *manager = [Manager manager];
    manager.mainView = self;
    
    [self customAnnotation];
    
    [self loadOtherUI];
    
    [self customGaode];
    
    [self loadSearchType];
    
    
    _nearByView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 40)];
    
    self.onBtnShare.layer.cornerRadius = 5;
    
    self.onBtnShare.clipsToBounds = YES;
    
    self.onBtnShare.layer.borderWidth = 1;
    
    self.onBtnShare.layer.borderColor = [UIColor orangeColor].CGColor;
    
    _nearByView.userInteractionEnabled = YES;
    
    NSArray *array = @[@"chi",@"zhu",@"xing"];
    NSArray *dianArray = @[@"chidian",@"zhudian",@"xingdian"];
    for (NSInteger i = 0; i < 3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * [UIScreen mainScreen].bounds.size.width / 3 + (([UIScreen mainScreen].bounds.size.width / 3 )/ 2 - 20 ), 10, 40, 40);
        //[btn setTitle:array[i] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageNamed:dianArray[i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateSelected];
        
        //[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(onBtnNearClick:) forControlEvents:UIControlEventTouchUpInside];
        [_nearByView addSubview:btn];
        
    }
    if (!_trafficView) {
        _trafficView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_HEIGHT, 40)];
    }
    
    _trafficView.userInteractionEnabled = YES;
    //NSArray *trafficArray = @[@"buxing",@"jiache",@"gongjiao"];
    NSArray *trafficArray = @[@"jiache",@"buxing",@"gongjiao"];
    NSArray *trafficArrayDian = @[@"buxingdian",@"jiachehui",@"gongjiaodian"];
    //清理一下
    for (UIButton *btn in _trafficView.subviews) {
        [btn removeFromSuperview];
    }

    for (NSInteger i = 0; i < 3; i++) {
        
        UIButton *trafficBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        trafficBtn.frame = CGRectMake(i * SCREEN_WIDTH / 3 + ((SCREEN_WIDTH / 3) / 2 - 20), 10, 40, 40);
        
        [trafficBtn setBackgroundImage:[UIImage imageNamed:trafficArray[i]] forState:UIControlStateNormal];
        //[trafficBtn setBackgroundImage:[UIImage imageNamed:trafficArray[i]] forState:UIControlStateSelected];
        
        trafficBtn.tag = 200 + i;
        [trafficBtn addTarget:self action:@selector(onBtnTrafficClick:) forControlEvents:UIControlEventTouchUpInside];
        [_trafficView addSubview:trafficBtn];
    }
    
    [self initNaviManager];
    
    [self initIFlySpeech];
    
    
    NSUserDefaults *usdf = [NSUserDefaults standardUserDefaults];
    
    if (![usdf objectForKey:@"info"]) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
        Manager *mag = [Manager manager];
        [mag.mainView.navigationController pushViewController:loginVC animated:YES];
#pragma mark ----没有登录,第一次使用也会在这里触发
        NSDictionary *firstUser = [usdf objectForKey:@"firstUser"];
        if (firstUser) {
            
        }else
        {
            
            if (firstUser) {
                DbgLog(@"111");
            }else
            {
                [self loadNewUserView];
                firstUser =  @{@"New":@"NO"};
                [usdf setValue:firstUser forKey:@"firstUser"];
                [usdf synchronize];
            }
        }
    }
    
}
-(void)CountOfJingXI
{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *udic = [usf objectForKey:@"info"];
    //如果没有这个东西的话，默认为10
    if (![usf objectForKey:@"jingxiCount"]) {
        [usf setValue:@"10" forKey:@"jingxiCount"];
    }
    
    AFHTTPRequestOperationManager *MuAdmanager = [AFHTTPRequestOperationManager manager];
    MuAdmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    MuAdmanager.requestSerializer.timeoutInterval = 20.0;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/gif/getGifCount"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:udic[@"token"] forKey:@"token"];
    
    [MuAdmanager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        if ([rspDic[@"code"] integerValue] == 201) {//返回的次数
            DbgLog(@"%@",rspDic[@"date"]);
            [usf removeObjectForKey:@"jingxiCount"];
            [usf setValue:[NSString stringWithFormat:@"%@",rspDic[@"date"]] forKey:@"jingxiCount"];
            [usf synchronize];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
        
    }];

}
-(void)showAD
{
    NSUserDefaults *maUseDef = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *MuAdmanager = [AFHTTPRequestOperationManager manager];
    MuAdmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    MuAdmanager.requestSerializer.timeoutInterval = 20.0;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/admin/icon/get"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:@"applauncher" forKey:@"iconId"];
    
    [MuAdmanager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        if ([rspDic[@"code"] integerValue] == 201) {
            DbgLog(@"修改成功 %@  date:%@",rspDic,rspDic[@"data"]);
            NSDictionary *lanDic = @{@"lanchImg":rspDic[@"data"]};
            [maUseDef setValue:lanDic forKey:@"lanch"];
            [maUseDef synchronize];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
        
    }];
    
    NSDictionary *lanch = [maUseDef objectForKey:@"lanch"];
    if (lanch) {
        NSString *lanchImg = lanch[@"lanchImg"];
        _flashView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _flashView.backgroundColor = [UIColor whiteColor];
        [_flashView sd_setImageWithURL:[NSURL URLWithString:lanchImg] placeholderImage:[UIImage imageNamed:@"lanchImg"]];
        
        UIWindow *wd = [[[UIApplication sharedApplication]windows]lastObject];
        [wd addSubview:_flashView];
        [self performSelector:@selector(removeFlashVIew) withObject:nil afterDelay:5.0f];
    }
    
    
}

#pragma mark ---引导页
-(void)loadNewUserView
{
    scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    for (int i = 0; i< 4; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        NSString *imgName = [NSString stringWithFormat:@"newUseLoad%d",i+1];
        [imgView setImage:[UIImage imageNamed:imgName]];
        imgView.userInteractionEnabled = YES;
        [scrView addSubview:imgView];
        if (i==3) {
            UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            okBtn.frame = CGRectMake(50, imgView.frame.size.height-60, SCREEN_WIDTH - 100, 60);
            //            okBtn.tintColor = [UIColor blackColor];
            //            [okBtn setTitle:@"现在开始" forState:UIControlStateNormal];
            //            [okBtn setBackgroundColor:[UIColor blackColor]];
            [okBtn addTarget:self action:@selector(onOkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:okBtn];
        }
    }
    scrView.contentSize = CGSizeMake(4*SCREEN_WIDTH, SCREEN_HEIGHT);
    scrView.backgroundColor = [UIColor whiteColor];
    scrView.bounces = NO;
    scrView.showsHorizontalScrollIndicator = NO;
    scrView.showsVerticalScrollIndicator = NO;
    scrView.contentOffset = CGPointMake(0, 0);
    scrView.pagingEnabled = YES;
    
    UIWindow *wd = [[[UIApplication sharedApplication]windows]lastObject];
    [wd addSubview:scrView];
}
-(void)onOkBtnClick:(UIButton *)sender
{
    DbgLog(@"!!!!!!!!!!!");
    for (UIView *view in scrView.subviews) {
        [view removeFromSuperview];
    }
    [scrView removeFromSuperview];
    
}

-(void)removeFlashVIew
{
    
    [_flashView removeFromSuperview];
    
}
#pragma  mark 😄😄😄初始化一次的大头针
- (void)customAnnotation
{
    
    _safeDestinationPin = [[MAPointAnnotation alloc] init];
    
}


- (void)initNaviManager
{
    _mapViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    if (self.naviManager == nil)
    {
        _naviManager = [[AMapNaviManager alloc] init];
    }
    
    self.naviManager.delegate = self;
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
//    if(sender.state == UIGestureRecognizerStateEnded)
//    {
    
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];
        
        _safeDestinationPin.coordinate = coordinate;
        
        _safeDestinationPin.title = @"目的地";
        
        [_mapView selectAnnotation:_safeDestinationPin animated:YES];
    
        _currentCount = 0;
    
        _currentDistanceAnnotation = 99;
    
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        
        request.searchType = AMapSearchType_ReGeocode;
        request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        request.requireExtension = YES;
        request.radius = 500;
        
        [_searchAPI AMapReGoecodeSearch:request];
    
        
    [_mapView addAnnotation:_safeDestinationPin];
//    [_mapView removeAnnotations:_currentSafePoliceAndHospital];
    
    
        
        _aimlatitude = coordinate.latitude;
        
        _aimlongitude = coordinate.longitude;
    
   
    
    //CLLocationCoordinate2D;
    
   
        
        [self onBtnChooseTraffic:0];
    
    [_mapView removeGestureRecognizer:_mapViewTapGesture];
    
        
//    }
    
}


- (void)initIFlySpeech
{
    if (self.iFlySpeechSynthesizer == nil)
    {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
}

- (void)clearMapView
{
    _mapView.showsUserLocation = NO;
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    [_mapView removeOverlays:_mapView.overlays];
    
    _mapView.delegate = nil;
    
}

- (void)onCompleted:(IFlySpeechError *)error
{
    
    DbgLog(@"Speak Error:{%d:%@}", error.errorCode, error.errorDesc);
    
}

- (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    
    DbgLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    if (soundStringType == AMapNaviSoundTypePassedReminder)
    {
        //用系统自带的声音做简单例子，播放其他提示音需要另外配置
        AudioServicesPlaySystemSound(1009);
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [_iFlySpeechSynthesizer startSpeaking:soundString];
        });
    }
}

- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error
{
    DbgLog(@"onCalculateRouteFailure");
    
    [self.view makeToast:@"算路失败"
                duration:2.0
                position:[NSValue valueWithCGPoint:CGPointMake(160, 240)]];
}

- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    
    AppDelegate *appdelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appdelegate.timer setFireDate:[NSDate distantFuture]];
    
    _naviViewController = [[AMapNaviViewController alloc] initWithMapView:_mapView delegate:self];
    
    _naviViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
    
    //[self.navigationController pushViewController:self.navigationController animated:YES];
    
}

- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    DbgLog(@"停止导航－－－－－－－－>>>>>>>");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.iFlySpeechSynthesizer stopSpeaking];
    });
    
    [self.naviManager stopNavi];
    [self.naviManager dismissNaviViewControllerAnimated:YES];
    
}

-(void)prepareLefBarBtn:(int)type
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0, 30, 30);
    }

    if (type == 0) {
        [_leftBtn setImage:[UIImage imageNamed:@"gerenwu"] forState:UIControlStateNormal];
    }else
    {
        [_leftBtn setImage:[UIImage imageNamed:@"geren"] forState:UIControlStateNormal];
        [self.delegate reloadMenuDataAndViewVC:type];
        DbgLog(@"a");
    }
    [_leftBtn addTarget:self action:@selector(onLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftBtn];
    
}
- (void)refreshNewNavi
{
    [self.naviManager stopNavi];
    [self.naviManager dismissNaviViewControllerAnimated:YES];

}

- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    
    [self.naviManager startGPSNavi];
}

#pragma mark - 😢😢😢😢导航后添加的指针
- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController
{
    DbgLog(@"导航结束－－－－－－－>>>>>");
    
    
    [self customFriendAnnotationWithCoordinate:CLLocationCoordinate2DMake(0, 0)];
    
    [_mapView setFrame:self.view.frame];
        
    _mapView.delegate = self;
    
    _mapView.userLocation.title = @"当前位置";
    
    _mapView.rotateCameraEnabled = NO;
    
    _mapView.showsUserLocation = YES;
    
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    
    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    
    [self.view addSubview:_mapView];
    
    [self.view sendSubviewToBack:_mapView];
    
    
    CLLocationCoordinate2D coordinateShare = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
    MACoordinateSpan spanShare = MACoordinateSpanMake(0.008, 0.008);
    MACoordinateRegion reginShare = MACoordinateRegionMake(_mapView.userLocation.coordinate, spanShare);
    [_mapView setRegion:reginShare animated:YES];
    
    if (newPin11) {
        [_mapView removeAnnotation:newPin11];
    }
    
    if (!newPin11) {
        newPin11 = [[MAPointAnnotation alloc] init];
    }
    newPin11.coordinate = coordinateShare;
    newPin11.title = @"当前位置";
    [_mapView removeAnnotation:newPin11];
    [_mapView addAnnotation:newPin11];
    
}

- (void)onBtnTrafficClick:(UIButton *)sender
{
    
    self.searchType = [self searchTypeForSelectedIndex:sender.tag - 200];
    self.route = nil;
    self.totalCourse = 0;
    self.currentCourse = 0;
    
    [self updateCourseUI];
    
    [self clear];
    
    /* 发起导航搜索请求. */
    [self SearchNaviWithType:self.searchType];
    
    
}

- (void)onBtnChooseTraffic:(NSInteger)currentTraffic
{
    self.searchType = [self searchTypeForSelectedIndex:currentTraffic];
    self.route = nil;
    self.totalCourse = 0;
    self.currentCourse = 0;
    
    [self updateCourseUI];
    
    [self clear];
    
    /* 发起导航搜索请求. */
    [self SearchNaviWithType:self.searchType];

}

- (void)loadSearchType
{
    _serchTypeSegCtl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"驾车",@"步行",@"公交",nil]];
    
    [_serchTypeSegCtl addTarget:self action:@selector(searchTypeAction:) forControlEvents:UIControlEventValueChanged];
    
    _serchTypeSegCtl.frame = CGRectMake(self.bottomBkView.frame.origin.x, [UIScreen mainScreen].bounds.size.height - self.bottomBkView.frame.size.height - 30, 200, 30);
    
}

- (void)searchTypeAction:(UISegmentedControl *)segmentedControl
{
    
    self.searchType = [self searchTypeForSelectedIndex:segmentedControl.selectedSegmentIndex];
    self.route = nil;
    self.totalCourse = 0;
    self.currentCourse = 0;
    
    [self updateCourseUI];
    
    [self clear];
    
    /* 发起导航搜索请求. */
    [self SearchNaviWithType:self.searchType];
    
}

- (AMapSearchType)searchTypeForSelectedIndex:(NSInteger)selectedIndex
{
    AMapSearchType searchType = 0;
    
    switch (selectedIndex)
    {
        case 0: searchType = AMapSearchType_NaviDrive;   break;
        case 1: searchType = AMapSearchType_NaviWalking; break;
        case 2: searchType = AMapSearchType_NaviBus;     break;
        default:NSAssert(NO, @"%s: selectedindex = %ld is invalid for Navigation", __func__, (long)selectedIndex); break;
    }
    return searchType;
}

- (void)updateCourseUI
{
    /* 上一个. */
    self.previousItem.enabled = (self.currentCourse > 0);
    
    /* 下一个. */
    self.nextItem.enabled = (self.currentCourse < self.totalCourse - 1);
}

- (void)clear
{
    if (_mapView == nil)
    {
        return;
    }
    
    if ([self.naviRoute.routePolylines count] > 0)
    {
        [_mapView removeOverlays:self.naviRoute.routePolylines];
    }
    
    if (self.naviRoute.anntationVisible && [self.naviRoute.naviAnnotations count] > 0)
    {
        [_mapView removeAnnotations:self.naviRoute.naviAnnotations];
    }
    
    //_mapView = nil;
    
}

/* 根据searchType来执行响应的导航搜索*/
- (void)SearchNaviWithType:(AMapSearchType)searchType
{
    switch (searchType)
    {
        case AMapSearchType_NaviDrive:
        {
            [self searchNaviDrive];
            
            break;
        }
        case AMapSearchType_NaviWalking:
        {
            [self searchNaviWalk];
            
            break;
        }
        default:AMapSearchType_NaviBus:
        {
            [self searchNaviBus];
            
            break;
        }
    }
}

/* 公交导航搜索. */
- (void)searchNaviBus
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviBus;
    navi.requireExtension = YES;
    navi.city             = @"beijing";
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude
                                           longitude:_mapView.userLocation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:_aimlatitude
                                                longitude:_aimlongitude];
    
    [_searchAPI AMapNavigationSearch:navi];
}

/* 步行导航搜索. */
- (void)searchNaviWalk
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviWalking;
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude
                                           longitude:_mapView.userLocation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:_aimlatitude
                                                longitude:_aimlongitude];
    
    [_searchAPI AMapNavigationSearch:navi];
}

/* 驾车导航搜索. */
- (void)searchNaviDrive
{
    DbgLog(@"驾车行驶");
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviDrive;
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude
                                           longitude:_mapView.userLocation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:_aimlatitude
                                                longitude:_aimlongitude];
    
    [_searchAPI AMapNavigationSearch:navi];
}

/* 导航搜索回调. */
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request
                      response:(AMapNavigationSearchResponse *)response
{
    if (self.searchType != request.searchType)
    {
        return;
    }
    
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    
    [self updateCourseUI];
    //[self updateDetailUI];
    
    [self presentCurrentCourse];
}

- (void)updateTotal
{
    NSUInteger total = 0;
    
    if (self.route != nil)
    {
        switch (self.searchType)
        {
            case AMapSearchType_NaviDrive   :
            case AMapSearchType_NaviWalking : total = self.route.paths.count;    break;
            case AMapSearchType_NaviBus     : total = self.route.transits.count; break;
            default: total = 0; break;
        }
    }
    
    self.totalCourse = total;
}

- (void)presentCurrentCourse
{
    /* 公交导航. */
    if (self.searchType == AMapSearchType_NaviBus)
    {
        self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentCourse]];
    }
    /* 步行，驾车导航. */
    else
    {
        MANaviAnnotationType type = self.searchType == AMapSearchType_NaviDrive? MANaviAnnotationTypeDrive : MANaviAnnotationTypeWalking;
        self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type];
    }
    
    //    [self.naviRoute setNaviAnnotationVisibility:NO];
    
    [self.naviRoute addToMapView:_mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    if(self.naviRoute.routePolylines.count > 0)
    {
        [_mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines] animated:YES];
    }else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"两地相距太近，请选择步行或驾车"
                                                     delegate:self
                                            cancelButtonTitle:@"好"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
    if(_currentModel3 == 2)
    {
        _currentModel3 = 0;
    }else
    {
    
        if(_currentTag == 102)
        {
            if(_safeStr)
            {
            
                _safeAlertView = [[UIAlertView alloc] initWithTitle:@"是否进入安全模式" message:[NSString stringWithFormat:@"目的地:%@",_safeStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
                [_safeAlertView show];
                
            }else
            {
                
                _safeAlertView = [[UIAlertView alloc] initWithTitle:@"是否进入安全模式" message:[NSString stringWithFormat:@"目的地:正在为你努力获取……"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
                [_safeAlertView show];
            }
            
            
        }
    }
    
}


#pragma mark 😄😄😄😄😄😄😄😄😄😄😄😄😄😄
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(_safeAlertView == alertView)
    {
        
        if(buttonIndex == 0)
        {
            [self clear];
            
            [_mapView removeAnnotation:_safeDestinationPin];
            [_mapView removeAnnotations:_currentSafePoliceAndHospital];
            //[self showHint:@"取消了" yOffset:-150];
            
          
            
            [_mapView addGestureRecognizer:_mapViewTapGesture];
            
        }else if (buttonIndex == 1)
        {
#pragma mark 进进进进进进进进进进进进进进进进进进进进进进进进进进进进入安全模式
            [_mapView removeGestureRecognizer:_mapViewTapGesture];
            
            
            NSDictionary *aimCoordinate = @{@"latitude":[NSString stringWithFormat:@"%f",_aimlatitude],@"longitude":[NSString stringWithFormat:@"%f",_aimlongitude]};
            
             NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef setObject:aimCoordinate forKey:@"aim"];
            
            [userDef synchronize];
            
            Manager *manager = [Manager manager];
            [_mapView addAnnotations:_currentSafePoliceAndHospital];
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude,_mapView.userLocation.coordinate.longitude));
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(_aimlatitude,_aimlongitude));
            //2.计算距离
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            
            NSString *distanceTime = [NSString stringWithFormat:@"%.0f",(distance / 60)];
            
            [self changeMySafeModel:@"in" andStart:[NSString stringWithFormat:@"[%f,%f]",_mapView.userLocation.coordinate.longitude,_mapView.userLocation.coordinate.latitude] andEnd:[NSString stringWithFormat:@"[%f,%f]",_aimlongitude,_aimlatitude] andDuration:distanceTime];
            
            [self.view addSubview:_safeView];
            
            [self.onBtnShare setTitle:@"退出安全模式" forState:UIControlStateNormal];
            
            _safeState = 100;
            
            _alertView = [[UIAlertView alloc] initWithTitle:@"是否进入导航"
                                                    message:[NSString stringWithFormat:@"如果不进入导航，将无法监测到路线偏移"]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
            [_alertView show];

        }
    }else if(_alertView == alertView)
    {
        
        if(buttonIndex == 1)
        {
            [self refreshNewNavi];
            if (self.endAnnotation)
            {
                self.endAnnotation.coordinate = CLLocationCoordinate2DMake(_aimlatitude, _aimlongitude);
            }
            else
            {
                self.endAnnotation = [[NavPointAnnotation alloc] init];
                [self.endAnnotation setCoordinate:CLLocationCoordinate2DMake(_aimlatitude, _aimlongitude)];
                self.endAnnotation.title        = @"终 点";
                self.endAnnotation.navPointType = NavPointAnnotationEnd;
                //[self.mapView addAnnotation:self.endAnnotation];
            }
            
            [self.naviManager calculateDriveRouteWithEndPoints:@[[AMapNaviPoint locationWithLatitude:_aimlatitude    longitude:_aimlongitude]]
                                                                 wayPoints:nil
                                                           drivingStrategy:AMapNaviDrivingStrategyShortDistance];
            
        }else if (buttonIndex == 0) //在此添加安全路线长时间停留监测问题
        {
            
            
            
        }
        
        
    }else if (alertView.tag == 562)
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

    }else if (alertView.tag == 45)//是否允许安顿使用位置
    {
        if (buttonIndex == 1) {
            [self didSelectAllowLocation];
        }else if (buttonIndex == 0){
            [self showHint:@"若要使用定位服务，请退出重新打开。" yOffset:-100];
        }
    }
    
}
#pragma mark 🎈－🔌 安全模式状态的改变

//model:in  out
//safeduration 路线时长
//NSString *safeStart = [NSString stringWithFormat:@"[%@,%@]",a,b];a和b是经纬度
-(void)changeMySafeModel:(NSString *)model andStart:(NSString *)safeStart andEnd:(NSString *)safeend andDuration:(NSString *)safeduration
{
    DbgLog(@"要改变的模式是：%@",model);
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/model/inout"];

    if ([model isEqualToString:@"in"]) {//进入安全模式
        [self RecoFoot:@"2"];
        NSDictionary *param = @{@"token":userDic[@"token"],@"model":@"0",@"type":model,@"start":safeStart,@"end":safeend,@"duration":safeduration};
        [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
            DbgLog(@"修改成功 %@  date:%@",rspDic,rspDic[@"data"]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DbgLog(@"failure :%@",error.localizedDescription);
            [self showHint:@"设置失败，稍后再试" yOffset:-10];
        }];
        
    }else if ([model isEqualToString:@"out"]){//退出安全模式
        [self RecoFoot:@"3"];
        NSDictionary *param = @{@"token":userDic[@"token"],@"model":@"0",@"type":model};
        [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
            DbgLog(@"修改成功 %@  date:%@",rspDic,rspDic[@"data"]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DbgLog(@"failure :%@",error.localizedDescription);
            [self showHint:@"设置失败，稍后再试" yOffset:-10];
        }];
    }
   
}
-(void)RecoFoot:(NSString *)safeModel
{
    //    10,更新用户模式
    //    接口地址：/login/uUmodel
    //    token 用户token
    //    model 用户所在模式 2安全模式
    //
    //    返回值
    //    code 201
    //    data 用户信息
    //
    //    code 102
    //    msg  用户token不存在
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/uUmodel"];
    NSDictionary *param = @{@"token":userDic[@"token"],@"model":safeModel};
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        
        DbgLog(@"返回数据: %@  date:%@",rspDic,rspDic[@"data"]);
        if ([rspDic[@"code"] integerValue] == 201) {
            DbgLog(@"sucess = %@",rspDic[@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
        [self showHint:@"设置失败，稍后再试" yOffset:-10];
    }];
    
}
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    DbgLog(@"112233");
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineView.lineWidth   = 3;
        polylineView.strokeColor = [UIColor magentaColor];
        polylineView.lineDash = YES;
        //polylineView.lineDash = YES;
        
        return polylineView;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineView.lineWidth = 3;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineView.strokeColor = self.naviRoute.walkingColor;
        }
        else
        {
            
            //polylineView.strokeColor = self.naviRoute.routeColor;
            polylineView.strokeColor = [UIColor greenColor];
        }
        polylineView.lineDash = YES;
        return polylineView;
    }else if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 5.0f;
        polylineView.strokeColor = [UIColor redColor];
        
        return polylineView;
    }
    
    //    if (overlay == mapView.userLocationAccuracyCircle)
    //    {
    //        MACircleView *accuracyCircleView = [[MACircleView alloc] initWithCircle:overlay];
    //
    //        accuracyCircleView.lineWidth    = 2.f;
    //        accuracyCircleView.strokeColor  = [UIColor lightGrayColor];
    //        accuracyCircleView.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
    //
    //        return accuracyCircleView;
    //    }
    
    return nil;
}


#pragma mark 出行点击的三个按钮
- (void)onBtnNearClick:(UIButton *)sender
{
    
    _allTravelImages = sender.tag - 100;
    //_travelBtn.selected = NO;
    //sender.selected = YES;
    //_travelBtn = sender;
    
    DbgLog(@"nearBtn:%d",sender.tag);
    
    //    [_mapView removeAnnotations:_pins];
    //    [_pins removeAllObjects];
    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    request.location = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude];
    request.radius = 8000;
    request.requireExtension = YES;
    
    if(sender.tag == 100)
    {
        if(_travelEat == 0)
        {
            sender.selected = YES;
            _travelEat = 1;
            request.types = @[@"050100"];
            
        }else if (_travelEat == 1)
        {
            
            sender.selected = NO;
            _travelEat = 0;
            [_mapView removeAnnotations:_eatArray];
            [_pins removeObjectsInArray:_eatArray];
            return;
        }
        
        
    }else if (sender.tag == 101)
    {
        if(_travelLive == 0)
        {
            
            sender.selected = YES;
            request.types = @[@"100100"];
            _travelLive = 1;
            
        }else if (_travelLive == 1)
        {
            
            sender.selected = NO;
            _travelLive = 0;
            [_mapView removeAnnotations:_liveArray];
            [_pins removeObjectsInArray:_liveArray];
            return;
            
        }
        
    }else if (sender.tag == 102)
    {
        if(_travelTour == 0)
        {
            sender.selected = YES;
            request.types = @[@"150500",@"150700",@"010100"];
            _travelTour = 1;
        }else if (_travelTour == 1)
        {
            sender.selected = NO;
            _travelTour = 0;
            [_mapView removeAnnotations:_tourArray];
            [_pins removeObjectsInArray:_tourArray];
            
            return;
        }
    }
    
    [_searchAPI AMapPlaceSearch:request];
}

#pragma mark 加载friendView
-(void)loadOtherUI
{
    
//    for (NSInteger i = 0; i < _friendsLocationArray.count; i++) {
//        
//        NSDictionary *dic = _friendsLocationArray[i];
//        
//        CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
//        
//        AnimatedAnnotation * friendAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate2];
//        NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
//        for (NSInteger i = 1; i < 4; i++) {
//            NSString *imageName = [NSString stringWithFormat:@"%ld%ld%ld.png",(long)i,(long)i,(long)i];
//            CGSize size = CGSizeMake(240, 240);
//            UIImage *image1 = [UIImage imageNamed:imageName];
//            UIImage *image22 = [UIImage imageNamed:@"HeadImage1.png"];
//            UIImage *image2 = [self circleImage:image22 withParam:0];
//            UIGraphicsBeginImageContext(size);
//            [image2 drawInRect:CGRectMake(54, 15, 110, 110)];
//            [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
//            UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//            [trainImages1 addObject:resultingImage];
//        }
//        friendAnnotation.animatedImages = trainImages1;
//        friendAnnotation.userId = dic[@"userId"];
//        [_friendsAnnotations addObject:friendAnnotation];
//    }
//    [self.mapView addAnnotations:_friendsAnnotations];
    
    
    DbgLog(@"annotations   %@",self.mapView.annotations);
    for (NSObject *annotation in self.mapView.annotations) {
        if([annotation isKindOfClass:[AnimatedAnnotation class]])
        {
            AnimatedAnnotation *annotation1 = (AnimatedAnnotation *)annotation;
            if([annotation1.userId isEqualToString:@"333"])
            {
                annotation1.coordinate = CLLocationCoordinate2DMake(annotation1.coordinate.latitude + 0.003, annotation1.coordinate.longitude);
            }
        }
    }
    
    
    
    _safeState = 101;
    if (!_currentSafePoliceAndHospital) {
        _currentSafePoliceAndHospital = [[NSMutableArray alloc] init];
    }
    if (!_safeView) {
        _safeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 210, 64, 200, 40)];

    }
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    lable.text = @"安全模式";
    lable.textColor = [UIColor redColor];
    lable.font = [UIFont boldSystemFontOfSize:14];
    lable.textAlignment = NSTextAlignmentRight;
    [_safeView addSubview:lable];
//    [self.view addSubview:_safeView];
    
    _DongTaiView = [[[NSBundle mainBundle]loadNibNamed:@"DongTaiView" owner:self options:nil]lastObject ];
    _DongTaiView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    DbgLog(@"%@",NSStringFromCGRect(_DongTaiView.frame));
    DbgLog(@"%@",NSStringFromCGRect(_DongTaiView.photosView.frame))
    
    _friendList = [[NSMutableArray alloc] init];
    
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(sender.frame.origin.x, [UIScreen mainScreen].bounds.size.height - sender.frame.size.height - 3 * 45 - 5, 35, 45 * 3)];
    _friendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 45 * 3)];
    
    _friendView.backgroundColor = [UIColor clearColor];
    
    //    for (NSInteger i = 0; i < 3; i++) {
    //
    //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //
    //        btn.backgroundColor = [UIColor clearColor];
    //
    //        btn.frame = CGRectMake(0, i * 45, 35, 35);
    //
    //        btn.layer.cornerRadius = btn.frame.size.width / 2;
    //
    //        btn.clipsToBounds = YES;
    //
    //        [btn addTarget:self action:@selector(onFriendAnotation:) forControlEvents:UIControlEventTouchUpInside];
    //
    //        NSString *imageName = [NSString stringWithFormat:@"p_%d.png",i + 10];
    //
    //        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //
    //        [_friendView addSubview:btn];
    //
    //    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor = [UIColor clearColor];
    
    btn.frame = CGRectMake(0, 0, 35, 35);
    
    btn.layer.cornerRadius = btn.frame.size.width / 2;
    
    btn.clipsToBounds = YES;
    
    btn.tag = 100;
    
    [btn addTarget:self action:@selector(onFriendAnotation:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"chatBar_more.png"] forState:UIControlStateNormal];
    
    [_friendView addSubview:btn];
    
    
    _hireView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 40)];
    
    NSArray *hireImage = @[@"11jiedanhui",@"11guyonghui"];
    
    NSArray *hireSelectImage = @[@"11jiedan",@"11guyong"];
    
    for (NSInteger i = 0; i < 2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * [UIScreen mainScreen].bounds.size.width / 2 + (([UIScreen mainScreen].bounds.size.width / 2 )/ 2 - 20 ), 10, 40, 40);
        btn.tag = 300 + i;
        
        
        [btn setImage:[UIImage imageNamed:hireImage[i]] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:hireSelectImage[i]] forState:UIControlStateSelected];
        
        
        NSUserDefaults *usDf = [NSUserDefaults standardUserDefaults];
        NSDictionary *usDic = [usDf objectForKey:@"info"];
        if (i==0) {//接单按钮
            if ([usDic[@"ustatus"] isEqualToString:@"2"]&&[usDic[@"uapply"] isEqualToString:@"1"]) {//可雇佣
                btn.selected = YES;
            }else
            {
                btn.selected = NO;
            }
        }
        
        [btn addTarget:self action:@selector(onBtnHireClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_hireView addSubview:btn];
    }
    
}

#pragma mark 🔌---雇佣的两个按钮点击事件
- (void)onBtnHireClick:(UIButton *)sender
{
    
    NSUserDefaults *usDf = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *usDic = [NSMutableDictionary dictionaryWithDictionary:[usDf objectForKey:@"info"]];
    NSString *trueName = usDic[@"uidcard"];
    NSString *uapply = usDic[@"uapply"];
    NSString *ustatus = usDic[@"ustatus"];
    
    if(sender.tag == 301)
    {
        DbgLog(@"currentTag  --- >>>>>> %d",_currentTag);
        
        if (trueName.length != 18) {//没有实名认证
            [self showHint:@"请先实名认证!" yOffset:-100];
            RealNameViewController *rlVC = [[RealNameViewController alloc]initWithNibName:@"RealNameViewController" bundle:nil];
            [self.navigationController pushViewController:rlVC animated:YES];
            
            return;
        }

        UIView *gyView = [[UIView alloc]initWithFrame:self.view.frame];
        gyView.tag = 88;
        //gyView.backgroundColor = [UIColor yellowColor];
        
        UITapGestureRecognizer *tapGvc = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGvc:)];
        [gyView addGestureRecognizer:tapGvc];
        
        _gyV = [[[NSBundle mainBundle]loadNibNamed:@"GySendView" owner:self options:nil]lastObject];
        _gyV.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
        
        //        弹出的发送雇用的视图的子视图在GySendView.h文件里，根据这些进行订制
        //        @property (weak, nonatomic) IBOutlet UITextView *contentTextView;
        //        @property (weak, nonatomic) IBOutlet UIView *qishidiView;
        //        @property (weak, nonatomic) IBOutlet UILabel *qishidiLabel;
        //        @property (weak, nonatomic) IBOutlet UIView *midiView;
        //        @property (weak, nonatomic) IBOutlet UILabel *modiLabel;
        //        @property (weak, nonatomic) IBOutlet UIView *xingbieView;
        //
        //        @property (weak, nonatomic) IBOutlet UIView *jineView;
        //        @property (weak, nonatomic) IBOutlet UITextField *jineTextField;
        //        @property (weak, nonatomic) IBOutlet UIView *yajinView;
        _gyV.contentTextView.delegate = self;
        _gyV.xingbieView.tag = GYVTAG;
        [self addTapGuOnView:_gyV.xingbieView];
        _gyV.jineView.tag = GYVTAG +1;
        [self addTapGuOnView:_gyV.jineView];
        _gyV.yajinView.tag = GYVTAG +2;
        _gyV.jineTextField.delegate = self;
        [self addTapGuOnView:_gyV.yajinView];

        [_gyV.quedingBtn addTarget:self action:@selector(onGuyongSendClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [gyView addSubview:_gyV];
        [self.view addSubview:gyView];
        [self.view bringSubviewToFront:gyView];

    }else if (sender.tag == 300)
    {
        if ([uapply isEqualToString:@"0"]) {//不可接单
            [self showHint:@"请先在雇员招募里申请报名！" yOffset:-100];
            GYZMViewController *gyVC = [[GYZMViewController alloc]initWithNibName:@"GYZMViewController" bundle:nil];
            [self.navigationController pushViewController:gyVC animated:YES];
            return;
        }
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        
        [MBProgressHUD showHUDAddedTo:window animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setValue:usDic[@"token"] forKey:@"token"];
        
        if ([ustatus isEqualToString:@"2"]) {//现在是可被雇用的
            [param setValue:@"2" forKey:@"hireable"];
        }else//现在是不可雇佣的
        {
            [param setValue:@"3" forKey:@"hireable"];
        }
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/hire/hireable"];
                
        [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            DbgLog(@"ssss%s",[responseObject bytes]);
            [MBProgressHUD hideHUDForView:window animated:YES];
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
            DbgLog(@"%@",rspDic[@"data"]);
            if ([rspDic[@"code"] integerValue ] == 200) {
                if (sender.selected == YES) {//如果处于开启状态，则变为不可被雇佣
                    sender.selected = NO;
                    [usDic setValue:@"1" forKey:@"ustatus"];
                }else{
                    sender.selected = YES;
                    [usDic setValue:@"2" forKey:@"ustatus"];
                }
                [usDf setValue:usDic forKey:@"info"];
                [usDf synchronize];
            }
 
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            DbgLog(@"failure :%@",error.localizedDescription);
        }];
        
    }
}

#pragma mark   😄😄添加好友的大头针
- (void)onFriendAnotation:(UIButton *)sender
{
    if(_currentTag == 103)
    {
    
        if(sender.tag == 100)
        {
#pragma mark ---🎈电影
//            UrgentFriendViewController *UrVC = [[UrgentFriendViewController alloc] init];
//            
//            UrVC.delegate = self;
//            
//            UrVC.currentType = 108;
//            
//            [self.navigationController pushViewController:UrVC animated:YES];
            TBGZTableViewController *tgVC = [[TBGZTableViewController alloc]init];
            [self.navigationController pushViewController:tgVC animated:YES];
            
            
            [_friendView removeFromSuperview];
            
        }else
        {
#pragma mark ---点击特别关心的好友头像
            FriendList *friendModel = _friendList[sender.tag - 101];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/mongo/findByUnames"];
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSDictionary *UserDic = [userDef objectForKey:@"info"];
            NSDictionary *param = @{@"rbid":friendModel.rbid,@"token":UserDic[@"token"]};
            
            [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
                DbgLog(@"好友的坐标－－－－－－－>>>>>>>>》》》》》%@",dic);
                //MAPointAnnotation *friendPin = [[MAPointAnnotation alloc] init];
                
                if(dic[@"data"])
                {
                    
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"data"][0][@"c_ALTIT"] doubleValue], [dic[@"data"][0][@"c_LONGIT"] doubleValue]);
                    
                    //_animatedCar11 = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
                    _animatedCar11.coordinate = coordinate;
                    NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
                    for (NSInteger i = 1; i < 4; i++) {
                        NSString *imageName = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
                        CGSize size = CGSizeMake(240, 240);
                        UIImage *image1 = [UIImage imageNamed:imageName];
                        
                        UIImage *image22;
                        
                        NSString *friendHeadImgstr = [NSString stringWithFormat:@"%@",dic[@"data"][0][@"c_NOTE"]];
                        
                        if(friendHeadImgstr.length > 6)
                        {
                            image22 = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:friendHeadImgstr]]];
                        }else
                        {
                            image22 = [UIImage imageNamed:@"icon_logo"];
                        }
                        
                        UIImage *image2 = [self circleImage:image22 withParam:0];
                        UIGraphicsBeginImageContext(size);
                        [image2 drawInRect:CGRectMake(54, 12, 110, 110)];
                        [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        [trainImages1 addObject:resultingImage];
                    }
                    
                    NSString *codeStr = [NSString stringWithFormat:@"%@",dic[@"code"]];
                    
                    if([codeStr isEqualToString:@"201"])
                    {
                        [self showHint:@"正在获取好友位置...." yOffset:-150];
                    }else if ([codeStr isEqualToString:@"102"])
                    {
                        [self showHint:@"好友设置了隐身，正在获取好友最后位置......" yOffset:-150];
                    }
                    
                    MACoordinateSpan spanShare = MACoordinateSpanMake(0.08, 0.08);
                    MACoordinateRegion reginShare = MACoordinateRegionMake(coordinate, spanShare);
                    [_mapView setRegion:reginShare animated:YES];

                    [_mapView removeAnnotation:_animatedCar11];
                _animatedCar11.longitude = dic[@"data"][0][@"c_LONGIT"];
                _animatedCar11.latitude = dic[@"data"][0][@"c_ALTIT"];
                _animatedCar11.mainUserId = dic[@"data"][0][@"c_U_ID"];
                
                _animatedCar11.userId = dic[@"data"][0][@"c_U_NICKNAME"];
                _animatedCar11.userLocation = dic[@"data"][0][@"c_PLACE"];
                
                NSString *imageUrl = dic[@"data"][0][@"c_NOTE"];
                if(imageUrl.length > 6)
                {
                    _animatedCar11.headImage = dic[@"data"][0][@"c_NOTE"];
                    _animatedCar11.currentImageType = 1;
                }else
                {
                    _animatedCar11.headImage = @"icon_logo";
                }
                
                    _animatedCar11.animatedImages = trainImages1;
                    
                    [_mapView addAnnotation:_animatedCar11];
                    
                    [_mapView selectAnnotation:_animatedCar11 animated:YES];
                    
                }
                
                //            friendPin.coordinate = coordinate;
                //            DbgLog(@"请求好友坐标成功");
                //            [_mapView addAnnotation:friendPin];
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DbgLog(@"failure :%@",error.localizedDescription);
            }];
            
        }
    }else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请在普通模式下查看好友位置"
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:@"好"
                                            otherButtonTitles:nil, nil];
        [alert show];

    }
    
}

- (void)urgentFriendViewController:(UrgentFriendViewController *)urgentFriendViewController changefriendId:(NSString *)friendId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/mongo/findByUnames"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserDic = [userDef objectForKey:@"info"];
    NSDictionary *param = @{@"rbid":friendId,@"token":UserDic[@"token"]};
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        DbgLog(@"好友的坐标－－－－－－－>>>>>>>>》》》》》%@",dic);
        //MAPointAnnotation *friendPin = [[MAPointAnnotation alloc] init];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"data"][0][@"c_ALTIT"] doubleValue], [dic[@"data"][0][@"c_LONGIT"] doubleValue]);
        
        //_animatedCar11 = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
        _animatedCar11.coordinate = coordinate;
        NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
        for (NSInteger i = 1; i < 4; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
            CGSize size = CGSizeMake(240, 240);
            UIImage *image1 = [UIImage imageNamed:imageName];
            
            UIImage *image22 = [UIImage imageNamed:@"1.jpg"];
            UIImage *image2 = [self circleImage:image22 withParam:0];
            UIGraphicsBeginImageContext(size);
            [image2 drawInRect:CGRectMake(54, 12, 110, 110)];
            [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
            UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
            [trainImages1 addObject:resultingImage];
        }
        
        NSString *codeStr = [NSString stringWithFormat:@"%@",dic[@"code"]];
        if([codeStr isEqualToString:@"201"])
        {
            [self showHint:@"正在获取好友位置...." yOffset:-150];
        }else if ([codeStr isEqualToString:@"102"])
        {
            [self showHint:@"好友设置了隐身，获取好友最后位置......" yOffset:-150];
        }

        
        MACoordinateSpan spanShare = MACoordinateSpanMake(0.08, 0.08);
        MACoordinateRegion reginShare = MACoordinateRegionMake(coordinate, spanShare);
        [_mapView setRegion:reginShare animated:YES];
        
        if(dic[@"data"])
        {
            _animatedCar11.longitude = dic[@"data"][0][@"c_LONGIT"];
            _animatedCar11.latitude = dic[@"data"][0][@"c_ALTIT"];
            _animatedCar11.mainUserId = dic[@"data"][0][@"c_U_ID"];
            
            _animatedCar11.userId = dic[@"data"][0][@"c_U_NICKNAME"];
            _animatedCar11.userLocation = dic[@"data"][0][@"c_PLACE"];
            
            NSString *imageUrl = dic[@"data"][0][@"c_NOTE"];
            if(imageUrl.length > 6)
            {
                _animatedCar11.headImage = dic[@"data"][0][@"c_NOTE"];
                _animatedCar11.currentImageType = 1;
            }else
            {
                _animatedCar11.headImage = @"icon_logo";
            }
            
            _animatedCar11.animatedImages = trainImages1;
            
            [_mapView addAnnotation:_animatedCar11];
            [_mapView selectAnnotation:_animatedCar11 animated:YES];
        }
        
        //            friendPin.coordinate = coordinate;
        //            DbgLog(@"请求好友坐标成功");
        //            [_mapView addAnnotation:friendPin];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
    }];

    
}

- (void)customGaode
{
    [self didSelectAllowLocation];
//    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"是否允许安顿使用您的位置？" message:@"安顿需要使用您的位置，用以在您以及您好友的安顿地图上显示您的位置。若需对某好友禁用位置显示，您可以在好友资料里选择对TA隐身，好友地图上只会显示您最后使用安顿时的位置。" delegate:self cancelButtonTitle:@"不允许" otherButtonTitles:@"允许", nil];
//    alv.tag = 45;
//    [alv show];
}

-(void)didSelectAllowLocation
{
    newPin = [[MAPointAnnotation alloc] init];
    if (!_eatArray) {
        _eatArray = [[NSMutableArray alloc] init];
        
    }
    
    if (!_liveArray) {
        _liveArray = [[NSMutableArray alloc] init];
    }
    
    if (!_tourArray) {
        _tourArray = [[NSMutableArray alloc] init];
    }
    
    
    NSUserDefaults *aimUser = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *aimDic = [aimUser objectForKey:@"aim"];
    
    if(aimDic)
    {
        _aimlatitude = [aimDic[@"latitude"] doubleValue];
        
        _aimlongitude = [aimDic[@"longitude"] doubleValue];
        
        //[_mapView addAnnotation:]
        _safeDestinationPin.coordinate = CLLocationCoordinate2DMake(_aimlatitude, _aimlongitude);
        
        _safeDestinationPin.title = @"目的地";
        
        _safeState = 100;
        
        [self.view addSubview:_safeView];
        
    }
    
    if (!_pins) {
        _pins = [[NSMutableArray alloc] init];
    }
    
    [MAMapServices sharedServices].apiKey = @"4f7adad030250716702a9e9ac3a9901a";
    
    _searchAPI = [[AMapSearchAPI alloc] initWithSearchKey:@"4f7adad030250716702a9e9ac3a9901a" Delegate:self];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    _mapView.delegate = self;
    
    _mapView.userLocation.title = @"当前位置";
    
    _mapView.rotateCameraEnabled = NO;
    
    _mapView.showsUserLocation = YES;
    
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    
    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    
    [self.view addSubview:_mapView];
    
    [self.view sendSubviewToBack:_mapView];
    
    //    _currentView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT - self.bottomBkView.frame.size.height - 100 , 40, 100)];
    //    _currentView.backgroundColor = [UIColor clearColor];
    
    changeTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeTypeBtn.frame = CGRectMake(SCREEN_WIDTH - 40 - 10, SCREEN_HEIGHT - self.bottomBkView.height - 37 - 5, 40, 37);
    changeTypeBtn.tag = 200;
    [changeTypeBtn addTarget:self action:@selector(locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    Y = changeTypeBtn.frame.origin.y;
    
    [changeTypeBtn setBackgroundImage:[UIImage imageNamed:@"ditubianhuan"] forState:UIControlStateNormal];
    [self.view addSubview:changeTypeBtn];
    
    backlocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backlocationBtn.frame = CGRectMake(10, SCREEN_HEIGHT - self.bottomBkView.height - 37 - 5, 40, 37);
    backlocationBtn.tag = 201;
    [backlocationBtn addTarget:self action:@selector(locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backlocationBtn setBackgroundImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    [self.view addSubview:backlocationBtn];
    
    changeAllow = [UIButton buttonWithType:UIButtonTypeCustom];
    changeAllow.frame = CGRectMake(10, SCREEN_HEIGHT - self.bottomBkView.height - 37 - 37 - 5, 40, 37);
    changeAllow.tag = 202;
    [changeAllow addTarget:self action:@selector(changeAllowClick:) forControlEvents:UIControlEventTouchUpInside];
    [changeAllow setBackgroundImage:[UIImage imageNamed:@"weizhibuyunxu"] forState:UIControlStateNormal];
    [changeAllow setBackgroundImage:[UIImage imageNamed:@"weizhiyunxu"] forState:UIControlStateSelected];

    NSString *all = [aimUser objectForKey:@"changeAllow"];
    if ([all isEqualToString:@"NO"]) {
        changeAllow.selected = NO;
    }else
    {
        changeAllow.selected = YES;
    }
    [self.view addSubview:changeAllow];
    
    //[self.view addSubview:_currentView];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDef objectForKey:@"info"];
    
    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
    _animatedCar = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate2];
    if([dic[@"uhimgurl"] length] > 6)
    {
        _animatedCar.currentImageType = 1;
        _animatedCar.headImage = dic[@"uhimgurl"];
    }
    
    NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i < 4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
        CGSize size = CGSizeMake(240, 240);
        UIImage *image1 = [UIImage imageNamed:imageName];
        //UIImage *image22 = [UIImage imageNamed:@"HeadImage1.png"];
        UIImage *image22;
        
        if([dic[@"uhimgurl"] length] > 6)
        {
            image22 = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"uhimgurl"]]]];
            
        }else
        {
            image22 = [UIImage imageNamed:@"icon_logo"];
        }
        
        UIImage *image2 = [self circleImage:image22 withParam:0];
        UIGraphicsBeginImageContext(size);
        [image2 drawInRect:CGRectMake(54, 12, 110, 110)];
        [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        [trainImages1 addObject:resultingImage];
    }
    _animatedCar.animatedImages = trainImages1;
    _animatedCar.title = @"雪岩雪扬";
    if([dic[@"uhimgurl"] length] > 0)
    {
        _animatedCar.userId = dic[@"unickname"];
        _animatedCar.headImage = dic[@"uhimgurl"];
        _animatedCar.userLocation = self.localAddress;
    }

}
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
#pragma mark ---改变是否更新位置

-(void)changeAllowClick:(UIButton *)sender
{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    if (changeAllow.selected == YES) {
        changeAllow.selected = NO;
        [usf setObject:@"NO" forKey:@"changeAllow"];
        [self showHint:@"关闭位置记录！" yOffset:-10];
    }else
    {
        changeAllow.selected = YES;
        [usf setObject:@"YES" forKey:@"changeAllow"];
        [self showHint:@"系统将会实时记录您的位置！" yOffset:-10];
    }
    [usf synchronize];
}
- (void)locationBtnClick:(UIButton *)sender
{
    DbgLog(@"按钮的Tag值------>%ld",(long)sender.tag);
    if(sender.tag == 200 || sender.tag == 301)
    {
        if(sender.tag == 200)
        {
            sender.tag = 301;
            _mapView.mapType = 1;
        }else if (sender.tag == 301)
        {
            sender.tag = 200;
            _mapView.mapType = 0;
        }
    }else if (sender.tag == 201)
    {
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
        MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01);
        MACoordinateRegion regin = MACoordinateRegionMake(coordinate, span);
        [_mapView setRegion:regin];
        
    }
}

#pragma mark 😢😢😢😢😢  😢😢😢😢😢实时定位
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    //DbgLog(@"latitude : %f, longitude : %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
    if(!updatingLocation && self.userLocationAnnotationView != nil)
    {
        _currentCenter = 22;
        //DbgLog(@"latitude : %f, longitude : %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        //DbgLog(@"%lf",MAAreaBetweenCoordinates(CLLocationCoordinate2DMake(39.910788,116.540387 - 10 *0.001), _mapView.userLocation.coordinate));
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        _animatedCar.coordinate = coordinate;
        newPin11.coordinate = coordinate;
        
        [_mapView addAnnotation:_animatedCar];
        _mapView.userLocation.coordinate = coordinate;
        
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading - _mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
        
//        if(_currentLocation == 0)
//        {
//            [self customFriendAnnotationWithCoordinate:coordinate];
//        }
        
        
        if(_currentLocation == 0 || _coordinate.latitude != coordinate.latitude || _coordinate.longitude != coordinate.longitude)
        {
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [userDef objectForKey:@"info"];
            if(dic &&  _currentLocation == 0)
            {
              [self customFriendAnnotationWithCoordinate:coordinate];
            }
            
            _updateLocationCurrent = 10;
            _coordinate = coordinate;
            
            if(_currentTag == 102 || _currentLocation == 0)
            {
                
                [_currentSafePoliceAndHospital removeAllObjects];
                
                AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
                request.searchType = AMapSearchType_PlaceAround;
                request.location = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude];
                request.radius = 8000;
                request.requireExtension = YES;
                _policeArray = @[@"130501"];
                
                request.types = _policeArray;
                
                //_currentPolice = 99;
                
                [_searchAPI AMapPlaceSearch:request];
                
                [self performSelector:@selector(PlaceAroundHospital) withObject:nil afterDelay:3];
                
            }
            _currentLocation = 3;
            self.localCoordinate = coordinate;
            
            AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
            request.searchType = AMapSearchType_ReGeocode;
            request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            request.requireExtension = YES;
            request.radius = 500;
            
            
            [_searchAPI AMapReGoecodeSearch:request];
            
//            if(_currentTag == 102 || _currentLocation == 0)
//            {
//                DbgLog(@"success --------->>>> ");
//                
//                [_currentSafePoliceAndHospital removeAllObjects];
//                
//                AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
//                request.searchType = AMapSearchType_PlaceAround;
//                request.location = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude];
//                request.radius = 8000;
//                request.requireExtension = YES;
//                
//                request.types = @[@"130501"];
//                
//                _currentPolice = 99;
//                
//                [_searchAPI AMapPlaceSearch:request];
//                
//                [self performSelector:@selector(PlaceAroundHospital) withObject:nil afterDelay:3];
//                
//            }
            
        }
    }
}

#pragma mark 😊添加好友的大头针
- (void)customFriendAnnotationWithCoordinate:(CLLocationCoordinate2D )coordinate
{
    [self friendReal];
//    _friendsLocationArray = [[NSMutableArray alloc] init];
//    
//    _friendsAnnotations = [[NSMutableArray alloc] init];
//    
//    _safeStateArray = [[NSMutableArray alloc] init];
//    
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userDic = [userDef objectForKey:@"info"];
//    
//    if (!userDic) {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
//        Manager *mag = [Manager manager];
//        [mag.mainView.navigationController pushViewController:loginVC animated:YES];
//        return;
//    }
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 20.0;
//        NSDictionary *dic = @{@"token":userDic[@"token"],@"longitude":[NSString stringWithFormat:@"%f",_mapView.userLocation.coordinate.longitude],@"altitude":[NSString stringWithFormat:@"%f",_mapView.userLocation.coordinate.latitude]};//参数
//        //NSString *strUrl = @"http://172.16.0.63:8080/zrwt/login/loginUser";//请求网址
//        //NSString *strUrl = @"http://172.16.0.6:8080/zrwt/friend/pos/list";
//        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/pos/list"];
//    DbgLog(@"获取好友列表 －－－－－－－>>>>>>>%@",dic);
//    
//        [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            DbgLog(@"ssss%s",[responseObject bytes]);
//            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
//            
//            DbgLog(@"%@",rspDic[@"data"]);
//            NSString *str = [NSString stringWithFormat:@"%@",rspDic[@"data"]];
//            if(str.length == 6) return ;
//            [_friendsLocationArray removeAllObjects];
//            [_safeStateArray removeAllObjects];
//            for (NSDictionary *friendDic in rspDic[@"data"]) {
//                
//                NSDictionary *addDic = @{@"latitude":friendDic[@"c_ALTIT"],@"longitude":friendDic[@"c_LONGIT"],@"userId":friendDic[@"c_U_NICKNAME"],@"place":friendDic[@"c_PLACE"],@"headImage":friendDic[@"c_NOTE"]};
//                
//                [_friendsLocationArray addObject:addDic];
//                
//                NSString *c_MODEL = [NSString stringWithFormat:@"%@",friendDic[@"c_MODEL"]];
//                
//                if(!(c_MODEL.length == 6))
//                {
//                    
//                    if([friendDic[@"c_MODEL"] isEqualToString:@"2"])
//                    {
//                        
//                        NSDictionary *addDic = @{@"latitude":friendDic[@"c_ALTIT"],@"longitude":friendDic[@"c_LONGIT"],@"userId":friendDic[@"c_U_NICKNAME"],@"place":friendDic[@"c_PLACE"],@"headImage":friendDic[@"c_NOTE"],@"c_PLACE":friendDic[@"c_PLACE"]};
//                        
//                        [_safeStateArray addObject:addDic];
//                        
//                    }
//                    
//                }
//                
//            }
//            
//            safeView111 = [[UIView alloc] initWithFrame:CGRectMake( 12, 70, 35, 35)];
//            
//            safeView111.backgroundColor = [UIColor clearColor];
//            
//            for (NSInteger i = 0; i < _safeStateArray.count; i++) {
//                
//                NSDictionary *dic = _safeStateArray[i];
//                
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                
//                btn.frame = CGRectMake(0, i * 40, 35, 35);
//                
//                btn.layer.cornerRadius = btn.frame.size.width / 2;
//                
//                btn.clipsToBounds = YES;
//                
//                btn.tag = 500 + i;
//                
//                [btn addTarget:self action:@selector(onBtnSafeFriendClick:) forControlEvents:UIControlEventTouchUpInside];
//                
//                NSString *imageStr = [NSString stringWithFormat:@"%@",dic[@"c_NOTE"]];
//                
//                if(imageStr.length > 6)
//                {
//                    [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:dic[@"c_NOTE"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"HeadImage1.png"]];
//                    
//                }else
//                {
//                    
//                    [btn setBackgroundImage:[UIImage imageNamed:@"HeadImage1.png"] forState:UIControlStateNormal];
//                    
//                }
//                
//                [safeView111 addSubview:btn];
//                
//            }
//            
//            safeView111.frame = CGRectMake( 12, 70, 35, 40 * _safeStateArray.count);
//            
//            [self.view addSubview:safeView111];
//            
//            for (NSInteger i = 0; i < _friendsLocationArray.count; i++) {
//                
//                NSDictionary *dic = _friendsLocationArray[i];
//                
//                CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
//                
//                AnimatedAnnotation * friendAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate2];
//                NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
//                for (NSInteger i = 1; i < 4; i++) {
//                    NSString *imageName = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
//                    CGSize size = CGSizeMake(240, 240);
//                    UIImage *image1 = [UIImage imageNamed:imageName];
//                    UIImage *image22;
//                    DbgLog(@"friend的头像－－－－－－》》》》》》  %@",dic[@""]);
//                    
//                    NSString *str = [NSString stringWithFormat:@"%@",dic[@"headImage"]];
//                    
//                    if(str.length > 6)
//                    {
//                        image22 = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"headImage"]]]];
//                        friendAnnotation.headImage = dic[@"headImage"];
//                        friendAnnotation.currentImageType = 1;
//                    }else
//                    {
//                        image22 = [UIImage imageNamed:@"HeadImage1.png"];
//                    }
//                    UIImage *image2 = [self circleImage:image22 withParam:0];
//                    UIGraphicsBeginImageContext(size);
//                    [image2 drawInRect:CGRectMake(54, 12, 110, 110)];
//                    [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
//                    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//                    [trainImages1 addObject:resultingImage];
//                }
//                friendAnnotation.longitude = dic[@"longitude"];
//                friendAnnotation.latitude = dic[@"latitude"];
//                friendAnnotation.mainUserId = dic[@"userId"];
//                
//                friendAnnotation.animatedImages = trainImages1;
//                friendAnnotation.userId = dic[@"userId"];
//                friendAnnotation.userLocation = dic[@"place"];
//                [_friendsAnnotations addObject:friendAnnotation];
//            }
//            [self.mapView addAnnotations:_friendsAnnotations];
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            DbgLog(@"failure :%@",error.localizedDescription);
//        }];
    
}

- (void)customFriendAnnotationWithCoordinate11:(CLLocationCoordinate2D )coordinate
{
    
    if (!_hirefriendsLocationArray) {
        _hirefriendsLocationArray= [[NSMutableArray alloc] init];
    }
    if (!_hirefriendsAnnotations) {
        _hirefriendsAnnotations = [[NSMutableArray alloc] init];
    }
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];

    if (!userDic) {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
//        Manager *mag = [Manager manager];
//        [mag.mainView.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSDictionary *param = @{@"token":userDic[@"token"],@"longitude":[NSString stringWithFormat:@"%f",_mapView.userLocation.coordinate.longitude],@"altitude":[NSString stringWithFormat:@"%f",_mapView.userLocation.coordinate.latitude]};//参数
 
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/hire/pos/list"];
    DbgLog(@"获取可雇佣人列表 －－－－－－－>>>>>>>%@",param);
 
    [self showHint:@"🔍 搜索可被雇佣的人..." yOffset:-100];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        
        DbgLog(@"%@",rspDic[@"data"]);
       
        NSString *str = [NSString stringWithFormat:@"%@",rspDic[@"data"]];
        if(str.length == 6){
            return ;
        }
            if([rspDic[@"data"] count] == 0)
            {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"周围没有可雇佣的人"
                                                              message:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"好"
                                                    otherButtonTitles:nil, nil];
                [alert show];
                
            }
        
        //获取成功才删除以前的东西
        for (UIView *view in safeView111.subviews) {
            [view removeFromSuperview];
        }
        [safeView111 removeFromSuperview];
        //删除普通好友的显示
        [_mapView removeAnnotations:_friendsAnnotations];
//        [_friendsAnnotations removeAllObjects];
//        [_friendsLocationArray removeAllObjects];
        
        //删除可雇佣人的数据和显示
        [_mapView removeAnnotations:_hirefriendsAnnotations];
        [_hirefriendsAnnotations removeAllObjects];
        [_hirefriendsLocationArray removeAllObjects];
        
        //显示新得到的数据
        for (NSDictionary *friendDic in rspDic[@"data"]) {
            
            NSDictionary *addDic = @{@"latitude":friendDic[@"c_ALTIT"],@"longitude":friendDic[@"c_LONGIT"],@"userId":friendDic[@"c_U_NICKNAME"],@"place":friendDic[@"c_PLACE"],@"headImage":friendDic[@"c_NOTE"],@"sex":friendDic[@"c_SEX"]};
            
            [_hirefriendsLocationArray addObject:addDic];
            
        }
        
        for (NSInteger i = 0; i < _hirefriendsLocationArray.count; i++) {
            
            NSDictionary *hireDic = _hirefriendsLocationArray[i];
            
            CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake([hireDic[@"latitude"] doubleValue], [hireDic[@"longitude"] doubleValue]);
            
            AnimatedAnnotation * friendAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate2];
            NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
            for (NSInteger i = 1; i < 3; i++) {
                NSString *imageName;
                
                if([hireDic[@"sex"] isEqualToString:@"0"])
                {
                     imageName = [NSString stringWithFormat:@"nan%ld.png",(long)i];
                }else if ([hireDic[@"sex"] isEqualToString:@"1"])
                {
                    imageName = [NSString stringWithFormat:@"nv%ld.png",(long)i];
                }
                
                CGSize size = CGSizeMake(240, 240);
                UIImage *image1 = [UIImage imageNamed:imageName];
                UIImage *image22;
                
                
                NSString *str = [NSString stringWithFormat:@"%@",hireDic[@"headImage"]];
                
                if(str.length > 6)
                {
                    image22 = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:hireDic[@"headImage"]]]];
                    friendAnnotation.headImage = hireDic[@"headImage"];
                    friendAnnotation.currentImageType = 1;
                }else
                {
                    image22 = [UIImage imageNamed:@"icon_logo"];
                }
                UIImage *image2 = [self circleImage:image22 withParam:0];
                UIGraphicsBeginImageContext(size);
                //[image2 drawInRect:CGRectMake(54, 12, 110, 110)];
                [image1 drawInRect:CGRectMake(40, 0, 120, 180)];
                UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                [trainImages1 addObject:resultingImage];
            }
            
            friendAnnotation.longitude = hireDic[@"longitude"];
            friendAnnotation.latitude = hireDic[@"latitude"];
            friendAnnotation.mainUserId = hireDic[@"userId"];
            
            friendAnnotation.animatedImages = trainImages1;
            friendAnnotation.userId = hireDic[@"userId"];
            friendAnnotation.userLocation = hireDic[@"place"];
            [_hirefriendsAnnotations addObject:friendAnnotation];
        }
        [self.mapView addAnnotations:_hirefriendsAnnotations];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
    }];
    
}

- (void)friendReal
{

    if (!_dataSourceTXL) {
        _dataSourceTXL = [[NSMutableArray alloc]init];
    }
    
    [self tongxunluList];
    
    if (!_friendsLocationArray) {
        _friendsLocationArray = [[NSMutableArray alloc] init];
    }
    if (!_friendsAnnotations) {
        _friendsAnnotations = [[NSMutableArray alloc] init];
    }
    if (!_safeStateArray) {
        _safeStateArray = [[NSMutableArray alloc] init];
    }
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    if (!userDic) {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
//        Manager *mag = [Manager manager];
//        [mag.mainView.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSDictionary *dic = @{@"token":userDic[@"token"],@"longitude":[NSString stringWithFormat:@"%f",_mapView.userLocation.coordinate.longitude],@"altitude":[NSString stringWithFormat:@"%f",_mapView.userLocation.coordinate.latitude]};//参数
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/pos/list"];
    DbgLog(@"获取好友列表 －－－－－－－>>>>>>>%@",dic);
    
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DbgLog(@"ssss%s",[responseObject bytes]);
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        if ([rspDic[@"code"] integerValue] == 201) {
            
            //先清理以前的东西
            //清理安全模式下的视图和数据
            for (UIView *view in safeView111.subviews) {
                [view removeFromSuperview];
            }
            [safeView111 removeFromSuperview];
            
            //清除普通好友的数据和显示
            [_mapView removeAnnotations:_friendsAnnotations];
            [_friendsAnnotations removeAllObjects];
            [_friendsLocationArray removeAllObjects];
            
            //清除安全模式下的数据和显示
            [_safeStateArray removeAllObjects];
            
            //再添加新刷新出来的东西
            DbgLog(@"%@",rspDic[@"data"]);

            for (NSDictionary *friendDic in rspDic[@"data"]) {
                
                NSDictionary *addDic = @{@"latitude":friendDic[@"c_ALTIT"],@"longitude":friendDic[@"c_LONGIT"],@"userId":friendDic[@"c_U_NICKNAME"],@"place":friendDic[@"c_PLACE"],@"headImage":friendDic[@"c_NOTE"],@"CUID":friendDic[@"c_U_ID"],@"Shield":friendDic[@"c_CREDIT"]};
                
                [_friendsLocationArray addObject:addDic];
                
                NSString *c_MODEL = [NSString stringWithFormat:@"%@",friendDic[@"c_MODEL"]];
                
                if(!(c_MODEL.length == 6))
                {
                    //如果处于安全模式，则添加到安全模式的好友数组
                    if([friendDic[@"c_MODEL"] isEqualToString:@"2"])
                    {
                        [_safeStateArray addObject:addDic];
                        
                    }
                }
            }
            if (!safeView111) {
                safeView111 = [[UIView alloc] initWithFrame:CGRectMake( 12, 70, 35, 35)];
            }
            
            safeView111.backgroundColor = [UIColor clearColor];
#pragma mark 🔌--- 显示安全模式下的好友在左上角
            for (NSInteger i = 0; i < _safeStateArray.count; i++) {
                
                NSDictionary *safeDic = _safeStateArray[i];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                btn.frame = CGRectMake(0, i * 40, 35, 35);
                
                btn.layer.cornerRadius = btn.frame.size.width / 2;
                
                btn.clipsToBounds = YES;
                
                btn.tag = 500 + i;
                
                [btn addTarget:self action:@selector(onBtnSafeFriendClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, i*40, 120, 35)];
                label.text = [NSString stringWithFormat:@"%@",safeDic[@"userId"]];
                label.textColor = [UIColor redColor];
                
                NSString *imageStr = [NSString stringWithFormat:@"%@",safeDic[@"headImage"]];
                
                if(imageStr.length > 6)
                {
                    [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_logo"]];
                    
                }else
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"icon_logo"] forState:UIControlStateNormal];
                }
                
                [safeView111 addSubview:btn];
                [safeView111 addSubview:label];
            }
            
            safeView111.frame = CGRectMake( 12, 70, 120, 40 * _safeStateArray.count);
            
            [self.view addSubview:safeView111];
            
#pragma mark 🔌--- 显示好友的位置
            
            if (_currentHireState == 99) {//在雇佣模式下并不处理好友的显示
                return ;
            }
            for (NSInteger i = 0; i < _friendsLocationArray.count; i++) {
                
                NSDictionary *friendsDic = _friendsLocationArray[i];
                
                CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake([friendsDic[@"latitude"] doubleValue], [friendsDic[@"longitude"] doubleValue]);
                
                AnimatedAnnotation * friendAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate2];
                NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
                for (NSInteger i = 1; i < 4; i++) {
                    NSString *imageName = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
                    NSString *imageName11;
                    
                    if(_currentTag == 104)
                    {
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld.png",(long)i,(long)i,(long)i];
                        
                    }else if (_currentTag == 105)
                    {
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i];
                        
                    }else if (_currentTag == 102)
                    {
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld.png",(long)i,(long)i,(long)i];
                        
                    }else if (_currentTag == 103)
                    {
                        
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
                        
                    }else if (_currentTag == 101)
                    {
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
                    }else if (_currentTag == 106)
                    {
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i];
                        
                    }

                    CGSize size = CGSizeMake(240, 240);
                    UIImage *image1 = [UIImage imageNamed:imageName];
                    UIImage *image22;

                    
                    NSString *friendHeadImgstr = [NSString stringWithFormat:@"%@",friendsDic[@"headImage"]];
                    
                    if(friendHeadImgstr.length > 6)
                    {
                        image22 = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:friendHeadImgstr]]];
                        friendAnnotation.headImage = friendsDic[@"headImage"];
                        friendAnnotation.currentImageType = 1;
                    }else
                    {
                        image22 = [UIImage imageNamed:@"icon_logo"];
                    }
                    UIImage *image2 = [self circleImage:image22 withParam:0];
                    UIGraphicsBeginImageContext(size);
                    [image2 drawInRect:CGRectMake(54, 12, 110, 110)];
                    [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
                    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                    [trainImages1 addObject:resultingImage];
                }
                friendAnnotation.longitude = friendsDic[@"longitude"];
                friendAnnotation.latitude = friendsDic[@"latitude"];
                friendAnnotation.mainUserId = friendsDic[@"CUID"];
                friendAnnotation.shield = [NSString stringWithFormat:@"%@",friendsDic[@"Shield"]];
                
                friendAnnotation.animatedImages = trainImages1;
                friendAnnotation.userId = friendsDic[@"userId"];
                friendAnnotation.userLocation = friendsDic[@"place"];
                friendAnnotation.headImage = friendsDic[@"headImage"];
                [_friendsAnnotations addObject:friendAnnotation];
            }
            [self.mapView addAnnotations:_friendsAnnotations];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
    }];
}

- (void)onBtnSafeFriendClick:(UIButton *)sender
{
    NSDictionary *dic = _safeStateArray[sender.tag - 500];
    
    for (NSObject *annotation in self.mapView.annotations) {
        
        if([annotation isKindOfClass:[AnimatedAnnotation class]])
        {
            
            AnimatedAnnotation *annotation1 = (AnimatedAnnotation *)annotation;
            
            if([annotation1.userId isEqualToString:dic[@"userId"]])
            {
                
                [_mapView removeAnnotation:annotation1];
                
            }
            
        }
        
    }
  
    AnimatedAnnotation *safeFriendAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue])];
    NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i < 4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
        CGSize size = CGSizeMake(240, 240);
        UIImage *image1 = [UIImage imageNamed:imageName];
        UIImage *image22;
        DbgLog(@"friend的头像－－－－－－》》》》》》  %@",dic[@"headImage"]);
        
        NSString *str = [NSString stringWithFormat:@"%@",dic[@"headImage"]];
        
        if(str.length > 6)
        {
            image22 = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
        }else
        {
            image22 = [UIImage imageNamed:@"icon_logo"];
        }
        UIImage *image2 = [self circleImage:image22 withParam:0];
        UIGraphicsBeginImageContext(size);
        [image2 drawInRect:CGRectMake(54, 12, 110, 110)];
        [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        [trainImages1 addObject:resultingImage];
    }
    
    
    CLLocationCoordinate2D coordinateShare = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
    MACoordinateSpan spanShare = MACoordinateSpanMake(0.08, 0.08);
    MACoordinateRegion reginShare = MACoordinateRegionMake(coordinateShare, spanShare);
    [_mapView setRegion:reginShare animated:YES];

    
    safeFriendAnnotation.animatedImages = trainImages1;
    safeFriendAnnotation.userId = dic[@"userId"];
    safeFriendAnnotation.mainUserId = dic[@"userId"];
    safeFriendAnnotation.userLocation = dic[@"place"];
    safeFriendAnnotation.headImage = dic[@"headImage"];
    safeFriendAnnotation.latitude = dic[@"latitude"];
    safeFriendAnnotation.longitude = dic[@"longitude"];
    safeFriendAnnotation.userLocation = dic[@"place"];

    [_mapView addAnnotation:safeFriendAnnotation];
    [_mapView selectAnnotation:safeFriendAnnotation animated:YES];

    
}

- (void)PlaceAroundHospital
{
    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    request.location = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude];
    request.radius = 8000;
    request.requireExtension = YES;
    
    //_currentHospiTal = 99;
    _photocolArray = @[@"090100"];
    
    request.types = _photocolArray;
    
    [_searchAPI AMapPlaceSearch:request];
    
}


#pragma mark  😄😄😄 返回自定义大头针的
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NavPointAnnotation class]])
    {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        
        MAPinAnnotationView *pointAnnotationView = (MAPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil)
        {
            pointAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:annotationIdentifier];
        }
        
        pointAnnotationView.animatesDrop   = NO;
        pointAnnotationView.canShowCallout = NO;
        pointAnnotationView.draggable      = NO;
        
        NavPointAnnotation *navAnnotation = (NavPointAnnotation *)annotation;
        
        if (navAnnotation.navPointType == NavPointAnnotationStart)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
        }
        else if (navAnnotation.navPointType == NavPointAnnotationWay)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorPurple];
        }
        else if (navAnnotation.navPointType == NavPointAnnotationEnd)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorRed];
        }
        return pointAnnotationView;
        
        
    }else if([annotation.title isEqual:@"当前位置"])
    {
        static NSString *identifier = @"MyPinId";
        MAPinAnnotationView *pinView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!pinView)
        {
            pinView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pinView.canShowCallout = YES;
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            UILabel *lable = [[UILabel alloc] init];
            lable.frame = CGRectMake(0, 0, 80, 20);
            lable.text = @"志荣维拓";
            lable.textColor = [UIColor blackColor];
            lable.font = [UIFont systemFontOfSize:12];
            
            UILabel *lable1 = [[UILabel alloc] init];
            lable1.frame = CGRectMake(0, 20, 80, 20);
            lable1.text = @"电话：666666";
            lable1.textColor = [UIColor blackColor];
            lable1.font = [UIFont systemFontOfSize:12];
            [leftView addSubview:lable];
            [leftView addSubview:lable1];
            //pinView.leftCalloutAccessoryView = leftView;
            leftView.layer.cornerRadius = 10;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(0, 0, 40, 40);
            [button setTitle:@"地址" forState:UIControlStateNormal];
            pinView.rightCalloutAccessoryView = button;
            UIImage *image = [UIImage imageNamed:@"userPosition"];
            CGSize size = CGSizeMake(120, 120);
            UIGraphicsBeginImageContext(size);
            [image drawInRect:CGRectMake(52, 16, 16, 16)];
            UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            pinView.image = image1;
            
            
            self.userLocationAnnotationView = pinView;
            
        }else
        {
            pinView.annotation = annotation;
        }
        pinView.centerOffset = CGPointMake(0, -18);
        return pinView;
    }else if([annotation isKindOfClass:[AnimatedAnnotation class]])
    {
        static NSString *animatedAnnotationIdentifier = @"AnimatedAnnotationIdentifier";
        AnimatedAnnotationView *annotationView = (AnimatedAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:animatedAnnotationIdentifier];
        if(annotationView == nil)
        {
            
            annotationView = [[AnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:animatedAnnotationIdentifier];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(0, 0, 60, 40);
            [button setTitle:@"呼叫" forState:UIControlStateNormal];
            //annotationView.rightCalloutAccessoryView = button;
            
            ThisOne *thisOne = [[NSBundle mainBundle] loadNibNamed:@"ThisOneView" owner:self options:nil][0];
            thisOne.frame = CGRectMake(0, 0, 100, 100);
            //annotationView.leftCalloutAccessoryView = thisOne;
            
        }
        annotationView.centerOffset = CGPointMake(0, -18);
        //annotationView.selected = YES;
        //annotationView.canShowCallout = YES;
        annotationView.draggable = YES;
        
        return annotationView;
    }else if ([annotation.title isEqual:@"hehe"])
    {
        static NSString *identifier = @"PinId";
        MAPinAnnotationView *pinView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!pinView)
        {
            pinView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pinView.canShowCallout = YES;
            UIImage *image = [UIImage imageNamed:@"userPosition"];
            CGSize size = CGSizeMake(120, 120);
            UIGraphicsBeginImageContext(size);
            [image drawInRect:CGRectMake(45, 0, 25, 25)];
            UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            pinView.image = image1;
        }else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }else if ([annotation isKindOfClass:[ZDLAnnotation class]])
    {
        static NSString *identifier = @"PinId";
        MAPinAnnotationView *pinView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!pinView)
        {
            pinView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pinView.canShowCallout = YES;
            //pinView.selected = YES;
            ZDLAnnotation *zdlannotation = (ZDLAnnotation *)annotation;
            if([zdlannotation.annotationType isEqualToString:@"医院"])
            {
                UIImage *image = [UIImage imageNamed:@"yiyuan"];
                CGSize size = CGSizeMake(30, 40);
                UIGraphicsBeginImageContext(size);
                [image drawInRect:CGRectMake(0, 0, 30, 40)];
                UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                pinView.image = image1;
                
            }else if ([zdlannotation.annotationType isEqualToString:@"警察"])
            {
                UIImage *image = [UIImage imageNamed:@"jinghui"];
                CGSize size = CGSizeMake(30, 40);
                UIGraphicsBeginImageContext(size);
                [image drawInRect:CGRectMake(0, 0, 30, 40)];
                UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                pinView.image = image1;
            }
            
        }else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }else if ([annotation.title isEqual:@"目的地"])
    {
        static NSString *identifier = @"PinId";
        MAPinAnnotationView *pinView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!pinView)
        {
            
            pinView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pinView.canShowCallout = YES;
            //pinView.selected = YES;
            
            UIImage *image = [UIImage imageNamed:@"anquanyemiantubiao_03"];
            
            CGSize size = CGSizeMake(30, 30);
            UIGraphicsBeginImageContext(size);
            [image drawInRect:CGRectMake(0, 0, 30, 30)];
            UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            pinView.image = image1;
            
            
        }else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }else
    {
        //        static NSString *navigationCellIdentifier = @"navigationCellIdentifier";
        //        MAAnnotationView *poiAnnotationView = (MAAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        //        if(!poiAnnotationView)
        //        {
        //            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:navigationCellIdentifier];
        //        }
        //
        //        poiAnnotationView.canShowCallout = YES;
        //        if([annotation isKindOfClass:[MANaviAnnotation class]])
        //        {
        //            switch (((MANaviAnnotation *)annotation).type) {
        //                case MANaviAnnotationTypeBus:
        //                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
        //                    break;
        //                case MANaviAnnotationTypeDrive:
        //                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
        //                    break;
        //                case MANaviAnnotationTypeWalking:
        //                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
        //                    break;
        //
        //                default:
        //                    break;
        //            }
        //        }
        //        return poiAnnotationView;
        static NSString *identifier = @"MyPinId";
        MAPinAnnotationView *pinView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!pinView)
        {
            pinView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pinView.canShowCallout = YES;
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
            leftView.backgroundColor = [UIColor cyanColor];
            //pinView.leftCalloutAccessoryView = leftView;
            leftView.layer.cornerRadius = 10;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 60, 30);
            //button.backgroundColor = [UIColor yellowColor];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            pinView.rightCalloutAccessoryView = button;
            pinView.animatesDrop = YES;
            DbgLog(@"11222");
            if([annotation.title isEqualToString:@"志荣维拓科技有限公司"] || [annotation.title isEqualToString:@"安全位置"])
            {
                pinView.pinColor = MAPinAnnotationColorGreen;
                
            }else if(_allTravelImages == 0 && _currentModel == 4)
            {
                //pinView.image = [self ChangeImageFromImage:@"chuxingchi"];
                UIImage *image = [UIImage imageNamed:@"chuxingchi"];
                CGSize size = CGSizeMake(30, 40);
                UIGraphicsBeginImageContext(size);
                [image drawInRect:CGRectMake(0, 0, 30, 40)];
                UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                pinView.image = image1;

                
            }else if (_allTravelImages == 1 && _currentModel == 4)
            {
                //pinView.image = [self ChangeImageFromImage:@"chuxingzhu"];
                UIImage *image = [UIImage imageNamed:@"chuxingzhu"];
                CGSize size = CGSizeMake(30, 40);
                UIGraphicsBeginImageContext(size);
                [image drawInRect:CGRectMake(0, 0, 30, 40)];
                UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                pinView.image = image1;
                
            }else if (_allTravelImages == 2 && _currentModel == 4)
            {
                
                //pinView.image = [self ChangeImageFromImage:@"chuxinggongjiao"];
                UIImage *image = [UIImage imageNamed:@"chuxinggongjiao"];
                CGSize size = CGSizeMake(30, 40);
                UIGraphicsBeginImageContext(size);
                [image drawInRect:CGRectMake(0, 0, 30, 40)];
                UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                pinView.image = image1;

                
            }else if (_currentPolice == 99)
            {
                
                UIImage *image = [UIImage imageNamed:@"jinghui"];
                CGSize size = CGSizeMake(30, 40);
                UIGraphicsBeginImageContext(size);
                [image drawInRect:CGRectMake(0, 0, 30, 40)];
                UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                pinView.image = image1;
                
                _currentPolice = 0;
                
            }else if (_currentHospiTal == 99)
            {
                
                UIImage *image = [UIImage imageNamed:@"yiyuan"];
                CGSize size = CGSizeMake(30, 40);
                UIGraphicsBeginImageContext(size);
                [image drawInRect:CGRectMake(0, 0, 30, 40)];
                UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                pinView.image = image1;
                
                _currentHospiTal = 0;
                
            }else
            {
                
                pinView.pinColor = MAPinAnnotationColorRed;
                
            }
            
            if ([annotation isKindOfClass:[MANaviAnnotation class]])
            {
                switch (((MANaviAnnotation*)annotation).type)
                {
                    case MANaviAnnotationTypeBus:
                        
                        //pinView.image = [UIImage imageNamed:@"bus"];
                        
                        break;
                        
                    case MANaviAnnotationTypeDrive:
                        
                        //pinView.image = [UIImage imageNamed:@"car"];
                        pinView.image = [UIImage imageNamed:@""];
                        break;
                        
                    case MANaviAnnotationTypeWalking:
                        pinView.image = [UIImage imageNamed:@"man"];
                        break;
                        
                    default:
                        break;
                }
            }
            
            pinView.draggable = YES;
        }else
        {
            pinView.annotation = annotation;
        }
        
        pinView.selected = YES;
        pinView.canShowCallout = YES;
        
        return pinView;
    }
    return nil;
}

#pragma mark 🎬---大头针图片大小定制
- (UIImage *)ChangeImageFromImage:(NSString *)imageName
{
    CGSize size = CGSizeMake(30, 30);
    UIImage *image1 = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(0, 0, 30, 30)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    return resultingImage;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if(_currentCount == 2)
    {
        
        _currentCount = 0;
        
//        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@""
//                                                      message:@"确定安全位置范围为1000米"
//                                                     delegate:self
//                                            cancelButtonTitle:@"好"
//                                            otherButtonTitles:nil, nil];
//        [alert show];
        
//        [self showHint:@"" yOffset:-100];
       
        
        NSDictionary *dic = @{@"latitude":[NSString stringWithFormat:@"%f", newPin.coordinate.latitude],@"longitude": [NSString stringWithFormat:@"%f",newPin.coordinate.longitude],@"subtitle":newPin.subtitle};
        
        [_safePlaceArrays addObject:dic];
        
        [self updateDictionNary:dic];
        
//        MAPointAnnotation *pinView = [[MAPointAnnotation alloc] init];
//        
//        pinView.coordinate = CLLocationCoordinate2DMake(_mapView.centerCoordinate.latitude, _mapView.centerCoordinate.longitude);
//        
//        pinView.title = @"安全点";
        
//        pinView.subtitle = newPin.subtitle;
//        [_pins addObject:pinView];
//        
//        [_mapView addAnnotation:pinView];
        MyZoneViewController *mzVC = [[MyZoneViewController alloc]initWithNibName:@"MyZoneViewController" bundle:nil];
        [self.navigationController pushViewController:mzVC animated:YES];
        
    }else
    {
        CLLocationCoordinate2D coordinate = view.annotation.coordinate;
        DbgLog(@"带我去%@  %f  %f",view.annotation.title,coordinate.longitude,coordinate.latitude);
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.searchType = AMapSearchType_ReGeocode;
        request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        request.requireExtension = YES;
        request.radius = 500;
        
        [_searchAPI AMapReGoecodeSearch:request];
    }
    
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    DbgLog(@"address ------- >>>>>>%@",response.regeocode.formattedAddress);
    
    if(_currentCount == 2 && _firstInSafe == 90)
    {
        newPin.subtitle = response.regeocode.formattedAddress;
        
    }else if(_updateLocationCurrent == 10)
    {
        if (changeAllow.selected == NO) {
            return;
        }
        _animatedCar.userLocation = response.regeocode.formattedAddress;
        _updateLocationCurrent = 0;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSDictionary *userDic = [userDef objectForKey:@"info"];
        if(userDic){
            NSDictionary *param = @{@"token":userDic[@"token"],@"flongit":[NSString stringWithFormat:@"%f",_mapView.userLocation.coordinate.longitude],@"faltit":[NSString stringWithFormat:@"%f",_mapView.userLocation.coordinate.latitude],@"cplace":response.regeocode.formattedAddress,@"type":@"1"};//参数
            DbgLog(@"%@",response.regeocode.formattedAddress);
            DbgLog(@"%@",param);
            
            self.localAddress = response.regeocode.formattedAddress;
            
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/mongo/addCurrlocation"];
            [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                DbgLog(@"ssss%s",[responseObject bytes]);
                NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
                DbgLog(@"%@",rspDic[@"msg"]);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DbgLog(@"failure :%@",error.localizedDescription);
            }];
        }
    }else if (_currentDistanceAnnotation == 99)
    {
        
        _currentDistanceAnnotation = 0;
        _safeDestinationPin.subtitle = response.regeocode.formattedAddress;
        _safeStr = response.regeocode.formattedAddress;
        
    }else{
        DbgLog(@"regeocode:%@  AddressComponent :%@  %@ %@",response.regeocode.formattedAddress,response.regeocode.addressComponent.province,response.regeocode.addressComponent.city,response.regeocode.addressComponent.district);
        _animatedCar.subtitle = response.regeocode.formattedAddress;
    }
}

#pragma mark 🌍——首次启动新手引导
-(void)TeachView
{
    
    [LoadTeachView loadTeachView:self];
    
}


//新手教程界面点击触发事件(must)
-(void)XSportLightClicked:(NSInteger)index{
    DbgLog(@"新手教程点击第%ld次",(long)index);
}
#pragma mark 👍点击按钮触发的操作
//点击左上角用户中心
-(void)onLeftClick:(UIButton *)sender
{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userInfo objectForKey:@"info"];
    if(dic)
    {
        [self.sideMenuViewController presentLeftViewController];
        //点击后去掉红点
        [self prepareLefBarBtn:0];
        [self.delegate reloadMenuDataAndViewVC:0];
    }else
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }

}
- (IBAction)onBtnClick:(UIButton *)sender {
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userInfo objectForKey:@"info"];
    if(dic)
    {
        [self.sideMenuViewController presentLeftViewController];
        
    }else
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma mark 🐶---全民动态相关
-(void)viewWillAppear:(BOOL)animated
{
//    注册键盘通知
    [self registerForKeyboardNotifications];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    if (userDic) {
        [self prepareDTData];
        [self.delegate reloadMenuDataAndViewVC:0];
        //[self prepareUI];
    }
}
-(void)prepareDTData
{
    // http://172.16.0.6:8080/zrwt/dynamic/get
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/dynamic/get"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:@"3" forKey:@"items "];
    DbgLog(@"发起的请求:%@-%@",strUrl,param)
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  ",rspDic);
        //取出本地用户信息
        if ([rspDic[@"code"] integerValue] == 201) {
            //得到新的数据后才移除老的数据
            [_DTModesArray removeAllObjects];
            for (NSDictionary *dtDic in rspDic[@"data"]) {
                DTModel *model = [[DTModel alloc]init];
                model.pid = dtDic[@"photoId"];
                model.ptime = dtDic[@"dateTime"];
                model.isMyLaud = dtDic[@"isMyLaud"];
                model.plaud = dtDic[@"laud"];
                model.ownerHeadIco = dtDic[@"ownerHeadIco"];
                model.ownerId = dtDic[@"ownerId"];
                model.punickname = dtDic[@"ownerNickname"];
                model.psize = dtDic[@"size"];
                NSString *imgStr = [NSString stringWithFormat:@"%@",dtDic[@"url"]];
//                NSArray *arr = [imgStr componentsSeparatedByString:@"_250x250"];
//                NSString *imgBigUrl = [NSString stringWithFormat:@"%@%@",arr[0],arr[1]];
                
                model.pimgurl =imgStr;
                
                [_DTModesArray addObject:model];
            }
            DbgLog(@"_DTModesArray 里 %@",_DTModesArray);
#pragma mark 🔌---当加载到动态的数据后才开始准备绘制界面
            [self PrepareDTView];
            
        }else
        {
//            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
//            [imgView setImage:[UIImage imageNamed:@"imgPlaceHd"]];
//            [_DongTaiView.photosView addSubview:imgView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        DbgLog(@"failure :%@",error.localizedDescription);
//        //获取失败加个占位图
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
//        [imgView setImage:[UIImage imageNamed:@"imgPlaceHd"]];
//        [_DongTaiView.photosView addSubview:imgView];
//        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}
-(void)PrepareDTView
{
    if (!_DongTaiView) {
        _DongTaiView = [[[NSBundle mainBundle]loadNibNamed:@"DongTaiView" owner:self options:nil]lastObject ];
    }
    
    _DongTaiView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    DbgLog(@" _DongTaiView %@  bounds = %@",NSStringFromCGRect(_DongTaiView.frame),NSStringFromCGRect(_DongTaiView.bounds));
//    DbgLog(@"_DongTaiView.photosView %@  ,bounds = %@",NSStringFromCGRect(_DongTaiView.photosView.frame),NSStringFromCGRect(_DongTaiView.photosView.bounds))
    
    _DongTaiView.clipsToBounds = YES;
    
//    CGRect ptRect = _DongTaiView.photosView.frame;
//    ptRect.size.height = _DongTaiView.bounds.size.height-40;
//    _DongTaiView.photosView.frame = ptRect;
//    
    _DongTaiView.photosView.clipsToBounds = YES;
//    _DongTaiView.photosView.contentMode = UIViewContentModeScaleAspectFit;
    if (!_Topic) {
        _Topic = [[JCTopic alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 70, SCREEN_HEIGHT - 190)];
    }
    
//    _Topic.layer.cornerRadius = 5;
    DbgLog(@"滚动图的frame %@",NSStringFromCGRect(_Topic.frame));
    _Topic.clipsToBounds = YES;
    //代理
    _Topic.JCdelegate = self;
    //创建数据
    NSMutableArray * tempArray = [[NSMutableArray alloc]init];
    
    for (DTModel *model in _DTModesArray) {
        UIImage * PlaceholderImage = [UIImage imageNamed:@"imgPlaceHd"];
        [tempArray addObject:[NSDictionary dictionaryWithObjects:@[model.pimgurl ,model.ownerHeadIco ,model.pid,@NO,PlaceholderImage] forKeys:@[@"pic",@"headPic",@"title",@"isLoc",@"placeholderImage"]]];
    }
    if (tempArray.count<1) {
        UIImage * PlaceholderImage = [UIImage imageNamed:@"imgPlaceHd"];
        [tempArray addObject:[NSDictionary dictionaryWithObjects:@[@"imgPlaceHd" ,@"icon_logo" ,@"0",@YES,PlaceholderImage] forKeys:@[@"pic",@"headPic",@"title",@"isLoc",@"placeholderImage"]]];
    }
    //加入数据
    _Topic.pics = tempArray;
    tempArray = nil;
    //更新
    [_Topic upDate];
//调整好视图frame以备动画显示
    CGRect shouldRect = _DongTaiView.photosView.frame;
    shouldRect.size.height = 0;
   
    _DongTaiView.photosView.frame = shouldRect;
    
    DbgLog(@" _DongTaiView %@  bounds = %@",NSStringFromCGRect(_DongTaiView.frame),NSStringFromCGRect(_DongTaiView.bounds));
    DbgLog(@"_DongTaiView.photosView %@  ,bounds = %@",NSStringFromCGRect(_DongTaiView.photosView.frame),NSStringFromCGRect(_DongTaiView.photosView.bounds))
    
}
#pragma mark 🔌---这是全民动态滚动视图的代理以及回调方法
-(void)didClick:(id)data{
    if ([data[@"title"] isEqualToString:@"0"]) {
        [self showHint:@"无动态资源！" yOffset:-100];
        return;
    }
    DbgLog(@"%@ class=%@",data,[data class]);
    DbgLog(@"点击了:%@",[NSString stringWithFormat:@"%@",(NSArray*)data]);
    DTDetailViewController *dtlVC = [[DTDetailViewController alloc]initWithNibName:@"DTDetailViewController" bundle:nil];
    
    dtlVC.pid = data[@"title"];
    dtlVC.headUrl = data[@"headPic"];
    dtlVC.pUrl = data[@"pic"];
    //关闭动态
    [self onDongTaiClose:nil];
    [self.navigationController pushViewController:dtlVC animated:YES];
}
-(void)currentPage:(int)page total:(NSUInteger)total{
    DbgLog(@"%@",[NSString stringWithFormat:@"Current Page %d",page+1]);
    DbgLog(@"total = %lu,page = %d",(unsigned long)total,page);
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:YES];
    
}

#pragma mark -🐶动态修改的地方
//点击右上角动态中心
- (IBAction)onDongTaiBtnClick:(UIButton *)sender {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    if (!userDic[@"token"]) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    //添加视图
    UIWindow *window = [[[UIApplication sharedApplication] windows]lastObject];
    [window addSubview:_DongTaiView];
    [_DongTaiView.photosView addSubview:_Topic];
    
    CGRect shouldRect = _DongTaiView.photosView.frame;
    
    
    [UIView animateWithDuration:0.2 animations:^{
        _DongTaiView.photosView.frame = shouldRect;
        
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)onDongTaiClose:(UIButton *)sender {
    CGRect rect = _DongTaiView.photosView.frame;
    rect.size.height = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _DongTaiView.photosView.frame = rect;
    } completion:^(BOOL finished) {
        if (finished) {
            [_Topic removeFromSuperview];
            [_DongTaiView removeFromSuperview];
        }
    }];
    //再次加载全民动态的数据
    [self prepareDTData];
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    DbgLog(@"%d",_DTimages.count);
    return _DTimages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SXImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.image = self.DTimages[indexPath.item];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除图片名
    [self.DTimages removeObjectAtIndex:indexPath.item];
    
    // 刷新数据
    //    [self.collectionView reloadData];
    
    // 直接将cell删除
    [self.DTcollectionView deleteItemsAtIndexPaths:@[indexPath]];
}
#pragma mark 🎬——下方模式选择界面定制
-(void)prepareUI
{
    
    NSArray *modelArray = @[@"share",@"f",@"s",@"a",@"3",@"g",@"h"];
    self.bottomScrollView.contentSize = CGSizeMake((ModelBtnWith)*modelArray.count, ModelBtnHeight);
    [self addMode:modelArray];
    
}

#pragma mark 加Btn
-(void)addMode:(NSArray *)imageArray
{
    for (int i=0; i<imageArray.count; i++) {
        DbgLog(@"oo");
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(i*ModelBtnWith, 0, ModelBtnWith - 15, ModelBtnHeight - 15);
        
        button.tag = 100+i;
        [button addTarget:self action:@selector(onModeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tintColor = [UIColor clearColor];
        
        [button setBackgroundImage:[UIImage imageNamed:_btnImages[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:_btnSelectImages[i]] forState:UIControlStateSelected];
        
        
        if(i == 3)
        {
            button.selected = YES;
            _selectBtn = button;
        }
        
        
        //        [button setTitle:@"变换" forState:UIControlStateNormal];
        //        [button setBackgroundImage:[UIImage imageNamed: @"purplePin"] forState:UIControlStateSelected];
        
        //        [button setBackgroundColor:[UIColor greenColor]];
        
        [self.bottomScrollView addSubview:button];
    }
    DbgLog(@"ok");
}

#pragma mark 😄😄各个模式的切换

-(void)onModeBtnClick:(UIButton *)sender
{
    _firstInSafe = 0;
    
    [_mapView removeAnnotation:_animatedCar11];
    
    
    [_mapView removeAnnotation:_animatedCar11];
    
    [self.mapView removeAnnotation:_safeDestinationPin];
    [self.mapView removeAnnotations:_currentSafePoliceAndHospital];

    _selectBtn.selected = NO;
    sender.selected = YES;
    _selectBtn = sender;
    
    UIAlertView* alert;
    _currentTag = sender.tag;
    DbgLog(@"%d",sender.tag);
    [_nearByView removeFromSuperview];
    [_hireView removeFromSuperview];
    
    if(sender.tag == 103)
    {
        
        _chooseFriendWidth.constant = 48;
        self.onBtnfriend.hidden = NO;
        
    }else
    {
        
        [_friendView removeFromSuperview];
        
        self.onBtnfriend.hidden = YES;
        _chooseFriendWidth.constant = 10;
        
    }
    
//    if(sender.tag == 102)
//    {
//        NSString *shareStr = [_onBtnShare titleForState:UIControlStateNormal];
//        if([shareStr isEqualToString:@"选择地点进入安全模式?"])
//        {
//            
//            [self.mapView addGestureRecognizer:_mapViewTapGesture];
//            
//        }
//        
//    }else
//    {
//        
//        [self.mapView removeAnnotations:_currentSafePoliceAndHospital];
//        
//        
//        [self.mapView removeGestureRecognizer:_mapViewTapGesture];
//        
//    }
    
    if(sender.tag == 106)
    {
        
        [_mapView removeAnnotations:_friendsAnnotations];
        
        _currentHireState = 99;
        
        [self customFriendAnnotationWithCoordinate11:CLLocationCoordinate2DMake(0, 0)];
        
        
    }else
    {
        if(_currentHireState == 99)
        {
            [_mapView addAnnotations:_friendsAnnotations];
            _currentHireState = 0;
            
            [_mapView removeAnnotations:_hirefriendsAnnotations];
            
        }
        
    }
    
#pragma mark 🌍---点击分享模式
    if(sender.tag == 100)
    {
//        for (NSObject *annotation in _mapView.annotations) {
//            
//            if([annotation isKindOfClass:[AnimatedAnnotation class]])
//            {
//                AnimatedAnnotation *animated = (AnimatedAnnotation *)annotation;
//                
//                NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
//                for (NSInteger i = 1; i < 4; i++) {
//                    NSString *imageName = [NSString stringWithFormat:@"%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i];
//                    CGSize size = CGSizeMake(240, 240);
//                    UIImage *image1 = [UIImage imageNamed:imageName];
//                    
//                    UIImage *image22 = [UIImage imageNamed:@"1.jpg"];
//                    UIImage *image2 = [self circleImage:image22 withParam:0];
//                    UIGraphicsBeginImageContext(size);
//                    [image2 drawInRect:CGRectMake(54, 10, 110, 110)];
//                    [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
//                    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//                    [trainImages1 addObject:resultingImage];
//                }
//                
//                animated.animatedImages = trainImages1;
//            }
//        }
//        
//        NSMutableArray *animateds = [[NSMutableArray alloc] init];
//        
//        for(NSObject *annotation in _mapView.annotations) {
//            if([annotation isKindOfClass:[AnimatedAnnotation class]])
//            {
//                [animateds addObject:annotation];
//            }
//        }
//        [_mapView removeAnnotations:animateds];
//        for (AnimatedAnnotation *annotation in animateds) {
//            
//            NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
//            for (NSInteger i = 1; i < 4; i++) {
//                NSString *imageName = [NSString stringWithFormat:@"%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i];
//                CGSize size = CGSizeMake(240, 240);
//                UIImage *image1 = [UIImage imageNamed:imageName];
//
//                UIImage *image22 = [UIImage imageNamed:@"1.jpg"];
//                UIImage *image2 = [self circleImage:image22 withParam:0];
//                UIGraphicsBeginImageContext(size);
//                [image2 drawInRect:CGRectMake(54, 10, 110, 110)];
//                [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
//                UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//                [trainImages1 addObject:resultingImage];
//            }
//            
//            annotation.animatedImages = trainImages1;
//        }
//        
//        [_mapView addAnnotations:animateds];
        
        
        
        DbgLog(@"100");
        
        [self.onBtnShare setTitle:@"点击分享给您的好友" forState:UIControlStateNormal];
        
        [self prepareForChangeModel];

        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        
        CLLocationCoordinate2D coordinateShare = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
        MACoordinateSpan spanShare = MACoordinateSpanMake(0.08, 0.08);
        MACoordinateRegion reginShare = MACoordinateRegionMake(coordinateShare, spanShare);
        [_mapView setRegion:reginShare animated:YES];
        
    }
#pragma mark 🌍---点击追随模式
    else if (sender.tag == 101)
    {
        //[self changeAnimationImage:@"追随"];
        
        [self prepareForChangeModel];
        
        [self.onBtnShare setTitle:@"请选择你要追随的好友" forState:UIControlStateNormal];
        
        //_serchTypeSegCtl.frame = CGRectMake(self.bottomBkView.frame.origin.x + 30, [UIScreen mainScreen].bounds.size.height - self.bottomBkView.frame.size.height - 30, 200, 30);
        
        //[self.view addSubview:_serchTypeSegCtl];
        
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
        MACoordinateSpan span = MACoordinateSpanMake(0.03, 0.03);
        MACoordinateRegion regin = MACoordinateRegionMake(coordinate, span);
        [_mapView setRegion:regin animated:YES];
        
        //[self changeAnimationImage:@"追随"];
        DbgLog(@"101");
        
    }
#pragma mark 🌍---点击安全模式
    else if (sender.tag == 102)
    {
        //[self changeAnimationImage:@"安全"];
        
//        if(_aimlongitude != 0 && _aimlatitude != 0)
//        {
//            [_mapView addAnnotation:_safeDestinationPin];
//            
//            _currentModel3 = 2;
//            
//            [self onBtnChooseTraffic:0];
//        }
        
//        
//        [self.mapView addAnnotation:_safeDestinationPin];
//        [self.mapView addAnnotations:_currentSafePoliceAndHospital];
        
        DbgLog(@"_currentSafePoliceandHospital%@",_currentSafePoliceAndHospital);
        
        [self prepareForChangeModel];
        
        if(_safeState == 100)
        {
            
            [_mapView addAnnotation:_safeDestinationPin];
            [_mapView selectAnnotation:_safeDestinationPin animated:YES];
            [self.mapView addAnnotations:_currentSafePoliceAndHospital];
            
            _currentModel3 = 2;
            
            [self onBtnChooseTraffic:0];

            
            [self.onBtnShare setTitle:@"退出安全模式" forState:UIControlStateNormal];
            
            
        }else if (_safeState == 101)
        {

            [_mapView removeAnnotation:_safeDestinationPin];
            [_mapView removeAnnotations:_currentSafePoliceAndHospital];
            
            [self.onBtnShare setTitle:@"选择地点进入安全模式?" forState:UIControlStateNormal];
            

            
        }
        CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude );
        MACoordinateSpan span1 = MACoordinateSpanMake(0.08, 0.08);
        MACoordinateRegion regin1 = MACoordinateRegionMake(coordinate1, span1);
        [_mapView setRegion:regin1 animated:YES];
        //        newPin = [[MAPointAnnotation alloc] init];
        //        newPin.coordinate = coordinate1;
        //        newPin.title = @"安全位置";
        //        [_mapView addAnnotation:newPin];
        //        [_mapView selectAnnotation:newPin animated:YES];
        
        //[self changeAnimationImage:@"安全"];
        
        
    }
#pragma mark 🌍---点击普通模式
    else if (sender.tag == 103)
    {
        //[self changeAnimationImage:@"普通"];
        [self prepareForChangeModel];
        
        [self.onBtnShare setTitle:@"请选择你要查看的好友" forState:UIControlStateNormal];
        
        //            _serchTypeSegCtl.frame = CGRectMake(self.bottomBkView.frame.origin.x + 30, [UIScreen mainScreen].bounds.size.height - self.bottomBkView.frame.size.height - 30, 200, 30);
        //
        //            [self.view addSubview:_serchTypeSegCtl];
        
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        
        CLLocationCoordinate2D coordinate11 = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
        MACoordinateSpan span11 = MACoordinateSpanMake(0.006, 0.006);
        MACoordinateRegion regin11 = MACoordinateRegionMake(coordinate11, span11);
        [_mapView setRegion:regin11 animated:YES];
        
        //[self changeAnimationImage:@"普通"];
    }
#pragma mark 🌍---点击出行模式
    else if (sender.tag == 104)
    {
        //[self changeAnimationImage:@"出行"];
        
        [self clear];
        
        [_trafficView removeFromSuperview];
        
        [_mapView removeAnnotations:_pins];
        
        [_pins removeAllObjects];
        
        [self.onBtnShare setTitle:@"进入出行模式" forState:UIControlStateNormal];
        
        CLLocationCoordinate2D coordinateArea = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
        MACoordinateSpan spanArea = MACoordinateSpanMake(0.1, 0.1);
        MACoordinateRegion reginArea = MACoordinateRegionMake(coordinateArea, spanArea);
        [_mapView setRegion:reginArea animated:YES];
        
        //            request = [[AMapPlaceSearchRequest alloc] init];
        //            request.searchType = AMapSearchType_PlaceAround;
        //            request.types = @[@"090100",@"090102",@"130501",@"130506",@"130504",@"090101"];
        //            request.location = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude  longitude:_mapView.userLocation.coordinate.longitude];
        //            request.radius = 8000;
        //            request.requireExtension = YES;
        //            [_searchAPI AMapPlaceSearch:request];
        
        //[self changeAnimationImage:@"出行"];
        
        DbgLog(@"104");
    }
#pragma mark 🌍---点击召集模式
    else if (sender.tag == 105)
    {
        //[self changeAnimationImage:@"召集"];
        
        [self.onBtnShare setTitle:@"请选择你要召集的好友" forState:UIControlStateNormal];
        
        [self prepareForChangeModel];
        
        CLLocationCoordinate2D coordinate11 = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
        MACoordinateSpan span11 = MACoordinateSpanMake(0.05, 0.05);
        MACoordinateRegion regin11 = MACoordinateRegionMake(coordinate11, span11);
        [_mapView setRegion:regin11 animated:YES];

        
        //[self changeAnimationImage:@"召集"];
        DbgLog(@"105");
    }
#pragma mark 🌍---点击雇佣模式
    else if (sender.tag == 106)
    {
        //rr[self changeAnimationImage:@"雇佣"];
        
        [self.onBtnShare setTitle:@"开启雇佣模式" forState:UIControlStateNormal];
        [self prepareForChangeModel];
        
        CLLocationCoordinate2D coordinate11 = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
        MACoordinateSpan span11 = MACoordinateSpanMake(0.2, 0.2);
        MACoordinateRegion regin11 = MACoordinateRegionMake(coordinate11, span11);
        [_mapView setRegion:regin11 animated:YES];
        
        
        //[self changeAnimationImage:@"雇佣"];
        DbgLog(@"106");
    }
    //    点击按钮时偏移到当前位置
    _currentModel = (int)sender.tag-100;
    [self setContentOffset];
    
    
    if(sender.tag == 102)
    {
        NSString *shareStr = [_onBtnShare titleForState:UIControlStateNormal];
        if([shareStr isEqualToString:@"选择地点进入安全模式?"])
        {
            
            [self.mapView addGestureRecognizer:_mapViewTapGesture];
            
        }
        
    }else
    {
        
        [self.mapView removeAnnotation:_safeDestinationPin];
        
        [self.mapView removeAnnotations:_currentSafePoliceAndHospital];
        
        
        [self.mapView removeGestureRecognizer:_mapViewTapGesture];
        
    }
    
    
    
}


- (void)changeAnimationImage:(NSString *)imageName // 未调用
{
    
    
    NSMutableArray *animateds = [[NSMutableArray alloc] init];
    
    for(NSObject *annotation in _mapView.annotations) {
        if([annotation isKindOfClass:[AnimatedAnnotation class]])
        {
            [animateds addObject:annotation];
        }
    }
    [_mapView removeAnnotations:animateds];
    for (AnimatedAnnotation *annotation in animateds) {
        
        NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
        for (NSInteger i = 1; i < 4; i++) {
            NSString *imageName11;
            if([imageName isEqualToString:@"出行"])
            {
                imageName11 = [NSString stringWithFormat:@"%ld%ld%ld.png",(long)i,(long)i,(long)i];
                
            }else if ([imageName isEqualToString:@"召集"])
            {
                imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i];
                
            }else if ([imageName isEqualToString:@"安全"])
            {
                imageName11 = [NSString stringWithFormat:@"%ld%ld%ld.png",(long)i,(long)i,(long)i];
                
            }else if ([imageName isEqualToString:@"普通"])
            {
                
                imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
                
            }else if ([imageName isEqualToString:@"追随"])
            {
                imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
            }else if ([imageName isEqualToString:@"雇佣"])
            {
                imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i];

            }
            DbgLog(@"imageName  %@",imageName11);
            
            CGSize size = CGSizeMake(240, 240);
            UIImage *image1 = [UIImage imageNamed:imageName11];
            UIImage *image22;
            if(annotation.currentImageType)
            {
                image22 = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:annotation.headImage]]];
                
            }else
            {
                image22 = [UIImage imageNamed:@"1.jpg"];
            }
            UIImage *image2 = [self circleImage:image22 withParam:0];
            UIGraphicsBeginImageContext(size);
            [image2 drawInRect:CGRectMake(54, 12, 110, 110)];
            [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
            UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
            [trainImages1 addObject:resultingImage];
        }
        
        annotation.animatedImages = trainImages1;
    }
    
    [_mapView addAnnotations:animateds];

}


#pragma mark 👍---点击雇佣的性别选择按钮时
- (IBAction)onGYSexnanClick:(UIButton *)sender {
    if (sender.selected == YES) {
        sender.selected = NO;
        _GYSexRsNum -=1;
    }else
    {
        sender.selected = YES;
        _GYSexRsNum +=1;
    }
}
- (IBAction)onGYSexNvClick:(UIButton *)sender {
    if (sender.selected == YES) {
        sender.selected = NO;
        _GYSexRsNum -=1;
    }else
    {
        sender.selected = YES;
        _GYSexRsNum +=2;
    }
}

-(void)prepareForChangeModel
{
    [self clear];
    
    for (UIButton *btn in _trafficView.subviews) {
        [btn removeFromSuperview];
    }
    [_trafficView removeFromSuperview];
    
    [_mapView removeAnnotation:newPin];
    
    [_mapView removeAnnotations:_pins];
    
    
    [_pins removeAllObjects];
    
    CGRect rect =  changeTypeBtn.frame;
    
    rect.origin.y = Y;
    
    changeTypeBtn.frame = rect;
    
    CGRect rect1 = backlocationBtn.frame;
    
    rect1.origin.y = Y;
    
    backlocationBtn.frame = rect1;
    
    
    _changeHeight.constant = 100;

}

#pragma mark 搜索附近的餐厅，医院，警察
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(_currentTag == 104)
    {
    
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
        MACoordinateSpan span = MACoordinateSpanMake(0.04, 0.04);
        MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
        [_mapView setRegion:region];
        
        NSInteger currentTravel = 0;//搜索请求下来的三个数据
        
        //for (AMapPOI *poi in response.pois) {
        switch (_allTravelImages) {
            case 0:
                [_eatArray removeAllObjects];
                break;
            case 1:
                [_liveArray removeAllObjects];
                break;
            case 2:
                [_tourArray removeAllObjects];
                break;
            default:
                break;
        }
        for (NSInteger i = 0; i < response.pois.count; i++) {
            AMapPOI *poi = response.pois[i];
            
            if(poi.tel.length > 0 || _allTravelImages == 2)
            {
                
                MAPointAnnotation *pin1 = [[MAPointAnnotation alloc] init];
                
                pin1.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
                
                pin1.title = poi.name;
                
                pin1.subtitle = poi.tel;
                
                if(currentTravel < 3)
                {
                    [_pins addObject:pin1];
                    
                }
                
                if(_allTravelImages == 0)
                {
                    [_eatArray addObject:pin1];
                    
                }else if (_allTravelImages == 1)
                {
                    [_liveArray addObject:pin1];
                    
                }else if (_allTravelImages == 2)
                {
                    
                    [_tourArray addObject:pin1];
                    
                }
                
                currentTravel++;
            }
            
            
        }
        
        [_mapView addAnnotations:_pins];
    }else
    {
        
//        for (AMapPOI *poi in response.pois) {
//            DbgLog(@"response name:%@, address:%@, latitude:%f, longitude:%f, telephne:%@", poi.name, poi.address, poi.location.latitude, poi.location.longitude,poi.tel);
//            
//            //创建大头针
//            MAPointAnnotation *pin = [[MAPointAnnotation alloc]init];
//            pin.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);//大头针坐标
//            pin.title = poi.name;
//            pin.subtitle = poi.address;
//            [_pins addObject:pin];
//        }
//        //把大头针钉在地图上
//        [_mapView addAnnotations:_pins];
        
        AMapPOI *poi = response.pois[0];
        
        
        if (!pinJC) {
             pinJC = [[ZDLAnnotation alloc] init];
        }
        if (!pinYY) {
            pinYY = [[ZDLAnnotation alloc]init];
        }
        
        if(request.types == _policeArray)
        {
            pinJC.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            pinJC.annotationType = @"警察";
            pinJC.title = poi.name;
            pinJC.subtitle = poi.tel;
            [_currentSafePoliceAndHospital removeObject:pinJC];
            [_currentSafePoliceAndHospital addObject:pinJC];
            DbgLog(@"aaa");
        }else if (request.types == _photocolArray)
        {
            pinYY.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            pinYY.annotationType = @"医院";
            pinYY.title = poi.name;
            pinYY.subtitle = poi.tel;
            [_currentSafePoliceAndHospital removeObject:pinYY];
            [_currentSafePoliceAndHospital addObject:pinYY];
            DbgLog(@"aaa");
        }

    }
    
}

#pragma mark 👋——添加手势
-(void)addGestureRecognizer
{
    //    下方模式选择框滑动手势
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.bottomBkView addGestureRecognizer:swipRight];
    [self.bottomBkView addGestureRecognizer:swipLeft];
    
    //    给主界面添加手势，点击收起键盘
    UITapGestureRecognizer *tapBody = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.view addGestureRecognizer:tapBody];
}
#pragma mark 👋——手势触发的方法
-(void)swip:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        DbgLog(@"left");
        _currentModel ++;
        
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        DbgLog(@"right");
        _currentModel--;
    }
    
    if(_currentModel < 0)
    {
        _currentModel = 0;
        
    }else if (_currentModel > 6)
    {
        
        _currentModel = 6;
        
    }
    
    UIButton *btn = (UIButton *)[self.bottomScrollView viewWithTag:100 + _currentModel];
    
    [self onModeBtnClick:btn];
    
    
    [self setContentOffset];
    
}

-(void)setContentOffset
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.bottomScrollView.contentOffset = CGPointMake((_currentModel + 1) * ModelBtnWith - self.bottomScrollView.contentSize.width / 2, 0);
        //self.bottomScrollView.frame.size.width
    }];
}

-(void)hiddenKeyBoard
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if(_currentCenter == 22 && _firstInSafe == 90 )
    {
        
        newPin.coordinate = _mapView.centerCoordinate;
        MAAnnotationView *pinView = [_mapView viewForAnnotation:newPin];
        [pinView setDragState:MAAnnotationViewDragStateStarting animated:YES];
        
    }
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(_currentCenter == 22 && _firstInSafe == 90)
    {
        DbgLog(@"修改位置");
        newPin.coordinate = _mapView.centerCoordinate;
        MAAnnotationView *pinView = [_mapView viewForAnnotation:newPin];
        [pinView setDragState:MAAnnotationViewDragStateEnding animated:YES];
        [_mapView selectAnnotation:newPin animated:YES];
        
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.searchType = AMapSearchType_ReGeocode;
        request.location = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
        request.requireExtension = YES;
        request.radius = 500;
        _currentCount = 2;
        [_searchAPI AMapReGoecodeSearch:request];
        
    }
    
}

-(void)fenxiangNow:(UIButton *)sender
{
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    NSString *time = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    if (userDic) {
        NSDictionary *param = @{@"token":userDic[@"token"],@"altitude":[NSString stringWithFormat:@"%f",_mapView.userLocation.coordinate.latitude],@"longitude":[NSString stringWithFormat:@"%f", _mapView.userLocation.coordinate.longitude],@"duration":time};
        
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/share/pos"];
        [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DbgLog(@"ssss%s",[responseObject bytes]);
            [MBProgressHUD hideHUDForView:window animated:YES];
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
            DbgLog(@"%@",rspDic);
            NSString *mapUrl = rspDic[@"data"];
            
            NSArray *mapUrl1 = [mapUrl componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
            
            [CoreUMeng umengSetAppKey:UmengAppKey];
            
            [CoreUMeng umengSetSinaSSOWithRedirectURL:@"http://www.baidu.com"];
            //集成微信
            [CoreUMeng umengSetWXAppId:WXAPPID appSecret:WXAPPsecret url:mapUrl1[1]];
            //集成QQ
            [CoreUMeng umengSetQQAppId:@"100424468" appSecret:@"c7394704798a158208a74ab60104f0ba" url:mapUrl1[1]];
            
            [CoreUmengShare show:self text:mapUrl image:[UIImage imageNamed:@"ICON80-01.png"]];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            DbgLog(@"failure :%@",error.localizedDescription);
        }];
    }else
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (IBAction)onBtnShareClick:(UIButton *)sender {
    
    if(_currentTag == 100)
    {
#pragma mark 👍点击立即分享
        fxsjView *view = [[[NSBundle mainBundle]loadNibNamed:@"fxsjView" owner:self options:nil]lastObject];
        
        view.frame = CGRectMake(0, SCREEN_HEIGHT-140, SCREEN_WIDTH,140);
        view.ZjOKBtn.tag = (int)view.timeSlider.value;
        [view.ZjOKBtn addTarget:self action:@selector(fenxiangNow:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:view];
        
    }else if (_currentTag == 103)
    {
        FriendAndGroupViewController *firVC = [[FriendAndGroupViewController alloc] init];
        
        firVC.delegate = self;
        
        [self.navigationController pushViewController:firVC animated:YES];
        
    }else if (_currentTag == 105)
    {
#pragma mark 👍点击发起召集
        MusterViewController *MusterVC = [[MusterViewController alloc] init];
        
        [self.navigationController pushViewController:MusterVC animated:YES];
    }else if (_currentTag == 102)
    {
        NSString *safeTitle = [sender titleForState:UIControlStateNormal];
        if([safeTitle isEqualToString:@"退出安全模式"])
        {

#pragma  mark  😢😢退退退退退退退退退退退退退退退退退退退退退退退退退退退退退退退退退出安全模式
            
            //[_currentSafePoliceAndHospital removeAllObjects];
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude ,_mapView.userLocation.coordinate.longitude));
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(_aimlatitude,_aimlongitude));
            //2.计算距离
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            
            NSString *distanceTime = [NSString stringWithFormat:@"%.0f",(distance / 60)];
            
            [self changeMySafeModel:@"out" andStart:nil andEnd:nil andDuration:distanceTime];
            
            
            
            _safeState = 101;
            
            [self clear];
            
            _aimlatitude = 0;
            
            _aimlongitude = 0;
            
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            
            [userDef removeObjectForKey:@"aim"];
            
            [userDef synchronize];
            
//            [_currentSafePoliceAndHospital removeAllObjects];
            
            [_mapView removeAnnotations:_currentSafePoliceAndHospital];
            
            [_mapView removeAnnotation:_safeDestinationPin];
            
            [_safeView removeFromSuperview];
            
            [_mapView addGestureRecognizer:_mapViewTapGesture];
            
            [sender setTitle:@"选择地点进入安全模式?" forState:UIControlStateNormal];
            
            //[self showHint:@"退出安全模式成功"];
            
            [self showHint:@"退出安全模式成功" yOffset:- 150];
            
        }else
        {
            
            PlistListViewController *plistVC = [[PlistListViewController alloc] init];
            
            plistVC.delegate = self;
            
            plistVC.plistType = 102;
            
            [self.navigationController pushViewController:plistVC animated:YES];
        
        }
        
        
        
    }else if (_currentTag == 104)
    {
#pragma mark 🚗出行模式开启和关闭
        NSString *strUrl = [sender titleForState:UIControlStateNormal];
        if([strUrl isEqualToString:@"进入出行模式"])
        {
            [self showHint:@"开启出行模式" yOffset:-150];
            [self chuXingTianqi];
            CGRect rect =  changeTypeBtn.frame;
            rect.origin.y = Y - 40;
            
            CGRect rect1 = backlocationBtn.frame;
            rect1.origin.y = Y - 40;
            
            [UIView animateWithDuration:0.2 animations:^{
                _changeHeight.constant = 140;
                changeTypeBtn.frame = rect;
                backlocationBtn.frame = rect1;
            }];
            
            [self.bottomBkView addSubview:_nearByView];
            [sender setTitle:@"退出出行模式" forState:UIControlStateNormal];
            
        }else if ([strUrl isEqualToString:@"退出出行模式"])
        {
            [self showHint:@"出行模式已退出" yOffset:-150];
            [self prepareForChangeModel];
            
            [_nearByView removeFromSuperview];
            
            [sender setTitle:@"进入出行模式" forState:UIControlStateNormal];
            
        }
#pragma mark 👍点击追谁
    }else if (_currentTag == 101)
    {
        UrgentFriendViewController *urVC = [[UrgentFriendViewController alloc] init];
        urVC.currentType = 101;
        
        [self.navigationController pushViewController:urVC animated:YES];
        
#pragma mark 👍分点击发布雇佣
    }else if (_currentTag == 106)
    {
        
        NSString *hireStr = [sender titleForState:UIControlStateNormal];
        if([hireStr isEqualToString:@"开启雇佣模式"])
        {
//            [self showHint:@"正在开启雇佣模式" yOffset:-150];
            CGRect rect =  changeTypeBtn.frame;
            rect.origin.y = Y - 40;
            
            CGRect rect1 = backlocationBtn.frame;
            rect1.origin.y = Y - 40;
            
            [UIView animateWithDuration:0.2 animations:^{
                _changeHeight.constant = 140;
                changeTypeBtn.frame = rect;
                backlocationBtn.frame = rect1;
            }];
            [self.bottomBkView addSubview:_hireView];
            [sender setTitle:@"退出雇佣模式" forState:UIControlStateNormal];
            
        }else if ([hireStr isEqualToString:@"退出雇佣模式"])
        {
            
            [self showHint:@"已退出雇佣模式" yOffset:-150];
            [self prepareForChangeModel];
            [_hireView removeFromSuperview];
            [sender setTitle:@"开启雇佣模式" forState:UIControlStateNormal];
            
        }
        
    }
}
#pragma mark ---获取天气信息
-(void)chuXingTianqi
{
//    接口地址：/weather/getWeather
//    参数：token
//    place 地址：例如：北京
//    返回参数：
//    code 102;无data返回
//    code 200;发送成功！
    DbgLog(@"我的当前地址:%@",self.localAddress);
    NSArray *ar = [self.localAddress componentsSeparatedByString:@"市"];
    NSString *place = ar[0];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:place forKey:@"place"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/weather/getWeather"];

    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        //        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        if ([rspDic[@"code"] integerValue] == 201) {
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);

    }];

    
}

- (IBAction)onGyPhotoClick:(UIButton *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"本地相册",@"相机拍照", nil];
    alertView.tag = 562;
    [alertView show];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    gyImage = image;
    DbgLog(@"gyImage = %@",gyImage);
    [_gyV.gyPhotoBtn setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//发布雇佣时填写的雇用信息textView的代理
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [_gyV.jineTextField endEditing:YES];
    if ([textView.text isEqualToString:@"请输入雇佣描述"]) {
        textView.text = @"";
    }
    _whichTouch = @"gyms";
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1) {
        textView.text = @"请输入雇佣描述";
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    [_GYFBDic setValue:textView.text forKey:@"content"];
    DbgLog(@"_GYFBDic[contetn]= %@",_GYFBDic[@"content"]);
}
//发布雇佣时填写信息textField的代理
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_GYFBDic setValue:textField.text forKey:@"money"];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _whichTouch = @"gyje";
}
//给视图添加点击手势
-(void)addTapGuOnView:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapView:)];
    [view addGestureRecognizer:tap];
}
//视图的点击手势处理
-(void)OnTapView:(UITapGestureRecognizer *)sender
{
    [_gyV.jineTextField endEditing:YES];
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    switch (sender.view.tag) {
        case GYVTAG:
        {
            
        }
            break;
        case GYVTAG+1://点击
        {
            
        }
            break;
        case GYVTAG+2://点击
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark 🎈---发起雇用的雇用的请求
-(void)onGuyongSendClick:(UIButton *)sender
{
//http://xxx.xxx.xxx.xxx:port/zrwt/hire/req?token=xxx&money=12&desc=xxx&longitude=222.22&altitude=11.11&pos=xxx
//xxx.xxx.xxx.xxx:port/zrwt/hire/req/img?token=xxx&money=12&desc=xxx&longitude=222.22&altitude=11.11&pos=xxx
//    /hire/req?token=xxx&money=12&desc=xxx&longitude=222.22&altitude=11.11&pos=xxx
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *reqUrlStr;
    if (gyImage) {
        reqUrlStr = @"/hire/req/img";
    }else
    {
        reqUrlStr = @"/hire/req";
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,reqUrlStr];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    DbgLog(@"_GYFBDic = %@",_GYFBDic);
    if ([_GYFBDic[@"content"] length]<1) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        [self showHint:@"内容过少" yOffset:-100];
        return;
    }
    if ([_GYFBDic[@"money"] length]<1) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        [self showHint:@"请输入支付金额" yOffset:-100];
        return;
    }
    
    Manager *mng = [Manager manager];
    
    NSString *la = [NSString stringWithFormat:@"%f",mng.mainView.localCoordinate.latitude];
    NSString *lo = [NSString stringWithFormat:@"%f",mng.mainView.localCoordinate.longitude];
    
    DbgLog(@"1是男，2是女，3是男和女:%ld",(long)_GYSexRsNum);
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_GYFBDic[@"content"] forKey:@"desc"];
    [param setValue:_GYFBDic[@"money"] forKey:@"money"];
    [param setValue:_GYFBDic[@"sex"] forKey:@"sex"];
    [param setValue:la forKey:@"altitude"];
    [param setValue:lo forKey:@"longitude"];
    [param setValue:mng.mainView.localAddress forKey:@"pos"];
    if (gyImage) {
        [manager POST:strUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                NSData *data = UIImageJPEGRepresentation(gyImage, 1);
                NSString *imageName = [NSString stringWithFormat:@"gyImage.jpg"];
                [formData appendPartWithFileData:data name:@"images" fileName:imageName mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
            [MBProgressHUD hideHUDForView:window animated:YES];
            if ([rspDic[@"code"] integerValue] == 200) {
                [self showHint:@"有人接单后将会通知您，等待..." yOffset:-100];
                gyImage = nil;
                [_gyV removeFromSuperview];
                [_GYFBDic setValue:@"" forKey:@"content"];
                [_GYFBDic setValue:@"" forKey:@"money"];
                [_GYFBDic setValue:@"" forKey:@"sex"];
            }else
            {
                [self showHint:rspDic[@"msg"] yOffset:-100];
                gyImage = nil;
                [_gyV removeFromSuperview];
            }

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            _GYFBDic = nil;
            DbgLog(@"failure :%@",error.localizedDescription);
            [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
        }];
    }else
    {
        DbgLog(@"发送的数据:%@",param);
        [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
            [MBProgressHUD hideHUDForView:window animated:YES];
            DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
            if ([rspDic[@"code"] integerValue] == 200) {
                [self showHint:@"有人接单后将会通知您，等待..." yOffset:-100];
                gyImage = nil;
                [_gyV removeFromSuperview];
                [_GYFBDic setValue:@"" forKey:@"content"];
                [_GYFBDic setValue:@"" forKey:@"money"];
                [_GYFBDic setValue:@"" forKey:@"sex"];
            }else
            {
                [self showHint:rspDic[@"msg"] yOffset:-100];
                gyImage = nil;
                [_gyV removeFromSuperview];
            }
            //取出本地用户信息
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            _GYFBDic = nil;
            DbgLog(@"failure :%@",error.localizedDescription);
            [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
        }];
    }
    
}
-(void)tapGvc:(UITapGestureRecognizer *)sender
{
    DbgLog(@"send.tag = %d",sender.view.tag);
    [_gyV.jineTextField resignFirstResponder];
    [_gyV.contentTextView resignFirstResponder];
    
    self.gyV.frame = CGRectMake(0, SCREEN_HEIGHT-self.gyV.bounds.size.height, self.gyV.bounds.size.width, self.gyV.bounds.size.height);
    if (sender.view.tag == 88) {
        gyImage = nil;
        [sender.view removeFromSuperview];
    }
}

- (void)plistlistViewController:(PlistListViewController *)plistVC andNeedChangeLatitude:(CGFloat)latitude andNeedChangeLongitude:(CGFloat)longgitude
{
    
    _aimlatitude = latitude;
    _aimlongitude = longgitude;
    
    _safeDestinationPin.coordinate = CLLocationCoordinate2DMake(latitude, longgitude);
    
    _safeDestinationPin.title = @"目的地";
    
    [_mapView addAnnotation:_safeDestinationPin];
    
    [self onBtnChooseTraffic:0];
    
}
-(void)plistListViewController:(PlistListViewController *)plistVC addNeedChangeName:(NSString *)name
{
    
    NSString *hitStr = [NSString stringWithFormat:@"安顿将守护您安全抵达%@!",name];
    
    DbgLog(@"success%@",name);
    
    _safeDestinationPin.subtitle = name;
    _safeStr = name;

    [self showHint:hitStr yOffset:-100];
}
#pragma mark 🌍---普通模式选择好友后
- (void)friendAndGroupViewController:(FriendAndGroupViewController *)sender changeFriendId:(NSString *)friendId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/mongo/findByUnames"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserDic = [userDef objectForKey:@"info"];
    NSDictionary *dic = @{@"rbid":friendId,@"token":UserDic[@"token"]};
    
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        DbgLog(@"好友的坐标－－－－－－－>>>>>>>>》》》》》%@",dic);
        //MAPointAnnotation *friendPin = [[MAPointAnnotation alloc] init];
        
        if(dic[@"data"])
        {
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"data"][0][@"c_ALTIT"] doubleValue], [dic[@"data"][0][@"c_LONGIT"] doubleValue]);
            
            //_animatedCar11 = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
            _animatedCar11.coordinate = coordinate;
            NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
            for (NSInteger i = 1; i < 4; i++) {
                NSString *imageName = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
                CGSize size = CGSizeMake(240, 240);
                UIImage *image1 = [UIImage imageNamed:imageName];
                
                UIImage *image22;
                
                NSString *friendHeadImgstr = [NSString stringWithFormat:@"%@",dic[@"data"][0][@"c_NOTE"]];
                
                if(friendHeadImgstr.length > 6)
                {
                    image22 = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:friendHeadImgstr]]];
                }else
                {
                    image22 = [UIImage imageNamed:@"icon_logo"];
                }
                
                UIImage *image2 = [self circleImage:image22 withParam:0];
                UIGraphicsBeginImageContext(size);
                [image2 drawInRect:CGRectMake(54, 12, 110, 110)];
                [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
                UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                [trainImages1 addObject:resultingImage];
            }
            NSString *codeStr = [NSString stringWithFormat:@"%@",dic[@"code"]];
            
            if([codeStr isEqualToString:@"201"])
            {
                [self showHint:@"正在获取好友位置...." yOffset:-150];
            }else if ([codeStr isEqualToString:@"102"])
            {
                [self showHint:@"好友设置了隐身，正在获取好友最后位置......" yOffset:-150];
            }
            
            [_mapView removeAnnotation:_animatedCar11];
            MACoordinateSpan spanShare = MACoordinateSpanMake(0.002, 0.002);
            MACoordinateRegion reginShare = MACoordinateRegionMake(coordinate, spanShare);
            [_mapView setRegion:reginShare animated:YES];

            
            _animatedCar11.longitude = dic[@"data"][0][@"c_LONGIT"];
            _animatedCar11.latitude = dic[@"data"][0][@"c_ALTIT"];
            _animatedCar11.mainUserId = dic[@"data"][0][@"c_U_ID"];
            
            _animatedCar11.userId = dic[@"data"][0][@"c_U_NICKNAME"];
            _animatedCar11.userLocation = dic[@"data"][0][@"c_PLACE"];
            
            NSString *imageUrl = dic[@"data"][0][@"c_NOTE"];
            if(imageUrl.length > 6)
            {
                _animatedCar11.headImage = dic[@"data"][0][@"c_NOTE"];
                _animatedCar11.currentImageType = 1;
            }else
            {
                _animatedCar11.headImage = @"icon_logo";
            }
            
            _animatedCar11.animatedImages = trainImages1;
            
            [_mapView addAnnotation:_animatedCar11];
            
            [_mapView selectAnnotation:_animatedCar11 animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
    }];
}

- (IBAction)onBtnFriendClcik:(UIButton *)sender {
    
    if(_currentModel == 3)
    {
        if(sender.tag == 100)
        {
//            if(_currentFriend == 0)
//            {
            
//                [self prepareFriendView];
//            }
            NSInteger x = sender.frame.origin.x;
            NSInteger height = sender.frame.size.height;
            
            [self prepareFriendViewWithX:x andHeight:height];
            
            sender.tag = 999;
        }else if (sender.tag == 999)
        {
            
            [_friendView removeFromSuperview];
            sender.tag = 100;
        }
    }
}

#pragma mark ---🎬🎈点击特别关心好友列表

- (void)prepareFriendViewWithX:(NSInteger )x andHeight:(NSInteger) height
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/list"];
    NSUserDefaults *UserDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [UserDef objectForKey:@"info"];
    
    if(userDic)
    {
        DbgLog(@"-------->>>发起好友的网络请求");
        NSDictionary *dic = @{@"token":userDic[@"token"]};
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        
        [MBProgressHUD showHUDAddedTo:window animated:YES];
        
        [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_friendList removeAllObjects];
            
            for (UIView *view in _friendView.subviews) {
                if (view.tag != 100) {
                    [view removeFromSuperview];
                }
            }
            
            DbgLog(@"%s",[responseObject bytes]);
            [MBProgressHUD hideHUDForView:window animated:YES];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSString *strData = [NSString stringWithFormat:@"%@",dic[@"data"]];
            
            if(strData.length == 6) return;
            int i = 0;
            for (NSDictionary *friendDic in dic[@"data"]) {
                if (([friendDic[@"rstatus"] integerValue] == 4)||([friendDic[@"rstatus"] integerValue] == 8)) {
                    FriendList *friendModel = [[FriendList alloc] init];
                    
                    [friendModel setValuesForKeysWithDictionary:friendDic];
                    
                    [_friendList addObject:friendModel];
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                    btn.backgroundColor = [UIColor clearColor];
                    
                    btn.tag = 101 + i;
                    
                    btn.frame = CGRectMake(0, (i + 1) * 45, 35, 35);
                    
                    btn.layer.cornerRadius = btn.frame.size.width / 2;
                    
                    btn.clipsToBounds = YES;
                    
                    [btn addTarget:self action:@selector(onFriendAnotation:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:friendModel.rburl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"2"]];
                    [_friendView addSubview:btn];
                    
                    _currentFriend = 1;
                    i++;
            }
        }
            CGRect rect = _friendView.frame;
            rect = CGRectMake(x, [UIScreen mainScreen].bounds.size.height - height - (_friendList.count + 1) * 45 - 5, 35, 45 * (_friendList.count + 1));
            _friendView.frame = rect;
            
            
            [UIView animateWithDuration:1 animations:^{
                [self.view addSubview:_friendView];
            }];
   
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:window animated:YES];
            DbgLog(@"failure :%@",error.localizedDescription);
        }];
    }else
    {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
//        
//        [self.navigationController pushViewController:loginVC animated:YES];
        return;
        
    }
}

- (IBAction)onBtnAnDunClick:(UIButton *)sender {
#pragma mark 👍点击了右下角安顿的安全设置
    SafeViewController *safeVC = [[SafeViewController alloc] init];
    
    safeVC.localSafeArray = _safePlaceArrays;
    
    safeVC.delegate = self;
    
    _firstInSafe = 90;
    
    [self.navigationController pushViewController:safeVC animated:YES];
}

- (void)safeViewController:(SafeViewController *)safeViewController
{
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
//                                                  message:@"您可以设置安全位置"
//                                                 delegate:self
//                                        cancelButtonTitle:@"好"
//                                        otherButtonTitles:nil, nil];
//    [alert show];
    [self showHint:@"" yOffset:-100];
#pragma mark 🔌 ---从地图选择我的地盘
    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude + 0.02);
    [_mapView removeGestureRecognizer:_mapViewTapGesture];
    MACoordinateSpan span1 = MACoordinateSpanMake(0.08, 0.08);
    MACoordinateRegion regin1 = MACoordinateRegionMake(coordinate1, span1);
    [_mapView setRegion:regin1 animated:YES];
    //newPin = [[MAPointAnnotation alloc] init];
    newPin.coordinate = coordinate1;
    newPin.title = @"我的地盘";
    [_mapView addAnnotation:newPin];
    [_mapView selectAnnotation:newPin animated:YES];
    
}


//在遇到有输入的情况下。由于现在键盘的高度是动态变化的。中文输入与英文输入时高度不同。所以输入框的位置也要做出相应的变化
#pragma mark - keyboardHight

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 键盘隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    DbgLog(@"hight_hitht:%f",kbSize.height);
    
//    if(kbSize.height == 216)
//    {
//        keyboardhight = 0;
//    }
//    else
//    {
//        keyboardhight = 36;
//        //252 - 216 系统键盘的两个不同高度
//    }
    
    [self begainMoveUpAnimation:kbSize.height];
    
}
//键盘升起的时候
-(void)begainMoveUpAnimation:(NSInteger)keyboardh
{
    DbgLog(@"键盘高度%ld",(long)keyboardh);
    int hig=0;
    if (keyboardh>230) {
        hig += 80;
    }
    CGRect a = _gyV.frame;
    
    if ([_whichTouch isEqualToString:@"gyje"]) {//如果是填写金额
        hig += 80;
    }else if([_whichTouch isEqualToString:@"gyms"]){
        hig += 50;
    }
    a.origin.y = SCREEN_HEIGHT - 300 - hig;
    DbgLog(@"y值为:%f",a.origin.y);
    [UIView animateWithDuration:0.3 animations:^{
        _gyV.frame = a;
    }];
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
     self.gyV.frame = CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 300);
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_realTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)updateDictionNary:(NSDictionary *)dic
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSDictionary *dicUrl = @{@"token":userDic[@"token"],@"CUID":userDic[@"userName"],@"CNAME":userDic[@"unickname"],@"CPLACE":dic[@"subtitle"],@"CALTIT":dic[@"latitude"],@"CLONGIT":dic[@"longitude"]};//参数
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/chassis/addChassis"];
    [manager POST:strUrl parameters:dicUrl success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DbgLog(@"ssss%s",[responseObject bytes]);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        
        DbgLog(@"%@",dic[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
    }];
    
}

#pragma mark ---🔌获取通讯录

-(void)tongxunluList{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    [_dataSourceTXL removeAllObjects];
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        NSMutableDictionary *addressBook = [[NSMutableDictionary alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ 电话: %@", nameString, lastNameString];
            }
        }
        [addressBook setValue:[NSString stringWithFormat:@"%@",nameString] forKey:@"userName"];
//        addressBook.userName = nameString;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        [addressBook setValue:[NSString stringWithFormat:@"%@",(__bridge NSString*)value]
 forKey:@"phoneNumber"];
//                        addressBook.phoneNumber = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        [addressBook setValue:[NSString stringWithFormat:@"%@",(__bridge NSString*)value]
                                       forKey:@"userEmail"];
//                        addressBook.userEmail = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后数组中包含所有联系人的信息
        [_dataSourceTXL addObject:addressBook];
    }
    NSLog(@"%@",_dataSourceTXL);
    if (_dataSourceTXL.count > 0) {
        [self getAnDunUseTXL];
    }
}
-(void)getAnDunUseTXL
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"{"];
    int numb=0;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<_dataSourceTXL.count; i++) {
        NSDictionary *model = _dataSourceTXL[i];
        if (([self turePhone:model[@"phoneNumber"]].length == 11 )&& ([[[self turePhone:model[@"phoneNumber"]] substringToIndex:1] isEqualToString:@"1"])) {
            //合成参数用的字符串
            if (numb== 0) {
                [str appendFormat:@"%@:%@",[self turePhone:model[@"phoneNumber"]],model[@"userName"]];
                numb ++;
            }else
            {
                [str appendFormat:@",%@:%@",[self turePhone:model[@"phoneNumber"]],model[@"userName"]];
                numb ++;
            }
            //放在本地数组里
            NSDictionary *dic = @{@"userName":model[@"userName"],@"phoneNumber":[self turePhone:model[@"phoneNumber"]]};
            [arr addObject:dic];
        }
    }
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    NSArray *arrTxl = [[NSArray alloc]initWithArray:arr];
    [udf setObject:arrTxl forKey:@"TongXunLu"];
    //        [udf setValue:arrTxl forKey:@"TongXunLu"];
    [udf synchronize];

    [str appendString:@"}"];
    
    NSLog(@"%@",str);
    [self uploadTXL:str];
}
-(NSString *)turePhone:(NSString *)phone
{
    NSString *retStr = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    retStr = [retStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    retStr = [retStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    retStr = [retStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    retStr = [retStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSLog(@"%@#%@",phone,retStr);
    return retStr;
}
-(void)uploadTXL:(NSString *)txl
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    
    //172.16.0.73:8080/zrwt/mphone/transmitPhone?phones=%7B18311173900=mm%7D&token=JOdXQosF
    NSString *strUrl = @"http://172.16.0.73:8080/zrwt/mphone/transmitPhone";
//    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@""];
    
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSDictionary *udic = [usf objectForKey:@"info"];
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:txl forKey:@"phones"];
    [param setValue:udic[@"token"] forKey:@"token"];
//    NSDictionary *dic = @{@"phones":txl};//参数
    NSLog(@"%@ \n %@",strUrl,param);
    [self showContentInMap];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        NSLog(@"%@",rspDic);
        DbgLog(@"%@",rspDic);
        if ([rspDic[@"code"] integerValue] == 201) {
            
            //先清理以前的东西
            //清理安全模式下的视图和数据
            for (UIView *view in safeView111.subviews) {
                [view removeFromSuperview];
            }
            [safeView111 removeFromSuperview];
            
            //清除普通好友的数据和显示
            [_mapView removeAnnotations:_friendsAnnotations];
            [_friendsAnnotations removeAllObjects];
            [_friendsLocationArray removeAllObjects];
            
            //清除安全模式下的数据和显示
            [_safeStateArray removeAllObjects];
            
            //再添加新刷新出来的东西
            DbgLog(@"%@",rspDic[@"data"]);
            
            for (NSDictionary *friendDic in rspDic[@"data"]) {
                
                NSDictionary *addDic = @{@"latitude":friendDic[@"c_ALTIT"],@"longitude":friendDic[@"c_LONGIT"],@"userId":friendDic[@"c_U_NICKNAME"],@"place":friendDic[@"c_PLACE"],@"headImage":friendDic[@"c_NOTE"],@"CUID":friendDic[@"c_U_ID"],@"Shield":friendDic[@"c_CREDIT"]};
                
                [_friendsLocationArray addObject:addDic];
                
                NSString *c_MODEL = [NSString stringWithFormat:@"%@",friendDic[@"c_MODEL"]];
                
                if(!(c_MODEL.length == 6))
                {
                    //如果处于安全模式，则添加到安全模式的好友数组
                    if([friendDic[@"c_MODEL"] isEqualToString:@"2"])
                    {
                        [_safeStateArray addObject:addDic];
                        
                    }
                }
            }
            if (!safeView111) {
                safeView111 = [[UIView alloc] initWithFrame:CGRectMake( 12, 70, 35, 35)];
            }
            
            safeView111.backgroundColor = [UIColor clearColor];
#pragma mark 🔌--- 显示安全模式下的好友在左上角
            for (NSInteger i = 0; i < _safeStateArray.count; i++) {
                
                NSDictionary *safeDic = _safeStateArray[i];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                btn.frame = CGRectMake(0, i * 40, 35, 35);
                
                btn.layer.cornerRadius = btn.frame.size.width / 2;
                
                btn.clipsToBounds = YES;
                
                btn.tag = 500 + i;
                
                [btn addTarget:self action:@selector(onBtnSafeFriendClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, i*40, 120, 35)];
                label.text = [NSString stringWithFormat:@"%@",safeDic[@"userId"]];
                label.textColor = [UIColor redColor];
                
                NSString *imageStr = [NSString stringWithFormat:@"%@",safeDic[@"headImage"]];
                
                if(imageStr.length > 6)
                {
                    [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_logo"]];
                    
                }else
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"icon_logo"] forState:UIControlStateNormal];
                }
                
                [safeView111 addSubview:btn];
                [safeView111 addSubview:label];
            }
            
            safeView111.frame = CGRectMake( 12, 70, 120, 40 * _safeStateArray.count);
            
            [self.view addSubview:safeView111];
            
#pragma mark 🔌--- 显示好友的位置
            
            if (_currentHireState == 99) {//在雇佣模式下并不处理好友的显示
                return ;
            }
            for (NSInteger i = 0; i < _friendsLocationArray.count; i++) {
                
                NSDictionary *friendsDic = _friendsLocationArray[i];
                
                CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake([friendsDic[@"latitude"] doubleValue], [friendsDic[@"longitude"] doubleValue]);
                
                AnimatedAnnotation * friendAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate2];
                NSMutableArray *trainImages1 = [[NSMutableArray alloc] init];
                for (NSInteger i = 1; i < 4; i++) {
                    NSString *imageName = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
                    NSString *imageName11;
                    
                    if(_currentTag == 104)
                    {
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld.png",(long)i,(long)i,(long)i];
                        
                    }else if (_currentTag == 105)
                    {
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i];
                        
                    }else if (_currentTag == 102)
                    {
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld.png",(long)i,(long)i,(long)i];
                        
                    }else if (_currentTag == 103)
                    {
                        
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
                        
                    }else if (_currentTag == 101)
                    {
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i,(long)i];
                    }else if (_currentTag == 106)
                    {
                        imageName11 = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld.png",(long)i,(long)i,(long)i,(long)i,(long)i];
                        
                    }
                    
                    CGSize size = CGSizeMake(240, 240);
                    UIImage *image1 = [UIImage imageNamed:imageName];
                    UIImage *image22;
                    
                    
                    NSString *friendHeadImgstr = [NSString stringWithFormat:@"%@",friendsDic[@"headImage"]];
                    
                    if(friendHeadImgstr.length > 6)
                    {
                        image22 = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:friendHeadImgstr]]];
                        friendAnnotation.headImage = friendsDic[@"headImage"];
                        friendAnnotation.currentImageType = 1;
                    }else
                    {
                        image22 = [UIImage imageNamed:@"icon_logo"];
                    }
                    UIImage *image2 = [self circleImage:image22 withParam:0];
                    UIGraphicsBeginImageContext(size);
                    [image2 drawInRect:CGRectMake(54, 12, 110, 110)];
                    [image1 drawInRect:CGRectMake(40, 0, 140, 210)];
                    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                    [trainImages1 addObject:resultingImage];
                }
                friendAnnotation.longitude = friendsDic[@"longitude"];
                friendAnnotation.latitude = friendsDic[@"latitude"];
                friendAnnotation.mainUserId = friendsDic[@"CUID"];
                friendAnnotation.shield = [NSString stringWithFormat:@"%@",friendsDic[@"Shield"]];
                
                friendAnnotation.animatedImages = trainImages1;
                friendAnnotation.userId = friendsDic[@"userId"];
                friendAnnotation.userLocation = friendsDic[@"place"];
                friendAnnotation.headImage = friendsDic[@"headImage"];
                [_friendsAnnotations addObject:friendAnnotation];
            }
            [self.mapView addAnnotations:_friendsAnnotations];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark ---🔌在地图上显示通讯录的好友
-(void)showContentInMap
{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [usf objectForKey:@"TongXunLu"];
    for (NSDictionary *dic in arr) {
        NSLog(@"%@:%@",dic[@"userName"],dic[@"phoneNumber"]);
    }
    
}



@end
