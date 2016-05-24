//
//  LoginViewController.h
//  safe
//
//  Created by XueYongWei on 15/9/14.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic,copy) NSString *userName;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextFierld;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)onBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *onButton;

@end
