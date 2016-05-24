//
//  DTDetailViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/5.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "DTDetailViewController.h"
#import "albumComentsCell.h"
#import "albumZanCell.h"
#import "AlbumZanModel.h"
#import "AlbumComModel.h"
#import "CoreTFManagerVC.h"

@interface DTDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *textBkView;
@property (weak, nonatomic) IBOutlet UITextField *comTextField;
@property (weak, nonatomic) IBOutlet UITableView *bodyTableView;
@property (nonatomic,copy)NSMutableArray *dataSource;
@property (nonatomic,copy)NSMutableArray *zanArray;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *ownerheadImageView;
@property (weak, nonatomic) IBOutlet UIButton *dtZanBtn;

@end

@implementation DTDetailViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tmdt1 = [TFModel modelWithTextFiled:_comTextField inputView:nil name:@"输入评论" insetBottom:5];
        return @[tmdt1];
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [CoreTFManagerVC uninstallManagerForVC:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapEmpty:)];
    [self.view addGestureRecognizer:tap];
    _dataSource = [[NSMutableArray alloc]init];
    _zanArray = [[NSMutableArray alloc]init];
    [self prepareZan];
    [self prepareComments];
    
    [self custNaviItm];
    _bodyTableView.delegate = self;
    _bodyTableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}
-(void)onTapEmpty:(UITapGestureRecognizer *)sender
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"xiabiaoqian"]forBarMetrics:UIBarMetricsDefault];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(alumDetaionBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
    self.navigationItem.title = @"全民动态";
}
-(void)prepareData
{
//    _pid
}
-(void)alumDetaionBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_zanArray.count>0) {
        return _dataSource.count+1;
    }else
    {
    return _dataSource.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row == 0) &&(_zanArray.count > 0)) {//有评论时第一行返回赞的cell
        
        albumZanCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"albumZanCell" owner:self options:nil]lastObject];
        int i=0;
        for (AlbumZanModel *model in _zanArray) {
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(i*30, 6, 28, 28)];
            imgV.layer.cornerRadius = 14;
            imgV.clipsToBounds = YES;
            [imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.luico]] placeholderImage:[UIImage imageNamed:@"icon_logo"]];
            
            [cell.zanScrollView addSubview:imgV];
            i++;
        }
        i=0;
        return cell;
        
    }else//返回评论的cell
    {
        AlbumComModel *model = [[AlbumComModel alloc]init];
        if (_zanArray.count>0) {
            model = _dataSource[indexPath.row-1];
        }else
        {
            model = _dataSource[indexPath.row];
        }
        albumComentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumComentsCellID"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"albumComentsCell" owner:self options:nil]lastObject];
        }
        DbgLog(@"这一行的%@",model.replyUserIco);
        cell.comNameLabel.text = model.replyName;
        cell.comTimeLabel.text = model.replyTime;
        cell.comContentLabel.text = model.replyContent;
        
        [cell.comHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.replyUserIco] forState:UIControlStateNormal];
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headView = [[[NSBundle mainBundle]loadNibNamed:@"DTDetailHeadView" owner:self options:nil]lastObject];
    
    DbgLog(@"_headView.frame = %@",NSStringFromCGRect(_headView.frame));
    DbgLog(@"_photoImageView.frame = %@",NSStringFromCGRect(_photoImageView.frame));
    CGRect newrect = _headView.frame;
    newrect.size.width = SCREEN_WIDTH;
    _headView.frame = newrect;
    _headView.clipsToBounds = YES;
    CGRect photoRect = _photoImageView.frame;
    photoRect.size.width = _headView.frame.size.width-100;
    _photoImageView.frame = photoRect;
    _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
   
    DbgLog(@"++ _headView.frame = %@",NSStringFromCGRect(_headView.frame));
    DbgLog(@"++ _photoImageView.frame = %@",NSStringFromCGRect(_photoImageView.frame));
    //    DbgLog(@"得到的model %@ %@",_date,_content);
    DbgLog(@"传递过来的url:%@",_pUrl);
    
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:_pUrl] placeholderImage:[UIImage imageNamed:@"imgPlaceHd"]];
    [_ownerheadImageView sd_setImageWithURL:[NSURL URLWithString:_headUrl] forState:UIControlStateNormal];
    
    return _headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 300;
}
- (IBAction)onDtBtnClick:(UIButton *)sender {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary: [userDef objectForKey:@"info"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/laud"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_pid  forKey:@"photoId"];
    [param setValue:@"0" forKey:@"laud"];
    DbgLog(@"发的参数%@",param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"修改成功 %@  date:%@",rspDic,rspDic[@"data"]);
        [self showHint:@"成功" yOffset:-200];
        [self prepareZan];
   
//        [_dtZanBtn setTitle:@"取消" forState:UIControlStateNormal];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}
//http://xxx.xxx.xxx.xxx:port/zrwt/aux/photo/comment/get?token=TestZhuff01&photoId=xx
-(void)prepareComments
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_pid forKey:@"photoId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/comment/get"];
    DbgLog(@"prepareComments发起请求的网址;%@ %@",strUrl,param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        if ([rspDic[@"code"] integerValue] == 201) {
            NSMutableArray *dataArr = rspDic[@"data"];
            [_dataSource removeAllObjects];
            for (NSDictionary *replyDic in dataArr) {
                DbgLog(@"当前的一条回复:%@",replyDic);
                AlbumComModel *model = [[AlbumComModel alloc]init];
                DbgLog(@"model = %@",model);
                model.beReplyId =  [NSString stringWithFormat:@"%@",replyDic[@"beReplyId"]];
                model.beReplyName = replyDic[@"beReplyName"];
                model.commentId = replyDic[@"commentId"];
                model.replyAltitude = replyDic[@"replyAltitude"];
                model.replyContent = replyDic[@"replyContent"];
                model.replyId = replyDic[@"replyId"];
                model.replyName = replyDic[@"replyName"];
                model.replyTime = replyDic[@"replyTime"];
                model.replyUserIco = [NSString stringWithFormat:@"%@",replyDic[@"replyUserIco"]];
                DbgLog(@"replyDic:%@ model %@",replyDic[@"replyTime"],model.replyTime);
                [_dataSource addObject:model];
                DbgLog(@"数据源里的内容:%@",_dataSource);
            }
            DbgLog(@"最后数据源里的内容:%@",_dataSource);
            [_bodyTableView reloadData];
        }else
        {
//            [self showHint:rspDic[@"msg"] yOffset:-100];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}
//aux/photo/laud/people?token=TestZhuff01&id=xxx&type=0
-(void)prepareZan
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_pid forKey:@"id"];
    [param setValue:@"0" forKey:@"type"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/laud/people"];
    DbgLog(@"prepareComments发起请求的网址;%@ %@",strUrl,param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        if ([rspDic[@"code"] integerValue] == 201) {
            [_zanArray removeAllObjects];
            NSMutableArray *dataArr = rspDic[@"data"];
            for (NSDictionary *zanDic in dataArr) {
                AlbumZanModel *model = [[AlbumZanModel alloc]init];
                model.lid = zanDic[@"lid"];
                model.llaudid = zanDic[@"llaudid"];
                model.lnote = zanDic[@"lnote"];
                model.lstatus = zanDic[@"lstatus"];
                model.ltime = zanDic[@"ltime"];
                model.luico = zanDic[@"luico"];
                model.luid = zanDic[@"luid"];
                model.lunickname = zanDic[@"lunickname"];
                model.lurl = zanDic[@"lurl"];
                [_zanArray addObject:model];
            }
            [_bodyTableView reloadData];
        }else
        {
//            [self showHint:rspDic[@"msg"] yOffset:-100];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSndBtnClick:(UIButton *)sender {
    [_comTextField resignFirstResponder];
    if (_comTextField.text.length < 1) {
        [self showHint:@"评论内容过少！" yOffset:-200];
        [_comTextField becomeFirstResponder];
        return;
    }
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary: [userDef objectForKey:@"info"]];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/comment"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_pid  forKey:@"photoId"];
    [param setValue:_comTextField.text forKey:@"comment"];
    DbgLog(@"发的参数%@-%@",strUrl,param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        [MBProgressHUD hideHUDForView:window animated:YES];
        DbgLog(@"修改成功 %@  date:%@",rspDic,rspDic[@"data"]);

        [self showHint:@"评论成功" yOffset:-100];
        [self prepareComments];
        [_bodyTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure :%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:window animated:YES];
//        [self showHint:@"出错了 " yOffset:-200];
        _comTextField.text = @"";
        [_comTextField resignFirstResponder];
    }];
}


@end
