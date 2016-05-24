//
//  JFdetailTableViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/25.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "JFdetailTableViewController.h"
#import "JFdetailTableViewCell.h"

@interface JFdetailTableViewController ()

@end

@implementation JFdetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
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
    
    JFdetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jfCellID"];
   
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JFdetailTableViewCell" owner:self options:nil]lastObject];
    }
    

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[[NSBundle mainBundle]loadNibNamed:@"JFHeadView" owner:self options:nil]lastObject];
    return headView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
