//
//  XXTableViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/11.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "XXTableViewController.h"

#import "XXModel.h"
#import "XXTableViewCell.h"

@interface XXTableViewController ()
@property (nonatomic,copy)NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger currentPage;
@end

@implementation XXTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc]init];
    [self custNaviItm];
    [self prepareData];
    _currentPage = 1;
    [self prepareRefresh];
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"消息中心";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
}

-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
-(void)loadDataWithPage:(int)page
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    
    NSUserDefaults *usdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [usdef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:@"2" forKey:@"type"];
    [param setValue:[NSString stringWithFormat:@"%d",_currentPage] forKey:@"page"];
    
    [param setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/list/get"];
    
    DbgLog(@"发送的参数:%@",param);
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        [self.tableView footerEndRefreshing];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DbgLog(@"+++++++%@",rspDic);
        if ([rspDic[@"code"] integerValue] == 201 ) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
            DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
            //取出本地用户信息
            if ([rspDic[@"code"] integerValue] == 201 ) {
                for (NSDictionary *tongzhiDic in rspDic[@"data"]) {
                    XXModel *model = [[XXModel alloc]init];
                    model.xxnote = [NSString stringWithFormat:@"%@",tongzhiDic[@"content"]];
                    model.xxsenderId =  [NSString stringWithFormat:@"%@",tongzhiDic[@"senderId"]];
                    model.xxtitle = [NSString stringWithFormat:@"%@",tongzhiDic[@"title"]];
                    model.xxtime = [NSString stringWithFormat:@"%@",tongzhiDic[@"time"]];
                    model.noticeId = [NSString stringWithFormat:@"%@",tongzhiDic[@"noticeId"]];
                    [_dataSource addObject:model];
                    DbgLog(@"_dataSource=%@",_dataSource);
                }
                [self.tableView reloadData];
                _currentPage ++;
            }
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        [self showHint:error.localizedDescription yOffset:-10];
        [self.tableView footerEndRefreshing];
    }];
}

-(void)prepareData
{
//    type : 0-收到的，1-发出的，2-所有的，默认0
//    status : 0-未读，1-已读。默认0
//    page : 页码，开始1，默认1
//xxx.xxx.xxx.xxx:port/zrwt/notices/getbypage?token=xxx
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/notices/getbypage"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:@"2" forKey:@"type"];
 
    [param setValue:@"1" forKey:@"page"];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        [self.tableView headerEndRefreshing];
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        if ([rspDic[@"code"] integerValue] == 201 ) {
            [_dataSource removeAllObjects];
            for (NSDictionary *tongzhiDic in rspDic[@"data"]) {
                XXModel *model = [[XXModel alloc]init];
                
                model.xxnote = [NSString stringWithFormat:@"%@",tongzhiDic[@"content"]];
                model.xxsenderId =  [NSString stringWithFormat:@"%@",tongzhiDic[@"senderId"]];
                model.xxtitle = [NSString stringWithFormat:@"%@",tongzhiDic[@"title"]];
                model.xxtime = [NSString stringWithFormat:@"%@",tongzhiDic[@"time"]];
                model.noticeId = [NSString stringWithFormat:@"%@",tongzhiDic[@"noticeId"]];
                [_dataSource addObject:model];
                DbgLog(@"_dataSource=%@",_dataSource);
            }
            [self.tableView reloadData];
            _currentPage = 0;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}
-(void)reloadData
{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XXTableViewCell" owner:self options:nil]lastObject];
    }
    XXModel *model = _dataSource[indexPath.row];
    
    cell.timeLabel.text = model.xxtime;
    cell.xxTextView.text = model.xxnote;
    cell.xxTitleLabel.text = model.xxtitle;
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        XXModel *model = _dataSource[indexPath.row];
        [self deleteXX:model.noticeId];
        
        [_dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}
-(void)deleteXX:(NSString *)xxID
{
//xxx.xxx.xxx.xxx:port/zrwt/notices/del?token=xxx&list=[xx,xxx]
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/notices/del"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    NSString *list = [NSString stringWithFormat:@"[%@]",xxID];
    [param setValue:list forKey:@"list"];
    
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        //取出本地用户信息
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
@end
