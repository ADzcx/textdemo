//
//  PhotosModel.h
//  safe
//
//  Created by 薛永伟 on 15/9/29.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotosModel : NSObject


@property (nonatomic,copy)NSString *commentCount;
@property (nonatomic,copy)NSArray *comments ;
@property (nonatomic,copy)NSString *content ;//文字
@property (nonatomic,copy)NSString *date;
@property (nonatomic,copy)NSString *groupId;
@property (nonatomic,copy)NSString *imageCount;
@property (nonatomic,copy)NSString *laudCount;//点赞
@property (nonatomic,copy)NSString *isMyLaud;//我是否点赞

@property (nonatomic,copy)NSString *ownerId;
@property (nonatomic,copy)NSString *ownerName;
@property (nonatomic,copy)NSArray *photoRecords;
@property (nonatomic,copy)NSString *position;

@end
