//
//  MyGuYongView.m
//  safe
//
//  Created by 薛永伟 on 15/10/13.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "MyGuYongView.h"
#import "Manager.h"
#import "ChatViewController.h"
#import "DYWCView.h"

@implementation MyGuYongView
{
    DYWCView *_view;
}
- (IBAction)onDHClick:(UIButton *)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_UserId];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    UIWindow *window = [[[UIApplication sharedApplication]windows]lastObject];
    [window addSubview:callWebview];
    
}
- (IBAction)onCloseClick:(UIButton *)sender {
    
    _view = [[[NSBundle mainBundle]loadNibNamed:@"DoYouWantCloseView" owner:self options:nil]lastObject];
    _view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_view];
    _view.userInteractionEnabled = YES;
    _view.quxiao.userInteractionEnabled = YES;
    _view.buquxiao.userInteractionEnabled = YES;
    [_view.quxiao addTarget:self action:@selector(onQuXiaoClick:) forControlEvents:UIControlEventTouchUpInside];
    [_view.buquxiao addTarget:self action:@selector(onBuQuXiaoClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)onQuXiaoClick:(UIButton *)sender
{
    //xxx.xxx.xxx.xxx:port/zrwt/hire/job/cancel?token=xxx&orderId=xxx&note=xxx
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/hire/job/cancel"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    [_view removeFromSuperview];
    [self removeFromSuperview];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_OrderId forKey:@"orderId"];
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        
    }];
    
}
-(void)onBuQuXiaoClick:(UIButton *)sender
{
    [_view removeFromSuperview];
    [self removeFromSuperview];
    
}
- (IBAction)chatWith:(UIButton *)sender {
    DbgLog(@"userId :%@",_UserId);
    ChatViewController *ctv = [[ChatViewController alloc]initWithChatter:_UserId isGroup:NO];
    Manager *mng = [Manager manager];
    [mng.mainView.navigationController pushViewController:ctv animated:YES];
}


@end
