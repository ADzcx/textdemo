//
//  ThisOne.h
//  safe
//
//  Created by 薛永伟 on 15/10/10.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectJingXiView.h"

@interface ThisOne : UIView

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIButton *headImage;

@property (weak, nonatomic) IBOutlet UILabel *userLocation;

@property (weak, nonatomic) IBOutlet UILabel *userDistance;

@property (weak, nonatomic) IBOutlet UIButton *rangeDrive;

@property (weak, nonatomic) IBOutlet UILabel *driveRange;
@property (weak, nonatomic) IBOutlet UIButton *jingxiCountBtn;
@property (nonatomic,strong) SelectJingXiView *JXView;


@property (weak, nonatomic) IBOutlet UIButton *JXBtn;


@property (nonatomic,copy) NSString *longitude;

@property (nonatomic,copy) NSString *latitude;

@property (nonatomic,copy) NSString *userId;

@property (nonatomic,copy) NSString *headImageUrl;



- (IBAction)onBtnDetailFriendClick:(UIButton *)sender;

- (IBAction)onBtnFriendChatClick:(UIButton *)sender;

- (IBAction)onBtnRouteClick:(UIButton *)sender;

- (IBAction)onBtnTelePhoneClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *andunImage;






@end
