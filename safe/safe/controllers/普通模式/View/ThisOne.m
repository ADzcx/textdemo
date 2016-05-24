//
//  ThisOne.m
//  safe
//
//  Created by 薛永伟 on 15/10/10.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "ThisOne.h"
#import "FriendDetailViewController.h"
#import "Manager.h"
#import "ChatViewController.h"
#import "SelectJingXiView.h"
#import <AMapNaviKit/MAMapKit.h> //高德地图的头文件

@implementation ThisOne
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        
        
        Manager *manager = [Manager manager];
        
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(manager.mainView.localCoordinate.latitude ,manager.mainView.localCoordinate.longitude));
        MAMapPoint point2;
        
        if(_latitude && _longitude)
        {
            point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([_latitude doubleValue],[_longitude doubleValue]));
        //2.计算距离
        }else
        {
            point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(manager.mainView.localCoordinate.latitude, manager.mainView.localCoordinate.longitude));
        }
        
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        
        DbgLog(@"%f  %f  %f",distance,manager.mainView.localCoordinate.longitude,manager.mainView.localCoordinate.latitude);
        
        self.userDistance.text = [NSString stringWithFormat:@"距离:%.2f",distance / 500];
        
        self.driveRange.text = [NSString stringWithFormat:@"车程:%.2f",(distance / 500) / 60];
        
        
        DbgLog(@"hahahhahah   %f",distance);
        
    }
    return self;
}



- (IBAction)onBtnDetailFriendClick:(UIButton *)sender {
    
    FriendDetailViewController *perVC = [[FriendDetailViewController alloc] initWithNibName:@"FriendDetailViewController" bundle:nil];
    
    perVC.chatterName = self.userId;
    
    Manager *manager = [Manager manager];
    
    [manager.mainView.navigationController pushViewController:perVC animated:YES];
    
}

- (IBAction)onBtnFriendChatClick:(UIButton *)sender {
    
    NSUserDefaults *usdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [usdef objectForKey:@"info"];
    
    if ([userdic[@"uid"] isEqualToString:self.userName.text]) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"不能和自己聊天" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
        return;
    }
    
    ChatViewController *ctvc = [[ChatViewController alloc]initWithChatter:self.userId isGroup:NO];
    ctvc.title = self.userName.text;
    ctvc.rbHeadImgUrl = self.headImageUrl;
    Manager *manager = [Manager manager];
    
    [manager.mainView.navigationController pushViewController:ctvc animated:YES];
    
    //ctvc.rauth = friendModel.rauth;
    
}

- (IBAction)onBtnRouteClick:(UIButton *)sender {
    DbgLog(@"hahahahhaha ------  》》》》》》》");
    Manager *manager = [Manager manager];
    
    //_lastCoordinate = CLLocationCoordinate2DMake([dic[@"data"][0][@"c_ALTIT"] doubleValue], [dic[@"data"][0][@"c_LONGIT"] doubleValue]);
    NSUserDefaults *usdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [usdef objectForKey:@"info"];
    
    if ([userdic[@"unickname"] isEqualToString:self.userName.text]) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"不能对自己导航" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
        return;
    }
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
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

- (IBAction)onBtnTelePhoneClick:(UIButton *)sender {
    
    NSUserDefaults *usdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userdic = [usdef objectForKey:@"info"];
    
    if ([userdic[@"unickname"] isEqualToString:self.userName.text]) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"不能对自己打电话" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alv show];
        return;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.userId];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    Manager *manager = [Manager manager];
    
    [manager.mainView.view addSubview:callWebview];
}

- (IBAction)onJingXiClick:(UIButton *)sender {
    if (!_JXView) {
        _JXView = [[[NSBundle mainBundle]loadNibNamed:@"SelectJingXiView" owner:self options:nil]lastObject];
        _JXView.frame = CGRectMake(10, self.bounds.size.height-45,200, 40);
        _JXView.userId = _userId;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEpt:)];
        [self addGestureRecognizer:tap];
    }
    
    [self addSubview:_JXView];
}
-(void)tapEpt:(UITapGestureRecognizer *)sender
{
    [_JXView removeFromSuperview];
}



@end
