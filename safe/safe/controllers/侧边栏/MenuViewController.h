//
//  MenuViewController.h
//  safe
//
//  Created by 薛永伟 on 15/9/10.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "PersonDetailViewController.h"
#import "ViewController.h"

@interface MenuViewController : UIViewController <MenuReloadDataDelegate,MenuReloadDataVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *xiangceView;
@property (weak, nonatomic) IBOutlet UIView *haoyouView;
@property (weak, nonatomic) IBOutlet UIView *qianbaoView;
@property (weak, nonatomic) IBOutlet UIView *tuijianView;
@property (weak, nonatomic) IBOutlet UIView *zhaomuView;
@property (weak, nonatomic) IBOutlet UIView *tieshiView;
@property (weak, nonatomic) IBOutlet UIView *faxianView;
//@property (weak, nonatomic) IBOutlet UIView *shezhiView;
@property (weak, nonatomic) IBOutlet UIView *xiaoxiView;
@property (weak, nonatomic) IBOutlet UIImageView *menuAdView;

@property (weak, nonatomic) IBOutlet UIImageView *xiaoxiBiao;
@property (weak, nonatomic) IBOutlet UIImageView *haoyouBiao;
@property (weak, nonatomic) IBOutlet UIImageView *xiangceBiao;

-(void)reloadMenuDataAndView;

@end

