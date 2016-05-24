//
//  MenuViewManger.h
//  safe
//
//  Created by 薛永伟 on 15/10/5.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuViewController.h"

@interface MenuViewManger : NSObject
@property (nonatomic,strong) ViewController *mainView;

+ (id)MenuViewManger;

@end
