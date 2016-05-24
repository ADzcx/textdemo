//
//  GetGyView.m
//  safe
//
//  Created by 薛永伟 on 15/10/13.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "GetGyView.h"
#import "Manager.h"
#import "MyGuYongView.h"

@implementation GetGyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)onJieDanClick:(UIButton *)sender {
//     发起接单的链接
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/hire/job/get"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    Manager *mng = [Manager manager];
    NSString *lo = [NSString stringWithFormat:@"%f",mng.mainView.localCoordinate.longitude];
    NSString *la = [NSString stringWithFormat:@"%f",mng.mainView.localCoordinate.latitude];
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_gyId forKey:@"orderId"];
    [param setValue:_gyId forKey:@"orderId"];
    [param setValue:lo forKey:@"longitude"];
    [param setValue:la forKey:@"altitude"];
    [param setValue:mng.mainView.localAddress forKey:@"pos"];
    DbgLog(@"发送的数据是:%@",param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        if ([rspDic[@"code"] integerValue] == 109) {
            [mng.mainView showHint:@"该订单已被别人接单！" yOffset:-100];
        }else if ([rspDic[@"code"] integerValue] == 200){
            MyGuYongView *v = [[[NSBundle mainBundle]loadNibNamed:@"MyGuYongView" owner:self options:nil]lastObject];
            v.frame = CGRectMake(0, 64, SCREEN_WIDTH, 145);
            v.jdNameLabel.text = [NSString stringWithFormat:@"雇主:%@",_gzId];
            v.jdJELabel.text = [NSString stringWithFormat:@"佣金:%@",_gyJineLabel.text];
            v.jdContentTextView.text = [NSString stringWithFormat:@"任务:%@",_gyMiaoshuTextLabel.text];
            v.UserId = _gzId;
            [mng.mainView.view addSubview:v];
            [mng.mainView.view bringSubviewToFront:v];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        
    }];
    [self removeFromSuperview];
}
- (IBAction)onHulueClick:(id)sender {
    [self removeFromSuperview];
}

@end
