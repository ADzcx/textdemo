//
//  CallInView.h
//  safe
//
//  Created by andun on 15/10/6.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallInView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (weak, nonatomic) IBOutlet UILabel *TheMeLable;

@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet UIImageView *cotentImage;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *placeLable;

- (IBAction)onBtnGoClick:(UIButton *)sender;

- (IBAction)onBtnLaterClick:(UIButton *)sender;

- (IBAction)onBtnLoseClick:(UIButton *)sender;


@end
