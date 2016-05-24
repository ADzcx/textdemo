//
//  MyGuYongView.h
//  safe
//
//  Created by 薛永伟 on 15/10/13.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYWCView.h"
@interface MyGuYongView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *jdHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel *jdNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jdDjdun;

@property (weak, nonatomic) IBOutlet UIButton *jdDHBtn;
@property (weak, nonatomic) IBOutlet UIButton *jdGBBtn;
@property (weak, nonatomic) IBOutlet UITextView *jdContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *jdJELabel;
@property (nonatomic,copy) NSString *UserId;
@property (nonatomic,copy) NSString *OrderId;


@end
