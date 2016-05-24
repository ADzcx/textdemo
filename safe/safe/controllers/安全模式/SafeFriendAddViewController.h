//
//  SafeFriendAddViewController.h
//  safe
//
//  Created by andun on 15/10/14.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafeFriendAddViewController : UIViewController <UITableViewDataSource,UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *addressLable;

@property (weak, nonatomic) IBOutlet UITableView *friendTableView;

@property (nonatomic,strong) NSDictionary *addressDic;

@property (nonatomic,strong) NSDictionary *cid;

@end
