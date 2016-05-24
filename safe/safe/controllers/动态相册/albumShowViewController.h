//
//  albumShowViewController.h
//  safe
//
//  Created by 薛永伟 on 15/10/1.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosModel.h"
@interface albumShowViewController : UIViewController
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *ownerId;
@property (nonatomic,copy)NSArray *imgArray;
@property (nonatomic,copy)NSString *commentCount;//评论数
@property (nonatomic,copy)NSString *laudCount;//点赞数
@property (nonatomic,copy)NSString *isMyLaud;//是否我点赞
@property (nonatomic,copy)NSString *date;
@property (nonatomic,copy)NSString *groupId;

@end
