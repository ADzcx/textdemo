//
//  alumDetailViewController.h
//  safe
//
//  Created by 薛永伟 on 15/9/17.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface alumDetailViewController : UIViewController

@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSArray *imgArray;
@property (nonatomic,copy)NSString *commentCount;//评论数
@property (nonatomic,copy)NSString *laudCount;//点赞数
@property (nonatomic,copy)NSString *isMyLaud;//我是否点赞
@property (nonatomic,copy)NSString *ownerId;
@property (nonatomic,copy)NSString *date;
@property (nonatomic,copy)NSString *groupId;

@end
