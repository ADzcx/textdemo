//
//  LoadTeachView.m
//  safe
//
//  Created by 薛永伟 on 15/9/7.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "LoadTeachView.h"
#import "XSportLight.h"
@implementation LoadTeachView
+(void)loadTeachView:(UIViewController *)viewController
{
    XSportLight *SportLight = [[XSportLight alloc]init];
    SportLight.messageArray = @[
                                @"欢迎使用 安安卫士 ！点击开始新手指引",
                                @"点这里切换模式",
                                @"点击这里查看消息",
                                @"点击开始新的旅程"
                                ];
    SportLight.rectArray = @[
                             [NSValue valueWithCGRect:CGRectMake(0,0,0,0)],
                             [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 20, 50, 50)],
                             [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH - 20, 42, 50, 50)],
                             [NSValue valueWithCGRect:CGRectMake(0,0,0,0)]
                             ];
    SportLight.delegate = (id)viewController;
    [viewController presentViewController:SportLight animated:false completion:^{
        
    }];
}

@end
