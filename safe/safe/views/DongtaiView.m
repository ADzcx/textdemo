//
//  DongtaiView.m
//  safe
//
//  Created by 薛永伟 on 15/9/14.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "DongtaiView.h"

@implementation DongtaiView

-(void)try
{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        CGRect rect = self.photosView.frame;
        rect.size.height = 300;
        self.photosView.frame = rect;
        DbgLog(@"%@",NSStringFromCGRect(self.photosView.frame));
        
    }
    return self;
}

- (IBAction)new:(UIButton *)sender {
    
    [self removeFromSuperview];
    
  }

@end
