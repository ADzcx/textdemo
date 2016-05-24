//
//  GetGyView.h
//  safe
//
//  Created by 薛永伟 on 15/10/13.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetGyView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *gyTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *gyMiaoshuTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gyPhotoImgView;
@property (weak, nonatomic) IBOutlet UILabel *gyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyJineLabel;
@property (nonatomic,copy)NSString *gyId;
@property (nonatomic,copy)NSString *gzId;
@end
