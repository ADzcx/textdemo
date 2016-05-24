//
//  albumCell.h
//  safe
//
//  Created by 薛永伟 on 15/9/23.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface albumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *ImgView;
@property (weak, nonatomic) IBOutlet UITextView *contenTextView;
@property (weak, nonatomic) IBOutlet UILabel *photoCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeAdLocalLabel;

@end
