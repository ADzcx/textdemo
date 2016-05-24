//
//  RegisterViewController.h
//  safe
//
//  Created by XueYongWei on 15/9/14.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *textButton;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

- (IBAction)onBtnTestClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *testField;

@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@property (weak, nonatomic) IBOutlet UITextField *makeSurePassWord;

- (IBAction)onBtnStartClcik:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *onBtnStart;

@property (nonatomic,assign) BOOL isForGetPW;

@end
