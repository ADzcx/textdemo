//
//  GySendView.h
//  safe
//
//  Created by 薛永伟 on 15/10/8.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GySendView : UIView
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *xingbieView;

@property (weak, nonatomic) IBOutlet UIView *jineView;
@property (weak, nonatomic) IBOutlet UITextField *jineTextField;
@property (weak, nonatomic) IBOutlet UIView *yajinView;

@property (weak, nonatomic) IBOutlet UIButton *quedingBtn;
@property (nonatomic,assign)int sexNum;
@property (strong, nonatomic) IBOutlet UIButton *gyPhotoBtn;

@end
