//
//  MyZoneViewController.h
//  safe
//
//  Created by 薛永伟 on 15/10/10.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlistListViewController.h"

@class MyZoneViewController;
@protocol MyZoneViewControllerDelegate <NSObject>

- (void)MyZoneViewController:(MyZoneViewController *)myZoneViewController;

@end

@interface MyZoneViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,PlistlistViewControllerDelegate>

@property (nonatomic,strong) id <MyZoneViewControllerDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *localSafeArray1;

@property (nonatomic,strong) NSMutableArray *localSafeArray2;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
