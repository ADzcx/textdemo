//
//  UrgentFriendViewController.h
//  safe
//
//  Created by andun on 15/9/30.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UrgentFriendViewController;

@protocol UrgentFriendViewControllerDelegate <NSObject>

- (void)urgentFriendViewController:(UrgentFriendViewController *)urgentFriendViewController changefriendId:(NSString *)friendId;

@optional

- (void)urgentFriendViewController:(UrgentFriendViewController *)urgentFriendViewController needChangeDic:(NSDictionary *)dic;

@end

@interface UrgentFriendViewController : UIViewController

@property (nonatomic,assign) NSInteger currentType; //用于区分现在的状态

@property (nonatomic,strong) id <UrgentFriendViewControllerDelegate> delegate;

@end
