//
//  ZjZCTXView.m
//  safe
//
//  Created by 薛永伟 on 15/10/10.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "ZjZCTXView.h"

@implementation ZjZCTXView
- (IBAction)timeSlider:(UISlider *)sender {
    NSInteger h = ((int)_timeSlider.value)/60;
    NSInteger m = ((int)_timeSlider.value)%60;
    DbgLog(@"h=%d",h);
    if (h>0) {
        _timeLabel.text = [NSString stringWithFormat:@"%d小时%d分钟",h,m];
    }else
    {
        _timeLabel.text = [NSString stringWithFormat:@"%d分钟",m];
    }
    _ZjOKBtn.tag = (int)sender.value;
}
- (IBAction)onQUxiaoClick:(UIButton *)sender {
    [self removeFromSuperview];
}




@end
