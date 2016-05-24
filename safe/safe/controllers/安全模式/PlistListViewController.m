//
//  PlistListViewController.m
//  safe
//
//  Created by andun on 15/10/5.
//  Copyright (c) 2015年 薛永伟. All rights reserved.
//

#import "PlistListViewController.h"

@interface PlistListViewController () <AMapSearchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation PlistListViewController
{
    NSMutableArray *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custNaviItm];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self customUI];
}
-(void)custNaviItm
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shangbiaoqian"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"输入地址";
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
- (void)customUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataSource = [[NSMutableArray alloc] init];
    _searchAPI = [[AMapSearchAPI alloc] initWithSearchKey:@"4f7adad030250716702a9e9ac3a9901a" Delegate:self];
    _plistTextFielld.delegate = self;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction) name:UITextFieldTextDidChangeNotification object:_plistTextFielld];
    
    [_plistTextFielld addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventEditingChanged];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    [_plistTextFielld becomeFirstResponder];
}

- (void)infoAction:(UITextField *)sender
{
    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    request.searchType = AMapSearchType_PlaceKeyword;
    
    request.keywords = _plistTextFielld.text;
    
    request.city = @[@"中国"];

    [_searchAPI AMapPlaceSearch:request];
    
}

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"搜索出错:%@", error);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    [_dataSource removeAllObjects];
    
    //response.pois是表示搜索结果的数组，因为同一个关键字可能搜到多个地点，所以要用数组表示
    for (AMapPOI *poi in response.pois) {
        NSLog(@"response name:%@, address:%@, latitude:%f, longitude:%f", poi.name, poi.address, poi.location.latitude, poi.location.longitude);
        
        //创建大头针
//        MAPointAnnotation *pin = [[MAPointAnnotation alloc]init];
//        pin.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);//大头针坐标
//        pin.title = poi.name;
//        pin.subtitle = poi.address;
//        [_pins addObject:pin];
        NSDictionary *dic = @{@"latitude":[NSString stringWithFormat:@"%f", poi.location.latitude],@"longitude":[NSString stringWithFormat:@"%f",poi.location.longitude],@"name":poi.name};
        [_dataSource addObject:dic];
    }
    
    [self.tableView reloadData];
    //把大头针钉在地图上
//    [_map addAnnotations:_pins];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    NSDictionary *dic = _dataSource[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(plistlistViewController:andNeedChangeLatitude:andNeedChangeLongitude:)])
    {
        NSDictionary *dic = _dataSource[indexPath.row];
        [self.delegate plistlistViewController:self andNeedChangeLatitude:[dic[@"latitude"] floatValue] andNeedChangeLongitude:[dic[@"longitude"] floatValue]];
        [self.delegate plistListViewController:self addNeedChangeName:dic[@"name"]];
        
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
