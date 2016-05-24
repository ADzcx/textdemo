//
//  MusterViewController.h
//  safe
//
//  Created by andun on 15/10/5.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHPickView.h"

@interface MusterViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *middleScrollView;

- (IBAction)onBtnImageClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (weak, nonatomic) IBOutlet UIButton *onBtnPhotoImage;

@property(nonatomic,strong)ZHPickView *pickview;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UILabel *timaLable;

- (IBAction)onBtnTimeClick:(UIButton *)sender;

- (IBAction)onBtnPlaceClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *placeTitleLable;

@end
