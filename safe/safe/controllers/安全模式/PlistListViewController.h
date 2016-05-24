//
//  PlistListViewController.h
//  safe
//
//  Created by andun on 15/10/5.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@class PlistListViewController;
@protocol PlistlistViewControllerDelegate <NSObject>

- (void)plistlistViewController:(PlistListViewController *)plistVC andNeedChangeLatitude:(CGFloat)latitude andNeedChangeLongitude:(CGFloat)longgitude;

@optional

- (void)plistListViewController:(PlistListViewController *)plistVC  addNeedChangeName:(NSString *)name;

@end

@interface PlistListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *plistTextFielld;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) id <PlistlistViewControllerDelegate> delegate;

@property (nonatomic,strong) AMapSearchAPI *searchAPI;

@property (nonatomic,assign) NSInteger plistType;

@end
