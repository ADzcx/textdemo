
//  AppDelegate.m
//  safe
//
//  Created by 薛永伟 on 15/9/6.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuNaviController.h"
#import "RootNaviController.h"
//#import "ApplyViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "APPHeader.h"
#import "CoreUMeng.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"
#import "GetZhaoJiView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Manager.h"
#import "GetZhaoJiView.h"
#import "GetGyView.h"
#import "MyGuYongView.h"
#import "NewFriendsTableViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "BBLaunchAdMonitor.h"

@interface AppDelegate ()<IChatManagerDelegate,UIAlertViewDelegate>

@end

@implementation AppDelegate
{
    NSInteger _currenttype;
    CLLocationCoordinate2D _lastCoordinate;  //追随好友监听上一次经纬度
    NSString *friendUId;  //追随好友的Id

    UIScrollView *scrView;
    UIImageView *_flashView;
    
    //以下是用来播放互动动画的
    UIWebView *webView1;
    NSMutableArray *gifArr;
    BOOL isPlaying;

}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
#pragma mark 📧程序没有运行时收到推送会在这里处理
    DbgLog(@"获取到的通知:%@",remoteNotification);
    if (remoteNotification) {
        //震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    RootNaviController *center = [sb instantiateInitialViewController];
    
    MenuNaviController *left = [sb instantiateViewControllerWithIdentifier:@"MenuNaviController"];
    XTSideMenu *mn = [[XTSideMenu alloc]initWithContentViewController:center leftMenuViewController:left rightMenuViewController:nil];
    
    
    [CoreUMeng umengSetAppKey:UmengAppKey];
    
    [CoreUMeng umengSetSinaSSOWithRedirectURL:@"http://www.baidu.com"];
    //集成微信
    [CoreUMeng umengSetWXAppId:WXAPPID appSecret:WXAPPsecret url:WXUrl];
    //集成QQ
    [CoreUMeng umengSetQQAppId:@"100424468" appSecret:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.baidu.com"];
    
    
    self.window.rootViewController = mn;
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [SMS_SDK registerApp:@"8d9de070fad8" withSecret:@"f26f47e3214c004734e30e76c5d26346"];
    
    //registerSDKWithAppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"zhirongweituo2015#safe" apnsCertName:@"zrwtSafeAPNS" otherConfig:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    //    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    [self registerEaseMobNotification];
    [self setupNotifiers];
//    注册极光服务
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    else{
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
//    互动动画效果
    gifArr = [[NSMutableArray alloc]init];
    isPlaying = NO;
    
    // Required
    [APService setupWithOption:launchOptions];
    //集成讯飞
     [self configIFlySpeech];
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    if ([userDef objectForKey:@"info"]) {
        NSDictionary *userDic = [userDef objectForKey:@"info"];
        DbgLog(@"读取本地的user default %@",userDic);
        DbgLog(@"已存在info用户信息，将会自动登录:%@:%@",userDic[@"uid"],userDic[@"HXPWD"]);
        BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
        if (!isAutoLogin) {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userDic[@"uid"]
                                                                password:userDic[@"HXPWD"]
                                                              completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                  if (!error) {
                                                                      DbgLog(@"登录成功");
                                                                  }else
                                                                  {
                                                                      DbgLog(@"登录失败:%@",error.description);
                                                                  }
                                                              } onQueue:nil];
        }
    }else
    {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
//        Manager *mag = [Manager manager];
//        [mag.mainView.navigationController pushViewController:loginVC animated:YES];
    }
    //设置
   
    //进来后清楚所有角标。
    [APService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
 
    return YES;
}

- (void)configIFlySpeech
{
    
    [AMapNaviServices sharedServices].apiKey = @"4f7adad030250716702a9e9ac3a9901a";
    
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",@"5565399b",@"20000"]];
    
    [IFlySetting setLogFile:LVL_NONE];
    [IFlySetting showLogcat:NO];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    
    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
}

#pragma mark 🔌---极光的相关设置
//极光注册远程推送
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [APService registerDeviceToken:deviceToken];
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *uerDic = [userDef objectForKey:@"info"];
    if (uerDic) {
        DbgLog(@"极光推送设置别名:%@",uerDic[@"userName"]);
        [APService setAlias:uerDic[@"userName"] callbackSelector:nil object:nil];
        
    }
    
}
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DbgLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    DbgLog(@"收到通知:%@", [self logDic:userInfo]);
}
#pragma mark 📧程序运行时收到推送会在这里处理
//收到发送的通知
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if (![userDef objectForKey:@"info"]) {
        return;
    }
#pragma mark 🔌---收到推送进行处理
    DbgLog(@"fetchCompletionHandler 收到通知:%@", [self logDic:userInfo]);
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    Manager *safMng = [Manager manager];
    [safMng.mainView prepareLefBarBtn:1];
    [safMng.menuVC.xiaoxiBiao setImage:[UIImage imageNamed:@"xiaoxidian"]];
    
    NSDictionary *aps = userInfo[@"aps"];
    if ([userInfo[@"option"] isEqualToString:@"make-friend-request"]) {//添加好友请求
        
        NewFriendsTableViewController *nfVC = [[NewFriendsTableViewController alloc]init];
        
        [safMng.mainView.navigationController pushViewController:nfVC animated:YES];
        
    }else if ([userInfo[@"option"] isEqualToString:@"bpa"])
    {
#pragma mark 🎈报平安
        
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"安顿报平安" message:aps[@"alert"][@"body"] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alv show];
    }
#pragma mark 🎈追随通知
    if (userInfo[@"follow"]) {//追随
        if ([userInfo[@"follow"] isEqualToString:@"0"]) {//请求
            [NSString stringWithFormat:@"%@发来追随请求",userInfo[@"UNICKNAME"]];
            UIAlertView *a = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@要追随您！",userInfo[@"UNICKNAME"]] message:[NSString stringWithFormat:@"是否同意手机号为%@的好友追随您？",userInfo[@"UID"]] delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意",nil];
            a.tag = 100;
            [a show];
        }else if ([userInfo[@"follow"] isEqualToString:@"1"])//拒绝
        {
            UIAlertView *a = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@拒绝了您的追随请求！",userInfo[@"UNICKNAME"]] message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
            a.tag = 101;
            [a show];
        }else if ([userInfo[@"follow"] isEqualToString:@"2"])//同意
        {
            ;
            UIAlertView *a = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@同意了您的追随请求！",userInfo[@"UNICKNAME"]] message:[NSString stringWithFormat:@"是否立即前往手机号为%@的用户所在位置？",userInfo[@"UID"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往",nil];
            a.tag = 102;
            [a show];
        }
    }
#pragma mark 🎈召集的反馈
    if ([userInfo[@"option"] isEqualToString:@"goto"]) {//立即前往
        NSString *msg = [NSString stringWithFormat:@"%@",aps[@"alert"][@"body"]];
        [safMng.mainView showHint:msg yOffset:-100];
        
    }else if ([userInfo[@"option"] isEqualToString:@"confirm"]){//确认
        NSString *msg = [NSString stringWithFormat:@"%@",aps[@"alert"][@"body"]];
        [safMng.mainView showHint:msg yOffset:-100];
    }else if ([userInfo[@"option"] isEqualToString:@"ignore"]){//忽略
        NSString *msg = [NSString stringWithFormat:@"%@",aps[@"alert"][@"body"]];
        [safMng.mainView showHint:msg yOffset:-100];
    }
#pragma mark 🎈雇佣通知
    if ([userInfo[@"option"] isEqualToString:@"hirer-send-invite"]) {//雇佣
        
        DbgLog(@"接到雇用推送 ------->>>>>>sbsbsbsbbsbs");
        [self didGetGuYong:userInfo[@"orderId"]];
    }
#pragma mark 🎈召集通知
    if ([userInfo[@"option"] isEqualToString:@"muster-request"]) {//召集
        
        NSString *musterId = [NSString stringWithFormat:@"%@",userInfo[@"musterId"]] ;
        [self didGetZhaoji:musterId];
        
    }
#pragma mark 🎈雇佣接单通知
    if ([userInfo[@"option"] isEqualToString:@"hire-be-take"]) {
        NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"orderId"]];
        [self didGetJiedan:orderId who:userInfo[@"nickName"] userId:userInfo[@"userId"]];
    }
#pragma mark 🎈雇佣单已取消通知
    if ([userInfo[@"option"] isEqualToString:@"hire-be-terminal"]) {
//        NSString *orderId = [NSString stringWithFormat:@"%@",userInfo[@"orderId"]];
        NSString *alerStr = aps[@"alert"][@"body"];
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"订单已被取消" message:alerStr delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
    }
#pragma mark 🎈安全模式提醒通知
    if ([userInfo[@"option"] isEqualToString:@"safe-model-exceed-max-time"]) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"未按时到达" message:@"您开启了安全模式，但未按时到达目的地。若不需要安顿继续为您服务，请退出安全模式，否则稍后我们将会向您的朋友发送求助信息。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
    }
    if ([userInfo[@"option"] isEqualToString:@"safe-model-warn20"]) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"停留时间过长！" message:@"您在此停留时间过长，若不需要安顿继续为您服务，请退出安全模式。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
    }
    if ([userInfo[@"option"] isEqualToString:@"safe-model-warn20"]) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"停留时间过长！" message:@"您在此停留时间过长，若不需要安顿继续为您服务，请退出安全模式否则稍后我们将会向您的朋友发送求助信息。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
    }
#pragma mark 🎈我的地盘提醒
    if ([userInfo[@"option"] isEqualToString:@"land"]) {
         NSString *alerStr = aps[@"alert"][@"body"];
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:aps[@"alert"][@"title"] message:alerStr delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
    }
#pragma mark 🎈相册有新动态
    if ([userInfo[@"option"] isEqualToString:@"new-comment"]) {
        Manager *safMng = [Manager manager];
        [safMng.mainView prepareLefBarBtn:1];
        [safMng.menuVC.xiangceBiao setImage:[UIImage imageNamed:@"xiangcedian"]];
    }
#pragma mark 🎈好友发来的互动动画gif
    if ([userInfo[@"option"] isEqualToString:@"gif"]) {
        NSString *type = userInfo[@"type"];
        [self playGif:type.intValue];
    }
#pragma mark 🎈出行模式开启后推送的天气信息
    if ([userInfo[@"option"] isEqualToString:@"chuxing-tianqi"]) {
        Manager *safMng = [Manager manager];
        [safMng.mainView prepareLefBarBtn:1];
        NSDictionary *tqAlert = aps[@"alert"];
        NSString *TqMsg = tqAlert[@"body"];
        NSArray *tqAr = [TqMsg componentsSeparatedByString:@","];
        NSString *showTqStr = [NSString stringWithFormat:@"%@:%@ %@ %@",tqAr[0],tqAr[1],tqAr[2],tqAr[3]];
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"天气提醒" message:showTqStr delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
//        [safMng.mainView showHint:showTqStr yOffset:-100];
    }
    
       completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark ---🎬收到互动的惊喜动画
-(void)playGif:(int)type
{
    NSTimeInterval i = 0;
    NSData *gif = nil;
    if (type == 0) {
        gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hua" ofType:@"gif"]];
        i = 2;
    }else if (type == 1){
        gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"poshui" ofType:@"gif"]];
        i = 2;
    }else if (type == 2){
        gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"xiangsinile" ofType:@"gif"]];
        i = 2.5;
    }else if (type == 3){
        gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zhadan" ofType:@"gif"]];
        i = 2.3;
    }else
    {
        
    }
    NSDictionary *dic = @{@"gif":gif,@"time":[NSString stringWithFormat:@"%f",i]};
    [gifArr addObject:dic];
    //播放i秒后执行play方法
    NSLog(@"%lu",(unsigned long)gifArr.count);
    if (isPlaying == NO) {
        [self play];
    }
}
-(void)play
{
    NSLog(@"%lu",(unsigned long)gifArr.count);
    //播放之前先清楚
    if (webView1) {
        [webView1 removeFromSuperview];
    }
    if (!webView1) {
        CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2 - [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        webView1 = [[UIWebView alloc]initWithFrame:frame];
    }
    webView1.backgroundColor = [UIColor clearColor];
    webView1.opaque = NO;
    webView1.userInteractionEnabled = NO;
    
    //如果有动画就播放
    if (gifArr.count > 0) {
        isPlaying = YES;
        NSDictionary *dic = gifArr[0];
        NSString *time = dic[@"time"];
        NSTimeInterval i = time.doubleValue;
        Manager *mng = [Manager manager];
        
        [webView1 loadData:dic[@"gif"] MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        NSLog(@"bo fang");
        [mng.mainView.view addSubview:webView1];
        [self performSelector:@selector(loadNextGif) withObject:nil afterDelay:i];
    }else
    {
        isPlaying = NO;
    }
}
-(void)loadNextGif
{
    NSLog(@"befor %lu",(unsigned long)gifArr.count);
    [gifArr removeObjectsAtIndexes:[[NSIndexSet alloc]initWithIndex:0]];
    NSLog(@"after %lu",(unsigned long)gifArr.count);
    NSLog(@"loadNext");
    [self play];
}


-(void)didGetJiedan:(NSString *)orderId who:(NSString *)name userId:(NSString *)userId
{
//xxx.xxx.xxx.xxx:port/zrwt/hire/detail/get?token=xxx&orderId=xxx
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/hire/detail/get"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    Manager *mng = [Manager manager];

    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:orderId forKey:@"orderId"];

    [param setValue:[NSString stringWithFormat:@"%@",mng.mainView.localAddress] forKey:@"pos"];
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        if (rspDic[@"data"]) {
            NSDictionary *jdInfo = rspDic[@"data"];
            MyGuYongView *mgyV = [[[NSBundle mainBundle]loadNibNamed:@"MyGuYongView" owner:self options:nil]lastObject];
            mgyV.frame = CGRectMake(0, 64, SCREEN_WIDTH, 145);
            mgyV.clipsToBounds = YES;
            mgyV.layer.cornerRadius = 8;
            mgyV.jdNameLabel.text = name;
            mgyV.UserId = userId;
            
            mgyV.jdContentTextView.text = [NSString stringWithFormat:@"%@",jdInfo[@"hdesc"]];
            mgyV.jdJELabel.text = [NSString stringWithFormat:@"%@元",jdInfo[@"hmoney"]];
            NSString *headUrl = [NSString stringWithFormat:@"%@",jdInfo[@"haudiourl"]];
            [mgyV.jdHeadImgView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"icon_logo"]];
            
            [mng.mainView.view addSubview:mgyV];
            [mng.mainView.view bringSubviewToFront:mgyV];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
       
    }];
}

-(void)didGetZhaoji:(NSString *)musterId
{
//xxx.xxx.xxx.xxx:port/zrwt/aux/muster/get?token=xxx&musterId=xxx
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/muster/get"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:musterId forKey:@"musterId"];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        if ([rspDic[@"code"] integerValue] == 201) {
            DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
            
            NSDictionary *zjDic = rspDic[@"data"][0];
            
            Manager *manager = [Manager manager];
            
            GetZhaoJiView *zjView = [[[NSBundle mainBundle]loadNibNamed:@"GetZhaoJiView" owner:self options:nil]lastObject];
            
            zjView.frame = CGRectMake(20, 64, SCREEN_WIDTH-40, 310);
            zjView.layer.cornerRadius = 8;
            zjView.clipsToBounds = YES;
            zjView.lontd = zjDic[@"longitude"];
            zjView.alutd = zjDic[@"altitude"];
            
            if ([zjDic[@"launchUserName"] isEqualToString:@""]) {
                zjView.userNaleLabel.text = [NSString stringWithFormat:@"%@发起召集!",zjDic[@"launchUserId"]];
            }else
            {
                zjView.userNaleLabel.text = [NSString stringWithFormat:@"%@发起召集!",zjDic[@"launchUserName"]];
            }
            NSString *timeStr = [NSString stringWithFormat:@"%@",zjDic[@"gatherTime"]];
            zjView.timeLabel.text = [timeStr substringToIndex:16];
            zjView.zhutiLabel.text = [self getTrueNote:zjDic[@"note"]];
            zjView.didianLabel.text = zjDic[@"gatherPlace"];
            zjView.zhaojiId = zjDic[@"musterId"];
            [manager.mainView.view addSubview:zjView];
            [manager.mainView.view bringSubviewToFront:zjView];
            NSString *headImgUrl = [NSString stringWithFormat:@"%@",zjDic[@"launchUserIco"]];
            [zjView.headImageView sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed:@"icon_logo"]];

            
            
            if ([NSString stringWithFormat:@"%@",zjDic[@"imageUrl"]].length > 7) {
                NSString *ptUrl = [self getTrueImage:zjDic[@"imageUrl"]];
                if (ptUrl.length > 2) {
                    [zjView.photoImageView sd_setImageWithURL:[NSURL URLWithString:ptUrl] placeholderImage:[UIImage imageNamed:@"3.jpg"]];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        
    }];
    
}
#pragma mark 收到雇用通知
-(void)didGetGuYong:(NSString *)musterId
{
//xxx.xxx.xxx.xxx:port/zrwt/hire/detail/get?token=xxx&orderId=xxx
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/hire/detail/get"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:musterId forKey:@"orderId"];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        if ([rspDic[@"code"] integerValue] == 201 ) {
            NSDictionary *gyInfo = rspDic[@"data"];
            Manager *gymanager = [Manager manager];
            
            GetGyView *gyView = [[[NSBundle mainBundle]loadNibNamed:@"GetGyView" owner:self options:nil]lastObject];
            
            gyView.frame = CGRectMake(20, 64, SCREEN_WIDTH-40, 280);
            NSString *gyNickName = [NSString stringWithFormat:@"%@",gyInfo[@"hunickname"]];
            if ([gyNickName isEqualToString:@"<null>"]) {
                gyView.gyTitleLabel.text = [NSString stringWithFormat:@"%@发布的雇佣单",gyInfo[@"huid"]];
                
            }else
            {
                gyView.gyTitleLabel.text = [NSString stringWithFormat:@"%@发布的雇佣单",gyInfo[@"hunickname"]];
            }
            gyView.gyMiaoshuTextLabel.text =[NSString stringWithFormat:@"%@",gyInfo[@"hdesc"]];
            ;
            NSString *dateStr = [NSString stringWithFormat:@"%@",gyInfo[@"hsdate"]];
                                 
            gyView.gyTimeLabel.text = [NSString stringWithFormat:@"%@",[dateStr substringToIndex:16]];
            
            gyView.gyJineLabel.text = [NSString stringWithFormat:@"%@元",gyInfo[@"hmoney"]];
            gyView.gyId = [NSString stringWithFormat:@"%@",gyInfo[@"hid"]];
            gyView.gzId = [NSString stringWithFormat:@"%@",gyInfo[@"huid"]];
            if ([NSString stringWithFormat:@"%@",gyInfo[@"hurl"]].length>10) {
                NSString *gyhurlSB = [NSString stringWithFormat:@"%@",gyInfo[@"hurl"]];
                NSArray *ar = [gyhurlSB componentsSeparatedByString:@";"];
                NSString *gyhurl = [NSString stringWithFormat:@"%@%@",ar[0],ar[1]];
                if (gyhurl.length > 10) {
                    [gyView.gyPhotoImgView sd_setImageWithURL:[NSURL URLWithString:gyhurl] placeholderImage:[UIImage imageNamed:@"icon_logo"]];
                }
            }
            
            [gymanager.mainView.view addSubview:gyView];
            [gymanager.mainView.view bringSubviewToFront:gyView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        
    }];

    
}

-(NSString *)getTrueNote:(NSString *)sbNote
{
    NSArray *ar = [sbNote componentsSeparatedByString:@"集合地点地图"];
    DbgLog(@"分割后得到的数组:%@",ar);
    return ar[0];
}
-(NSString *)getTrueImage:(NSString *)sbImage
{
    
    NSArray *ar = [sbImage componentsSeparatedByString:@";"];
    NSString *retStr = [NSString stringWithFormat:@"%@%@",ar[0],ar[1]];
    DbgLog(@"返回的数据是 %@",retStr);
    return retStr;
}

#warning 追随请求都在这里请求
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DbgLog(@"叮咚 －－ %@", alertView.message);
    
    if (alertView.tag == 100) {//收到追随请求
        NSString *uidStr = [alertView.message substringWithRange:NSMakeRange(8, 11)];
        DbgLog(@"截取到手机号:%@",uidStr);
        if (buttonIndex == 0) {//拒绝
            [self DefinFriendsFollowReq:uidStr];
        }else//同意
        {
            [self AgreeFriendsFollowReq:uidStr];
        }
    }else if (alertView.tag == 101){//发起的追随请求被拒绝
    
    }else if (alertView.tag == 102){//发起的追随被同意
        
        NSString *uidStr = [alertView.message substringWithRange:NSMakeRange(10, 11)];
        DbgLog(@"截取到手机号:%@",uidStr);
        
        if (buttonIndex == 1) {
            
            friendUId = uidStr;
            
            [self customNaviWithFriendId:uidStr];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:100 target:self selector:@selector(refreshNavi) userInfo:nil repeats:YES];
            
        }
        
    }else if (alertView.tag == 102){//召集稍后提示
        if (buttonIndex == 0) {
            NSLog(@"000");
        }else
        {
            
        }
    }else if (alertView.tag == 88){//别处登录弹出后点击退出登录
        NSUserDefaults *userDeftc = [NSUserDefaults standardUserDefaults];
        [userDeftc removeObjectForKey:@"info"];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
        Manager *mag = [Manager manager];
        [mag.mainView.navigationController pushViewController:loginVC animated:YES];
    }
    
}

- (void)refreshNavi
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/mongo/findByUnames"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserDic = [userDef objectForKey:@"info"];
    NSDictionary *dic = @{@"rbid":friendUId,@"token":UserDic[@"token"]};
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        DbgLog(@"好友的坐标－－－－－－－>>>>>>>>》》》》》%@",dic);
        //MAPointAnnotation *friendPin = [[MAPointAnnotation alloc] init];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"data"][0][@"c_ALTIT"] doubleValue], [dic[@"data"][0][@"c_LONGIT"] doubleValue]);
        
        Manager *manager = [Manager manager];
        if(_lastCoordinate.latitude != coordinate.latitude  || _lastCoordinate.longitude != coordinate.longitude)
        {
            [manager.mainView refreshNewNavi];
            
            _lastCoordinate = CLLocationCoordinate2DMake([dic[@"data"][0][@"c_ALTIT"] doubleValue], [dic[@"data"][0][@"c_LONGIT"] doubleValue]);
            
            
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
            
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
    }];

    

}

- (void)customNaviWithFriendId:(NSString *)friendId
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
        
        
        [_timer setFireDate:[NSDate distantFuture]];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"data"][0][@"c_ALTIT"] doubleValue], [dic[@"data"][0][@"c_LONGIT"] doubleValue]);
        
        Manager *manager = [Manager manager];
        
        _lastCoordinate = CLLocationCoordinate2DMake([dic[@"data"][0][@"c_ALTIT"] doubleValue], [dic[@"data"][0][@"c_LONGIT"] doubleValue]);
        
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
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
    }];
    
}

//同意好友的追随请求
-(void)AgreeFriendsFollowReq:(NSString *)userBid
{
    DbgLog(@"得到的id = %@",userBid);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/follow/FollowUserAgree"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:userBid forKey:@"UID"];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        
    }];
}
//拒绝好友的追随请求
-(void)DefinFriendsFollowReq:(NSString *)userBid
{
    DbgLog(@"得到的id = %@",userBid);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/follow/FollowUserEnd"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:userBid forKey:@"UID"];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        
    }];
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:@"ADMIN"];
    NSDictionary *usInfo = notification.userInfo;

//    说明本地通知是再次添加的提醒.
    if ([usInfo[@"option"] isEqualToString:@"muster-request"]) {
        Manager *manager = [Manager manager];
        GetZhaoJiView *zjView = [[[NSBundle mainBundle]loadNibNamed:@"GetZhaoJiView" owner:self options:nil]lastObject];
        
        //        zjView.zhutiLabel.text = userInfo[@""];
        
        zjView.frame = CGRectMake(20, 64, SCREEN_WIDTH-40, 310);
        zjView.ZJuserInfo = usInfo;
        [manager.mainView.view addSubview:zjView];
        [manager.mainView.view bringSubviewToFront:zjView];
    }
    DbgLog(@"收到本地通知");
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [CoreUMeng umengHandleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [CoreUMeng umengHandleOpenURL:url];
}


- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}
- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}
#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[EaseMob sharedInstance] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataWillBecomeUnavailable:notif.object];
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataDidBecomeAvailable:notif.object];
}
-(void)didLoginFromOtherDevice
{
    [self logOut];
    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"您的帐号已在别处登录！" message:@"若不是本人登录，请及时修改密码。" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
    alv.tag = 88;
    [alv show];
}
-(void)logOut
{
    Manager *mng = [Manager manager];
    ViewController *vc = mng.mainView;
    [vc friendReal];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/login/getQuit"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:@"2" forKey:@"uonline"];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        [mng.mainView showHint:@"退出成功！" yOffset:-100];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        
    }];
    
    [APService setAlias:@"ios" callbackSelector:nil object:nil];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            DbgLog(@"退出成功");
        }
    } onQueue:nil];
    
    [APService setAlias:@"ios" callbackSelector:nil object:nil];
    
    //需要清楚地图所有的坐标。
    [mng.mainView.mapView removeAnnotations:mng.mainView.mapView.annotations];
    
    [userDef removeObjectForKey:@"info"];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"Login"];
    
    [mng.mainView.navigationController pushViewController:loginVC animated:YES];

}
-(void)didReceiveMessage:(EMMessage *)message
{
    DbgLog(@"收到消息:%@",message);
    Manager *safMng = [Manager manager];
    [safMng.mainView prepareLefBarBtn:1];
    [safMng.menuVC.haoyouBiao setImage:[UIImage imageNamed:@"xiaoxidian"]];
    NSMutableString *pushStr = [NSMutableString stringWithFormat:@"%@:",message.from];
    id<IEMFileMessageBody>fileBody = (id<IEMFileMessageBody>)[message.messageBodies firstObject];
    if ([fileBody messageBodyType] == eMessageBodyType_Image) {
        [pushStr appendString:@"发来一张图片"];
    }else if([fileBody messageBodyType] == eMessageBodyType_Video){
        [pushStr appendString:@"发来一个视频"];
    }else if([fileBody messageBodyType] == eMessageBodyType_Voice){
        [pushStr appendString:@"发来一段语音"];
    }if([fileBody messageBodyType] == eMessageBodyType_Text){
        EMTextMessageBody *msg = (EMTextMessageBody *)fileBody;
        [pushStr appendString:msg.text];
    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
    }else
    {
        NSString *infk = [NSString stringWithFormat:@"HXmsg"];
        if ([message.from isEqualToString:@"admin"]) {
            infk = @"ADMIN";
        }
        [APService setLocalNotification:[[NSDate date] dateByAddingTimeInterval:0.5] alertBody:pushStr badge:1 alertAction:nil identifierKey:infk userInfo:nil soundName:nil];
    }

}


@end
