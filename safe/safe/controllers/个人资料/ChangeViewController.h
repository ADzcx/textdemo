//
//  ChangeViewController.h
//  safe
//
//  Created by XueYongWei on 15/9/15.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChangeViewController;

@protocol ChangeViewControllerDelegate <NSObject>

- (void)changeViewController:(ChangeViewController *)changeViewController needChangeTitle:(NSString *)title;


@end

@interface ChangeViewController : UIViewController

@property (nonatomic,strong) id <ChangeViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
