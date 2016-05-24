//
//  alumTableViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/17.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "alumTableViewController.h"
#import "albumCell.h"
#import "alumDetailViewController.h"
#import <AFHTTPRequestOperation.h>
#import "SendPhotoViewController.h"

@interface alumTableViewController ()
@property (nonatomic,copy)NSMutableArray *dataSource;
@property (nonatomic,copy)NSString *UserToken;
@end

@implementation alumTableViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _isSelf = YES;
    _dataSource = [[NSMutableArray alloc]init];
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDef objectForKey:@"info"];
    _UserToken = [NSString stringWithFormat:@"%@",dic[@"token"]];
    
    DbgLog(@"%@",_UserToken);
    [self prepareData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}

-(void)prepareData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *param = @{@"token":_UserToken};
     NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/list/get"];
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        DbgLog(@"+++++++%@",rspDic);
        if ([rspDic[@"code"] integerValue] == 201 ) {
            NSArray *rspData = rspDic[@"data"];
            for (NSDictionary *photo in rspData) {
                DbgLog(@"add photo  %@",photo);
                [_dataSource addObject:photo];
            }
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
    }];
}


- (IBAction)onNewPhoto:(UIButton *)sender {

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"发布图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionSheet showInView:self.view];
}
//UIActionSheet协议里定义的方法，点其中的按钮时调用
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DbgLog(@"%ld",(long)buttonIndex);
    if(buttonIndex == 0)//从相册选择
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
            cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            cameraPicker.allowsEditing = YES;
            cameraPicker.delegate = self;
            [self presentViewController:cameraPicker animated:YES completion:nil];
        }
    }else if(buttonIndex == 1)//相机拍摄
    {
        UIImagePickerController *photoLibraryPicker = [[UIImagePickerController alloc] init];
        photoLibraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        photoLibraryPicker.allowsEditing = YES;
        photoLibraryPicker.delegate = self;
        [self presentViewController:photoLibraryPicker animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
        UIImage *image = info[UIImagePickerControllerOriginalImage];

        SendPhotoViewController *sdpVC = [[SendPhotoViewController alloc]init];
        sdpVC.image = image;
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController pushViewController:sdpVC animated:YES];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        albumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCellID"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"albumCell" owner:self options:nil]lastObject];
        }
    NSDictionary *photo = _dataSource[indexPath.row];
    
    [cell.photoView sd_setImageWithURL:[NSURL URLWithString:photo[@"picourl"]] placeholderImage:[UIImage imageNamed:@"guanyuandun"]];
    cell.noteLabel.text = photo[@"pnote"];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DbgLog(@"indexpathrow = %ld",(long)indexPath.row);
        alumDetailViewController *detailVc = [[alumDetailViewController alloc]init];
        [self.navigationController pushViewController:detailVc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isSelf) {
        return 295;
    }else
    {
        return 255;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headview = nil;
    if (_isSelf) {
        headview = [[[NSBundle mainBundle]loadNibNamed:@"tableHead" owner:self options:nil] lastObject];
    }else
    {
        headview = [[[NSBundle mainBundle]loadNibNamed:@"tableHeadself" owner:self options:nil]lastObject];
    }
    return headview;
}

@end
