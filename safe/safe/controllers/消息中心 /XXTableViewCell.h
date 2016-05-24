//
//  XXTableViewCell.h
//  safe
//
//  Created by 薛永伟 on 15/10/11.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *xxTextView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *xxTitleLabel;

@end
