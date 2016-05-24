//
//  albumComentsCell.h
//  safe
//
//  Created by 薛永伟 on 15/10/4.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface albumComentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *comImageView;
@property (weak, nonatomic) IBOutlet UIButton *comHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *comNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *comContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *comTimeLabel;


@end
