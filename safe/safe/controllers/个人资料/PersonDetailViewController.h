//
//  PersonDetailViewController.h
//  safe
//
//  Created by XueYongWei on 15/9/14.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol MenuReloadDataDelegate <NSObject>

-(void)reloadMenuDataAndView;

@end


@interface PersonDetailViewController : UIViewController

@property (nonatomic,assign) id <MenuReloadDataDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *bodyScrollView;

@property (weak, nonatomic) IBOutlet UIView *headImageView;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UIView *nickerView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLable;

@property (weak, nonatomic) IBOutlet UIView *genderView;

@property (weak, nonatomic) IBOutlet UILabel *genderLable;

@property (weak, nonatomic) IBOutlet UIView *ageView;

@property (weak, nonatomic) IBOutlet UILabel *ageLable;

@property (weak, nonatomic) IBOutlet UIView *phoneView;

@property (weak, nonatomic) IBOutlet UILabel *phoneLable;

@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UILabel *signLable;

@property (weak, nonatomic) IBOutlet UIView *levelView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UIView *realNameView;
@property (weak, nonatomic) IBOutlet UILabel *realNameLable;

@property (weak, nonatomic) IBOutlet UIView *trueView;

@property (weak, nonatomic) IBOutlet UIView *refereeView;

@property (weak, nonatomic) IBOutlet UILabel *refereeLable;

@end
