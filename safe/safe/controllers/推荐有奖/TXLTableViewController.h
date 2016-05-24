//
//  TXLTableViewController.h
//  safe
//
//  Created by 薛永伟 on 15/9/28.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface TXLTableViewController : UITableViewController<MFMessageComposeViewControllerDelegate>
@property (nonatomic,assign) NSInteger currentType;

@property (nonatomic,copy) NSString *MsgContnt;
@end
