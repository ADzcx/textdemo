//
//  Manager.h
//  safe
//
//  Created by XueYongWei on 15/9/14.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "MenuViewController.h"

@interface Manager : NSObject

@property (nonatomic,strong) ViewController *mainView;

@property (nonatomic,strong) MenuViewController *menuVC;

@property (nonatomic,strong) NSString *token;

+ (id)manager;


@end
