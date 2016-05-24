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
#import "PhotosModel.h"
#import "OnePhotoView.h"
#import "twoPhotoView.h"
#import "ThreePhotoiew.h"
#import "FourPhotoView.h"
#import "tableHead.h"
#import "tableHeadself.h"

@interface alumTableViewController ()
@property (nonatomic,copy)NSMutableArray *dataSource;
@property (nonatomic,copy)NSString *UserToken;
@property (nonatomic,assign)NSInteger imgVlcontentSize;
@property (nonatomic,assign)int currentPage;

@property (nonatomic,copy)NSString *uhimgurl;
@property (nonatomic,copy)NSString *unickname;
@property (nonatomic,copy)NSString *usignname;

@end

@implementation alumTableViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self prepareData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    
    [self prepareRefresh];
    [self custNaviItm];
    
    _dataSource = [[NSMutableArray alloc]init];
    self.navigationController.automaticallyAdjustsScrollViewInsets = YES;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDef objectForKey:@"info"];
    DbgLog(@"%@",dic);
    _UserToken = [NSString stringWithFormat:@"%@",dic[@"token"]];
    
    [self getUserInfo];

}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;

    self.navigationItem.title = @"相册";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    //bkbtn.backgroundColor = [UIColor yellowColor];
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
}
-(void)onBkBtnClick:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.tableView.headerPullToRefreshText = @"安顿";
    self.tableView.headerReleaseToRefreshText = @"释放立即刷新";
    self.tableView.headerRefreshingText = @"正在刷新";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载数据";
    self.tableView.footerReleaseToRefreshText = @"释放立即加载更多数据";
    self.tableView.footerRefreshingText = @"正在加载";

}

- (void)headerRereshing  //下拉触发的事件,刷新
{
    DbgLog(@"下拉刷新");
    [self prepareData];
}

- (void)footerRereshing   //上拉触发的时间,加载更多
{
    DbgLog(@"上拉加载更多");

    [self loadDataWithPage:_currentPage+1];
    
}


-(void)prepareData
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
//    NSMutableDictionary *param = @{@"token":_UserToken};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:_UserToken forKey:@"token"];
    if (!_isSelf) {
        DbgLog(@"获取 %@ 的相册",_userId);
        [param setValue:[NSString stringWithFormat:@"%@",_userId] forKey:@"userIdB"];
    }
     NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/list/get"];
    DbgLog(@"发送的网络请求:%@",strUrl);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        [self.tableView headerEndRefreshing];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典，
        DbgLog(@"+++++++%@",rspDic);
        if ([rspDic[@"code"] integerValue] == 201 ) {
            [_dataSource removeAllObjects];
            NSArray *rspData = rspDic[@"data"];
            for (NSDictionary *photo in rspData) {
                DbgLog(@"add photo %@",photo);
                PhotosModel *modle = [[PhotosModel alloc]init];
                modle.content = photo[@"content"];
                modle.date = photo[@"date"];
                modle.groupId = photo[@"groupId"];
                modle.imageCount = [NSString stringWithFormat:@"%@",photo[@"imageCount"]];
                modle.laudCount = photo[@"laudCount"];
                modle.ownerId = photo[@"ownerId"];
                modle.photoRecords = photo[@"photoRecords"];
                modle.position = photo[@"position"];
                modle.commentCount = photo[@"commentCount"];
                modle.isMyLaud = [NSString stringWithFormat:@"%@",photo[@"isMyLaud"]];
                [_dataSource addObject:modle];
            }
            [self.tableView reloadData];
        }else{
            
            [self showHint:rspDic[@"msg"] yOffset:-100];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        [self.tableView headerEndRefreshing];
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:error.localizedDescription yOffset:-100];
        
    }];
}
-(void)loadDataWithPage:(int)page
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithObjectsAndKeys:_UserToken,@"token", nil];
    
    [param setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/list/get"];
    
    DbgLog(@"发送的参数:%@",param);
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        [self.tableView footerEndRefreshing];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DbgLog(@"+++++++%@",rspDic);
        if ([rspDic[@"code"] integerValue] == 201 ) {
            NSArray *rspData = rspDic[@"data"];

            for (NSDictionary *photo in rspData) {
//                DbgLog(@"add photo %@",photo);
                PhotosModel *modle = [[PhotosModel alloc]init];
                modle.content = photo[@"content"];
                DbgLog(@"content--%@",modle.content);
                modle.date = photo[@"date"];
                modle.commentCount = photo[@"commentCount"];
                modle.groupId = photo[@"groupId"];
                modle.imageCount = photo[@"imageCount"] ;
                modle.laudCount = photo[@"laudCount"];
                modle.ownerId = photo[@"ownerId"];
                modle.photoRecords = photo[@"photoRecords"];
                modle.position = photo[@"position"];
                [_dataSource addObject:modle];
            }
            _currentPage ++;
            
            [self.tableView reloadData];
        }else{
            if ([rspDic[@"msg"] isEqualToString:@"暂无照片!"]) {
                [self showHint:@"没有更多照片" yOffset:-10];
            }else{
                [self showHint:rspDic[@"msg"] yOffset:-10];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        [self showHint:error.localizedDescription yOffset:-10];
            [self.tableView footerEndRefreshing];
    }];
}

- (IBAction)onNewPhoto:(UIButton *)sender {

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"发布图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionSheet showInView:self.view];
    
}
//UIActionSheet协议里定义的方法，点其中的按钮时调用
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    DbgLog(@"%ld",(long)buttonIndex);
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

//@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
//@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
//@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
//
//@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeAdLocalLabel;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        albumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCellID"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"albumCell" owner:self options:nil]lastObject];
        }
    
    PhotosModel *model = _dataSource[indexPath.row];

    cell.contenTextView.text = model.content;
    cell.timeAdLocalLabel.text = [NSString stringWithFormat:@"位置:%@",model.position];
    cell.dayLabel.text = [self getDate:1 withString:model.date];
    cell.photoCountLabel.text = [NSString stringWithFormat:@"共%@张",model.imageCount];
    cell.monthLabel.text =  [self transToChinese:[self getDate:0 withString:model.date]];

    if (_dataSource.count>0) {
         [cell.ImgView addSubview:[self viewWithPhotos:model.photoRecords]];
    }
   
    return cell;
}
-(UIView *)viewWithPhotos:(NSArray *)photoArray
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects: nil];
    
    for (NSDictionary *imgDic in photoArray) {
        NSString *url = imgDic[@"url"];
        [array addObject:url];
    }
    if (array.count == 1) {
        OnePhotoView *view = [[[NSBundle mainBundle]loadNibNamed:@"OnePhotoView" owner:self options:nil]lastObject];
        [view.view1 sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:[UIImage imageNamed:@"3"]];
        return view;
    }else if (array.count == 2)
    {
        twoPhotoView *view = [[[NSBundle mainBundle]loadNibNamed:@"TwoPhotoView" owner:self options:nil]lastObject];
        [view.view1 sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:[UIImage imageNamed:@"3"]];
        [view.view2 sd_setImageWithURL:[NSURL URLWithString:array[1]] placeholderImage:[UIImage imageNamed:@"3"]];
        return view;
    }else if (array.count == 3)
    {
        ThreePhotoiew *view = [[[NSBundle mainBundle]loadNibNamed:@"ThreePhotoView" owner:self options:nil]lastObject];
        [view.view1 sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:[UIImage imageNamed:@"3"]];
        [view.view2 sd_setImageWithURL:[NSURL URLWithString:array[1]] placeholderImage:[UIImage imageNamed:@"3"]];
        [view.view3 sd_setImageWithURL:[NSURL URLWithString:array[2]] placeholderImage:[UIImage imageNamed:@"3"]];
        return view;
    }else if (array.count >= 4)
    {
        FourPhotoView *view = [[[NSBundle mainBundle]loadNibNamed:@"FourPhotoView" owner:self options:nil]lastObject];
        [view.view1 sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:[UIImage imageNamed:@"3"]];
        [view.view2 sd_setImageWithURL:[NSURL URLWithString:array[1]] placeholderImage:[UIImage imageNamed:@"3"]];
        [view.view3 sd_setImageWithURL:[NSURL URLWithString:array[2]] placeholderImage:[UIImage imageNamed:@"3"]];
        [view.view4 sd_setImageWithURL:[NSURL URLWithString:array[3]] placeholderImage:[UIImage imageNamed:@"3"]];
        return view;
    }else
    {
        
    }
    return nil;
}
-(NSString *)getDate:(NSInteger )type withString:(NSString *)string
{
//    2015-09-25 17:53:02
    NSString *day = [string substringWithRange:NSMakeRange(5, 2)];
    NSString *month = [string substringWithRange:NSMakeRange(8, 2)];
    if (type == 0) {
        return day;
    }else
    {
        return month;
    }
}
-(NSString *)transToChinese:(NSString *)string
{
    
    if ([string isEqualToString:@"01"]) {
        return @"一月";
    }else if([string isEqualToString:@"02"]){
        return @"二月";
    }else if([string isEqualToString:@"03"]){
        return @"三月";
    }else if([string isEqualToString:@"04"]){
        return @"四月";
    }else if([string isEqualToString:@"05"]){
        return @"五月";
    }else if([string isEqualToString:@"06"]){
        return @"六月";
    }else if([string isEqualToString:@"07"]){
        return @"七月";
    }else if([string isEqualToString:@"08"]){
        return @"八月";
    }else if([string isEqualToString:@"09"]){
        return @"九月";
    }else if([string isEqualToString:@"10"]){
        return @"十月";
    }else if([string isEqualToString:@"11"]){
        return @"十一月";
    }else if([string isEqualToString:@"12"]){
        return @"十二月";
    }else
    {
        return @"不详";
    }
}
-(void)addImages:(NSArray *)images onSclView:(UIScrollView *)view
{
    _imgVlcontentSize = 75;
    for (NSInteger i = 0; i<images.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(_imgVlcontentSize*i, 0, _imgVlcontentSize-2, _imgVlcontentSize)];
        NSDictionary *image = images[i];
        NSString *imgUrl = image[@"url"];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"3"]];
        [view addSubview:imgView];
        imgView = nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DbgLog(@"indexpathrow = %ld",(long)indexPath.row);
        alumDetailViewController *detailVc = [[alumDetailViewController alloc]init];

    PhotosModel *model = _dataSource[indexPath.row];
    NSArray *photosArray = model.photoRecords;
    detailVc.content = model.content;
    detailVc.ownerId = model.ownerId;
    detailVc.groupId = model.groupId;
    detailVc.imgArray = photosArray;
    detailVc.commentCount = model.commentCount;
    detailVc.laudCount = model.laudCount;
    detailVc.date = model.date;
    detailVc.isMyLaud = model.isMyLaud;
    [self.navigationController pushViewController:detailVc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
//查询该id的信息
-(void)getUserInfo
{
//xxx.xxx.xxx.xxx:port/zrwt/friend/info?token=xxx&userIdB=xxx
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/info"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_userId forKey:@"userIdB"];
    DbgLog(@"发送的数据是:%@",param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        NSDictionary *userIfDic = rspDic[@"data"];
        _uhimgurl = userIfDic[@"uhimgurl"];
        _unickname = userIfDic[@"unickname"];
        //取出本地用户信息
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //起名弄反了
    if (_isSelf) {
        tableHead *headview = [[[NSBundle mainBundle]loadNibNamed:@"tableHead" owner:self options:nil] lastObject];
        headview.userNameLabel.text = _unickname;
        [headview.headImgView sd_setImageWithURL:[NSURL URLWithString:_uhimgurl] placeholderImage:[UIImage imageNamed:@"icon_logo"]];
    
        return headview;
    }else
    {
        tableHeadself *headview = [[[NSBundle mainBundle]loadNibNamed:@"tableHeadself" owner:self options:nil]lastObject];
        headview.userNamaLabel.text = _unickname;
        [headview.headImgView sd_setImageWithURL:[NSURL URLWithString:_uhimgurl] placeholderImage:[UIImage imageNamed:@"icon_logo"]];
        return headview;
    }
    
}

@end
