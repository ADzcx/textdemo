//
//  GetZhaoJiView.h
//  safe
//
//  Created by 薛永伟 on 15/10/6.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetZhaoJiView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNaleLabel;
@property (weak, nonatomic) IBOutlet UITextView *zhutiLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *didianLabel;
@property (weak, nonatomic) IBOutlet UIButton *lijiqianwangBtn;
@property (weak, nonatomic) IBOutlet UIButton *shaohoutishiBtn;
@property (weak, nonatomic) IBOutlet UIButton *hulueBtn;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (nonatomic,copy)NSString *faqizheId;
@property (nonatomic,copy)NSString *zhaojiId;
@property (nonatomic,copy)NSString *lontd;
@property (nonatomic,copy)NSString *alutd;
@property (nonatomic,copy)NSDictionary *ZJuserInfo;
@end
