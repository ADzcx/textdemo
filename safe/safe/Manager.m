//
//  Manager.m
//  safe
//
//  Created by XueYongWei on 15/9/14.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "Manager.h"

static Manager *manager;
@implementation Manager

+ (id)manager
{
    if(!manager)
    {
        manager = [[Manager alloc] init];
    }
    return manager;
}

@end
