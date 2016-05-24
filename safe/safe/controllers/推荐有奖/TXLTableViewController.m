//
//  TXLTableViewController.m
//  safe
//
//  Created by 薛永伟 on 15/9/28.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "TXLTableViewController.h"
#import "tongxunluCell.h"
#import "tongxunluModel.h"
#import "BaoPingAnViewController.h"

@interface TXLTableViewController ()

@property (nonatomic,copy) NSMutableArray *dateSource;
@property (nonatomic,copy) NSMutableArray *thosPeople;
@property (nonatomic,strong) UIButton *btnSendSMS;
@end

@implementation TXLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    _btnSendSMS = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSendSMS.frame = CGRectMake(0, 0, 60, 30);
    [self changeSendBtn:0];
#pragma mark 🔌---由安全设置发来的从通讯录选择，所以要掉用代理
    if (_currentType == 201) {
        [_btnSendSMS setTitle:@"完成" forState:UIControlStateNormal];
        [_btnSendSMS addTarget:self action:@selector(onOkClick:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        [_btnSendSMS setTitle:@"立即发送" forState:UIControlStateNormal];
        [_btnSendSMS addTarget:self action:@selector(onSendClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:_btnSendSMS];
    self.navigationItem.rightBarButtonItem = btn;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    _dateSource = [[NSMutableArray alloc]init];
    _thosPeople = [[NSMutableArray alloc]init];
    
    [self tongxunluList];
    
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"选择联系人";
    self.navigationItem.titleView.tintColor = [UIColor darkGrayColor];
    UIButton *bkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bkbtn.frame = CGRectMake(0, 0, 25, 25);
    [bkbtn setBackgroundImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [bkbtn addTarget:self action:@selector(onBkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bkbtn];
}
#pragma mark 🔌---点击了返回键
-(void)onBkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 🔌---点击了返回键
-(void)onSendClick:(UIButton *)sender
{
    [self showMessageView];
}

#pragma mark 🔌---点击了返回键
-(void)onOkClick:(UIButton *)sender
{
    //定义一个数组来接收所有导航控制器里的视图控制器
    NSArray *controllers = self.navigationController.viewControllers;
    //根据索引号直接pop到指定视图
    BaoPingAnViewController *bpVC = [controllers objectAtIndex:2];
    for (int i =0; i<controllers.count; i++) {
        DbgLog(@"---->%@",controllers[i]);
    }
    [bpVC ChooseByTXL:_thosPeople];
    [self.navigationController popToViewController:[controllers objectAtIndex:2] animated:NO];
}
//设置发送按钮状态，参数备用 －－薛永伟5.7.13
-(void)changeSendBtn:(int)status
{
    if (_thosPeople.count > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}
-(NSArray *)arrayOfPeople
{
    return _thosPeople;
}
- (void)showMessageView
{
    if( [MFMessageComposeViewController canSendText] ){
        
        MFMessageComposeViewController * MScontroller = [[MFMessageComposeViewController alloc]init];
        //设置短信界面
        MScontroller.recipients = [self arrayOfPeople];
        MScontroller.body = _MsgContnt;
        MScontroller.messageComposeDelegate = self;
        MScontroller.navigationBar.tintColor = [UIColor darkGrayColor];
        
        [self presentViewController:MScontroller animated:YES completion:nil];
        [[[[MScontroller viewControllers] lastObject]navigationItem] setTitle:@"你安顿了吗"];
        
        //        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];//修改短信界面标题
    }else{
        [self showHint:@"抱歉！当前设备不支持发送短信！" yOffset:-10];
    }
}


//MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    //关键的一句   不能为YES
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch ( result ) {
        case MessageComposeResultCancelled:
            [self showHint:@"已取消发送短信" yOffset:-10];
            break;
        case MessageComposeResultFailed:// send failed
            [self showHint:@"短信发送失败！" yOffset:-10];
            break;
        case MessageComposeResultSent:
            [self showHint:@"邀请短信已发送！" yOffset:-10];
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dateSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tongxunluCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tongxunluCellID"];
    if (!cell) {
        cell = (tongxunluCell *)[[[NSBundle mainBundle] loadNibNamed:@"tongxunluCell" owner:self options:nil]lastObject];
    }
//    [cell.StatusBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
//    [cell.StatusBtn setBackgroundImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    tongxunluModel *model = _dateSource[indexPath.row];
    if (model.isSelect == YES) {
        cell.StatusBtn.selected = YES;
    }else
    {
        cell.StatusBtn.selected = NO;
    }
    NSString *name = [NSString stringWithFormat:@"%@  %@",model.userName,model.phoneNumber];
    cell.contentLabel.text = name;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    tongxunluModel *model = _dateSource[indexPath.row];
    
    tongxunluCell *cell = (tongxunluCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.StatusBtn.selected == YES) {
        model.isSelect = NO;
        cell.StatusBtn.selected = NO;
        [_thosPeople removeObject:model.phoneNumber];
    }else{
        model.isSelect = YES;
        cell.StatusBtn.selected = YES;
        [_thosPeople addObject:model.phoneNumber];
    }
    [self changeSendBtn:1];
}

-(void)tongxunluList{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
   
    addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
   
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        tongxunluModel *addressBook = [[tongxunluModel alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ 电话: %@", nameString, lastNameString];
            }
        }
        addressBook.userName = nameString;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.phoneNumber = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        addressBook.userEmail = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后数组中包含所有联系人的信息
        addressBook.isSelect = NO;
        [_dateSource addObject:addressBook];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
