//
//  MenuViewManger.m
//  safe
//
//  Created by 薛永伟 on 15/10/5.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "MenuViewManger.h"
static MenuViewManger *menuViewManger;
@implementation MenuViewManger

+ (id)MenuViewManger
{
    if(!menuViewManger)
    {
        menuViewManger = [[MenuViewManger alloc] init];
    }
    return menuViewManger;
}

@end
