//
//  albumShowViewController.m
//  safe
//
//  Created by 薛永伟 on 15/10/1.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "albumShowViewController.h"
#import "albumComentsCell.h"
#import "albumZanCell.h"
#import "AlbumComModel.h"
#import "PingLunViewController.h"
#import "AlbumZanModel.h"
#import "TLClickImageView.h"
#import "UIImageView+SDWebImage.h"
#import "CoreTFManagerVC.h"

@interface albumShowViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *bodyTableView;
@property (weak, nonatomic) IBOutlet UIButton *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSigLabel;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *moreBtnView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumDelBtn;

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,copy)NSMutableArray *dataSource;
@property (nonatomic,copy)NSMutableArray *zanArray;
@property (nonatomic,copy)NSString *userIdbName;
@property (nonatomic,copy)NSString *userBheadImageUrl;
@property (nonatomic,copy)NSString *moreBtnHidden;
@property (nonatomic,copy)NSString *FirstPhotoId;
@property (weak, nonatomic) IBOutlet UIButton *moreZanBtn;
@property (weak, nonatomic) IBOutlet UIView *textBkView;
@property (weak, nonatomic) IBOutlet UITextField *comTextField;
@property (nonatomic,copy) NSString *rsToUserId;

@end

@implementation albumShowViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tm1 = [TFModel modelWithTextFiled:_comTextField inputView:nil name:@"发表评论" insetBottom:5];
        return @[tm1];
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [CoreTFManagerVC uninstallManagerForVC:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self prepareComments];
    [self prepareZan];
    
    _dataSource = [[NSMutableArray alloc]initWithObjects:nil];
    _zanArray = [[NSMutableArray alloc]initWithObjects:nil];
    _rsToUserId = nil;
    _moreBtnHidden = @"no";
    
    [self prepareComments];
//    [self prepareZan];
    _bodyTableView.delegate = self;
    _bodyTableView.dataSource = self;
  
    [self friendsDetail:_ownerId];
}

-(void)customPhotosView
{
        NSArray* constrains2 = _photoView.constraints;
        for (NSLayoutConstraint* constraint in constrains2) {
            if (constraint.firstItem == _photoView) {
                //据底部0
                if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                    if (_imgArray.count > 3) {
                        constraint.constant = 120.f;
                    }else
                    {
                        constraint.constant = 60.f;
                    }
                }
            }
        }
//    for (NSInteger i=0; i<_imgArray.count;  i++) {
//        if (i==0) {
//            _FirstPhotoId = _imgArray[i][@"photoId"];
//        }
//        UIImageView *imgView = [[UIImageView alloc]init];
//        NSInteger OnePhotoWith = 60;
//        imgView.frame = CGRectMake((i%3)*OnePhotoWith, (i/3)*OnePhotoWith, OnePhotoWith-2,  OnePhotoWith-2);
//        NSString *imgUrl = _imgArray[i][@"url"];
//        [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"3"]];
//        
//        [_photoView addSubview:imgView];
//    }
    
    NSMutableArray * imgs = [NSMutableArray array];
    CGFloat width = 60;
    for (NSUInteger idx = 0; idx < _imgArray.count; idx ++) {
        if (idx == 0) {
            _FirstPhotoId = _imgArray[idx][@"photoId"];
        }
        NSUInteger X = idx % 3;
        NSUInteger Y = idx / 3;
        
        TLClickImageView *imageView = [[TLClickImageView alloc] initWithFrame:CGRectMake(width*X, width*Y, width-2, width-2)];
        NSString *imgUrl = _imgArray[idx][@"url"];
        NSArray *urlArr = [imgUrl componentsSeparatedByString:@"_250x250"];
        NSString *bigUrl = [NSString stringWithFormat:@"%@%@",urlArr[0],urlArr[1]];
        
        [imageView downloadImage:imgUrl place:[UIImage imageNamed:@"icon_logo"]];
        [_photoView addSubview:imageView];
        [imgs addObject:imageView];
        [imageView setViews:imgs];
    }
}

-(void)prepareComments
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_groupId forKey:@"pGId"];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/comment/get/group"];
    DbgLog(@"prepareComments发起请求的网址;%@ %@",strUrl,param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        if ([rspDic[@"code"] integerValue] == 201) {
            [_dataSource removeAllObjects];
            NSMutableArray *dataArr = rspDic[@"data"];
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
                model.replyUserIco = replyDic[@"replyUserIco"];
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
        
        
    }];
}
//aux/photo/laud/people?token=TestZhuff01&id=xxx&type=0
-(void)prepareZan
{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_groupId forKey:@"id"];
    [param setValue:@"1" forKey:@"type"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/laud/people"];
    DbgLog(@"prepareComments发起请求的网址;%@ %@",strUrl,param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        
        if ([rspDic[@"code"] integerValue] == 201) {
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
            
        }
        [_bodyTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DbgLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];

}
-(void)friendsDetail:(NSString *)fid
{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDef objectForKey:@"info"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_ownerId forKey:@"userIdB"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/friend/info"];
//    DbgLog(@"发起请求的网址;%@ %@ %@",strUrl,userDic[@"token"],_ownerId);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
//        DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
        NSDictionary *dataDic = rspDic[@"data"];
        _userBheadImageUrl = dataDic[@"uhimgurl"];
        _userIdbName = dataDic[@"unickname"];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:_userBheadImageUrl] forState:UIControlStateNormal];
        _userNameLabel.text = _userIdbName;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
        DbgLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_zanArray.count>0) {
        return _dataSource.count +1;
    }
    return _dataSource.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && _commentCount>0) {//有评论时第一行返回赞的cell
      albumZanCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"albumZanCell" owner:self options:nil]lastObject];
        int i=0;
        for (AlbumZanModel *model in _zanArray) {
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(i*30, 6, 28, 28)];
            imgV.layer.cornerRadius = 14;
            imgV.clipsToBounds = YES;

            [imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.luico]] placeholderImage:[UIImage imageNamed:@"3"]];

            [cell.zanScrollView addSubview:imgV];
        }
        return cell;
    }else//返回评论的cell
    {
        albumComentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumComentsCellID"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"albumComentsCell" owner:self options:nil]lastObject];
        }
        if (((_commentCount>0)&&indexPath.row == 1)||((_commentCount==0)&&indexPath.row == 0)) {
            cell.comImageView.hidden = NO;
        }
        AlbumComModel *model = [[AlbumComModel alloc]init];
        if (_zanArray.count >0) {
            model = _dataSource[indexPath.row-1];
        }else
        {
            model = _dataSource[indexPath.row];
        }
        cell.comNameLabel.text = model.replyName;
        cell.comContentLabel.text = model.replyContent;
        cell.comTimeLabel.text = model.replyTime;
        [cell.comHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.replyUserIco]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"3"]];
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headView = [[[NSBundle mainBundle]loadNibNamed:@"albumShowHeadView" owner:self options:nil]lastObject];
//    DbgLog(@"得到的model %@ %@",_date,_content);
    _userSigLabel.text = _content;
    _dateLabel.text = _date;
    _userNameLabel.text = _userIdbName;
    [self customPhotosView];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_userBheadImageUrl] forState:UIControlStateNormal];
    NSUserDefaults *usDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *usDic = [usDef objectForKey:@"info"];
    if (![usDic[@"uid"] isEqualToString:_ownerId]) {
        
        _albumDelBtn.hidden = YES;
        [_albumDelBtn removeFromSuperview];
        
    }
    
//    DbgLog(@"_dateLabel.text;%@",_dateLabel.text);
    
    return _headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_imgArray.count>3) {
        return 230;
    }else
    {
        return 180;
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumComModel *model = [[AlbumComModel alloc]init];
    if (_zanArray.count >0) {
        model = _dataSource[indexPath.row-1];
    }else
    {
        model = _dataSource[indexPath.row];
    }
    _rsToUserId = model.replyId;
    _comTextField.placeholder = [NSString stringWithFormat:@"回复:%@",model.replyName];
    [_comTextField becomeFirstResponder];
}
- (IBAction)onDoneClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onMoreBtnClick:(UIButton *)sender {
    
    CGRect newRect = _moreBtnView.frame;
    if ([_moreBtnHidden isEqualToString:@"no"]) {
        newRect.origin.x = SCREEN_WIDTH-140;
        [UIView animateWithDuration:0.3 animations:^{
            _moreBtnView.frame = newRect;
            if ([_isMyLaud isEqualToString:@"1"]) {
                 [_moreZanBtn setTitle:@"取消" forState:UIControlStateNormal];
            }
        }];
        _moreBtnHidden = @"yes";
    }else
    {
        newRect.origin.x = 1000;
        [UIView animateWithDuration:0.3 animations:^{
            _moreBtnView.frame = newRect;
        }];
        _moreBtnHidden = @"no";
    }
//    NSArray* constrains2 = _moreBtnView.constraints;
//    for (NSLayoutConstraint* constraint in constrains2) {
//            if (constraint.firstAttribute == NSLayoutAttributeLeading&&constraint.firstItem == _moreBtnView&&) {
//                if ([_moreBtnHidden isEqualToString:@"no"]) {
//                    constraint.constant = -200.f;
//                    _moreBtnHidden = @"yes";
//                }else
//                {
//                    constraint.constant = 3.0f;
//                    _moreBtnHidden = @"no";
//                }
//        }
//    }
}

- (IBAction)onDelBtnClick:(UIButton *)sender {
    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"确定要删除吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alv show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        DbgLog(@"删除");
//    http://xxx.xxx.xxx.xxx:port/zrwt/aux/photo/del/group?token=TestZhuff01&groupId=xxx
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/del/group"];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSDictionary *userDic = [userDef objectForKey:@"info"];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setValue:userDic[@"token"] forKey:@"token"];
        [param setValue:_groupId forKey:@"groupId"];
        [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
            DbgLog(@"成功 %@  date:%@",rspDic,rspDic[@"data"]);
            //取出本地用户信息
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure :%@",error.localizedDescription);
            [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        DbgLog(@"取消");
    }
}
- (IBAction)onZanBtnClick:(UIButton *)sender {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary: [userDef objectForKey:@"info"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/laud"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_FirstPhotoId  forKey:@"photoId"];
    [param setValue:@"0" forKey:@"laud"];
    DbgLog(@"发的参数%@",param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        DbgLog(@"修改成功 %@  date:%@",rspDic,rspDic[@"data"]);
        [self showHint:@"成功" yOffset:-200];
        int landIntVlu = _laudCount.intValue;
        _laudCount = [NSString stringWithFormat:@"%d",landIntVlu++];
        [_moreZanBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self prepareZan];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
        NSLog(@"failure :%@",error.localizedDescription);
        [self showHint:[NSString stringWithFormat:@"%@",error.localizedDescription] yOffset:-100];
    }];
}
- (IBAction)onComBtnClick:(UIButton *)sender {
    _rsToUserId = nil;
    [_comTextField becomeFirstResponder];
    
}

- (IBAction)onComSendClick:(UIButton *)sender {
    [_comTextField resignFirstResponder];
    if (_comTextField.text.length < 1) {
        [self showHint:@"评论内容过少！" yOffset:-200];
        [_comTextField becomeFirstResponder];
        return;
    }
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary: [userDef objectForKey:@"info"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",HeadUrl,@"/aux/photo/comment"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:userDic[@"token"] forKey:@"token"];
    [param setValue:_FirstPhotoId  forKey:@"photoId"];
    [param setValue:_comTextField.text forKey:@"comment"];
    if (_rsToUserId) {
        [param setValue:_rsToUserId forKey:@"userIdB"];
    }
    
    DbgLog(@"发的参数%@-%@",strUrl,param);
    [manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rspDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]; //返回是字典
        
        [MBProgressHUD hideHUDForView:window animated:YES];
        
        DbgLog(@"修改成功 %@  date:%@",rspDic,rspDic[@"data"]);
        [self prepareComments];
        [self showHint:@"评论成功" yOffset:-100];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:window animated:YES];
        NSLog(@"failure :%@",error.localizedDescription);
//        [self showHint:@"出错了 " yOffset:-200];
        [_comTextField becomeFirstResponder];
    }];
    _rsToUserId = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
