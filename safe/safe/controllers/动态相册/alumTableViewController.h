//
//  alumTableViewController.h
//  safe
//
//  Created by 薛永伟 on 15/9/17.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"


@interface alumTableViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,copy)NSString *userId;

@property (nonatomic,assign) BOOL isSelf;
@end
