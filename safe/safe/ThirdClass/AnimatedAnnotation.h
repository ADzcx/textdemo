//
//  AnimatedAnnotation.h
//  Category_demo2D
//
//  Created by 刘博 on 13-11-8.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <AMapNaviKit/MAMapKit.h>

@interface AnimatedAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, strong) NSMutableArray *animatedImages;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic,strong) NSString *headImage;

@property (nonatomic,strong) NSString *userLocation;

@property (nonatomic,strong) NSString *userDistance;

@property (nonatomic,strong) NSString *rangeDrive;

@property (nonatomic,assign) NSInteger currentImageType;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic,copy) NSString *longitude;

@property (nonatomic,copy) NSString *latitude;

@property (nonatomic,copy) NSString *mainUserId;

@property (nonatomic,copy) NSString *shield;

@end
