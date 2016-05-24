//
//  SafeViewController.h
//  safe
//
//  Created by andun on 15/10/5.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SafeViewController;

@protocol SafeViewControllerDelegate <NSObject>

- (void)safeViewController:(SafeViewController *)safeViewController;

@end

@interface SafeViewController : UIViewController

@property (nonatomic,strong) id <SafeViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIView *urGentView;
@property (weak, nonatomic) IBOutlet UIView *baopinganView;

@property (nonatomic,strong) NSMutableArray *localSafeArray;

@end
