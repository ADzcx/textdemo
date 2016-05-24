//
//  YEDetailTableViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/25.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "YEDetailTableViewController.h"
#import "YECell.h"
@interface YEDetailTableViewController ()

@end

@implementation YEDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"余额明细";
    [self.navigationItem.leftBarButtonItem setTitle:@"钱包"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YECell *cell = [tableView dequeueReusableCellWithIdentifier:@"yeCellID" ];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"YECell" owner:self options:nil]lastObject];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
