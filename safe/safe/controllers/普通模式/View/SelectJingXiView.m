//
//  SelectJingXiView.m
//  safe
//
//  Created by 薛永伟 on 15/11/11.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "SelectJingXiView.h"
#import "Manager.h"

@implementation SelectJingXiView
{
    UIWebView *webView1;
    NSMutableArray *gifArr;
    BOOL isPlaying;
}
-(void)awakeFromNib
{
    isPlaying = NO;
    gifArr = [[NSMutableArray alloc]init];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)onHuaClick:(UIButton *)sender {
    NSLog(@"1111111111");
    [self sendJingXi:0];
}
- (IBAction)onShuiClick:(UIButton *)sender {
    [self sendJingXi:1];
}
- (IBAction)onXinClick:(UIButton *)sender {
    [self sendJingXi:2];
}
- (IBAction)onZhaClick:(UIButton *)sender {
    [self sendJingXi:3];
}


-(void)sendJingXi:(int)type
{
    NSLog(@"send to -> %@ a %d",_userId,type);
//    token 用户token
//    type 动画类 0，送花 1，泼水2，我好想你3，丢炸弹
//    fid 好友id；
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSDictionary *dic = @{@"token":userDic[@"token"],@"type":[NSString stringWithFormat:@"%d",type],@"fid":_userId};//参数
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/gif/jpushGif"];
    NSLog(@"%@ \n %@",strUrl,dic);
    
    [manager POST:strUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        
        if ([rspDic[@"code"] integerValue] == 200) {
            [self playGif:type];
        }else if ([rspDic[@"code"] integerValue] == 102){
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        DbgLog(@"获取网络位置failure :%@",error.localizedDescription);
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

#pragma mark ---🎬互动的惊喜动画
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
    [self CountOfJingXI];
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
//获取服务器上的剩余次数
-(void)CountOfJingXI
{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *udic = [usf objectForKey:@"info"];
    
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


@end
