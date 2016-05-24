//
//  GetZhaoJiView.m
//  safe
//
//  Created by 薛永伟 on 15/10/6.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "GetZhaoJiView.h"
#import "ZjZCTXView.h"
#import "Manager.h"

@implementation GetZhaoJiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)lijiqianwangClick:(UIButton *)sender {
    
    
    Manager *manager = [Manager manager];
    
    //_lastCoordinate = CLLocationCoordinate2DMake([dic[@"data"][0][@"c_ALTIT"] doubleValue], [dic[@"data"][0][@"c_LONGIT"] doubleValue]);
    double la = _alutd.doubleValue;
    double lo = _lontd.doubleValue;

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(la, lo);
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
    
    DbgLog(@"userinfo = %@",_ZJuserInfo);
    [self didSelectWhatToDo:2];
    [self removeFromSuperview];
    return;
}
- (IBAction)shaohouTishiClick:(UIButton *)sender {
//    计算召集时间，从新设置一个通知:
    ZjZCTXView *view = [[[NSBundle mainBundle]loadNibNamed:@"ZjZCTXView" owner:self options:nil]lastObject];
    view.timeSlider.continuous = YES;
    view.timeSlider.value = 30.0;
    [view.ZjOKBtn addTarget:self action:@selector(sureShaohou:) forControlEvents:UIControlEventTouchUpInside];
    view.frame = CGRectMake(0, self.frame.size.height-140, self.frame.size.width, 140);
    
    [self addSubview:view];
    
}

-(void)sureShaohou:(UIButton *)sender
{
    DbgLog(@"sen.tag = time = %ld",(long)sender.tag);
    double date = sender.tag * 60;
    NSInteger h = ((int)sender.tag)/60;
    NSInteger m = ((int)sender.tag)%60;
    NSString *hitStr = @"";
    DbgLog(@"h=%d",h);
    if (h>0) {
        hitStr = [NSString stringWithFormat:@"%d小时%d分钟后将会再次提醒您！",h,m];
    }else
    {
        hitStr = [NSString stringWithFormat:@"%d分钟后将会再次提醒您！",m];
    }
    Manager *manager = [Manager manager];
    [manager.mainView showHint:hitStr yOffset:-100];
    
    [APService setLocalNotification:[[NSDate date] dateByAddingTimeInterval:date] alertBody:[NSString stringWithFormat:@"嗨！还记得%@发起的召集嘛",_ZJuserInfo[@"nickName"]] badge:1 alertAction:@"查看" identifierKey:@"ZJZCTX" userInfo:_ZJuserInfo soundName:nil];
    [self didSelectWhatToDo:1];
    [self removeFromSuperview];
}
-(void)didSelectWhatToDo:(NSInteger )type
{
    //xxx.xxx.xxx.xxx:port/zrwt/aux/muster/ignore?token=xxx&musterId=xxx
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/muster/ignore"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_zhaojiId forKey:@"musterId"];
    [param setValue:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        
    }];
    
}

- (IBAction)hulueClick:(UIButton *)sender {
    [self removeFromSuperview];
    [self didSelectWhatToDo:0];
}

@end
