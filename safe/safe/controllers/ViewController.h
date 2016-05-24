//
//  ViewController.h
//  safe
//
//  Created by 薛永伟 on 15/9/6.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SafeBaseViewController.h"
#import <AMapNaviKit/MAMapKit.h> //高德地图的头文件
#import <AMapSearchKit/AMapSearchAPI.h>  //高德地图搜索的头文件
#import "MANaviRoute.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "NavPointAnnotation.h"

@protocol MenuReloadDataVCDelegate <NSObject>

-(void)reloadMenuDataAndViewVC:(int)type;

@end
@interface ViewController :SafeBaseViewController <AMapNaviManagerDelegate,IFlySpeechSynthesizerDelegate,AMapNaviViewControllerDelegate,CLLocationManagerDelegate>

@property (nonatomic,assign) id <MenuReloadDataVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *bottomBkView;
@property (nonatomic,strong)UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;

@property (nonatomic,strong) MAAnnotationView *userLocationAnnotationView; //当前位置指向的大头针，用于调方向

@property (weak, nonatomic) IBOutlet UIButton *test;

- (IBAction)onBtnAnDunClick:(UIButton *)sender;

- (IBAction)onBtnShareClick:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *gyJinETextField;

@property (weak, nonatomic) IBOutlet UIButton *onBtnShare;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeHeight;

@property (weak, nonatomic) IBOutlet UIButton *onBtnfriend;
@property (weak, nonatomic) IBOutlet UIButton *YouxiaojiaoAndunBtn;

- (IBAction)onBtnFriendClcik:(UIButton *)sender;

@property (nonatomic) AMapSearchType searchType;

@property (nonatomic, strong) AMapRoute *route;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic, strong) UIBarButtonItem *previousItem;

@property (nonatomic, strong) UIBarButtonItem *nextItem;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

@property (nonatomic) MANaviRoute * naviRoute;

@property (nonatomic,assign) CGFloat aimlatitude;

@property (nonatomic,assign) CGFloat aimlongitude;

@property (nonatomic,strong) MAMapView *mapView;

@property (nonatomic,strong) NSString *localAddress;

@property (nonatomic,assign) CLLocationCoordinate2D localCoordinate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseFriendWidth;


//导航
@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (nonatomic, strong) NavPointAnnotation *endAnnotation;

@property (nonatomic, strong) AMapNaviViewController *naviViewController;

@property (nonatomic,strong) NSMutableArray *safePlaceArrays;

- (void)refreshNewNavi;

-(void)prepareLefBarBtn:(int)type;

- (void)customFriendAnnotationWithCoordinate:(CLLocationCoordinate2D )coordinate;
- (void)friendReal;
-(void)CountOfJingXI;

@end

