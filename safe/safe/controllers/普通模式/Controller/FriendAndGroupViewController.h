//
//  FriendAndGroupViewController.h
//  safe
//
//  Created by andun on 15/10/1.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendAndGroupViewController;
@protocol friendAndGroupViewControllerDelegate <NSObject>

- (void)friendAndGroupViewController:(FriendAndGroupViewController *)sender changeFriendId:(NSString *)friendId;


@end

@interface FriendAndGroupViewController : UIViewController

@property (nonatomic,strong) id <friendAndGroupViewControllerDelegate> delegate;

@end
