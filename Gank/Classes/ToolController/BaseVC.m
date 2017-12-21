//
//  BaseVC.m
//  Gank
//
//  Created by 824810056 on 2017/12/14.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "BaseVC.h"

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubView];
    
    self.isPullup = NO;
    self.isDownRefresh = NO;
    
}

- (void)setUpSubView{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noDataL];
  
}

- (void)setTag:(NSString *)tag{
    _tag = tag;
    [self loadData];
}

- (UILabel *)noDataL{
    if (!_noDataL) {
        _noDataL = [[UILabel alloc] initWithFrame:CGRectMake((MSScreenWidth-250)/2, 70, 250, 30)];
        _noDataL.text = @"暂无内容，请检查网络";
        _noDataL.textAlignment = NSTextAlignmentCenter;
        _noDataL.textColor = [UIColor grayColor];
        _noDataL.font = [UIFont systemFontOfSize:20];
    }
    return _noDataL;
}

// 用来给子类调用
- (void)loadData{
    
}
- (void)downrefresh{
    [self.refreshControl endRefreshing];
    
    // ------------------------埋点  8-----------------
    // umeng
    [MobClick event:@"A0012"];
    // wangmai
    TRSOperationInfo *eventInfo = [[TRSOperationInfo alloc] init];
    eventInfo.eventCode = @"A0012";
    eventInfo.eventName = @"下拉刷新";
    eventInfo.objectIDs = @"97546545,97546598,97546554";
    [TRSRequest TRSRecordGeneral:eventInfo];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(0, 0, MSScreenWidth, MSScreenHeight);
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        [_tableView addSubview:self.refreshControl];
        [_tableView addSubview:self.actiView];
        
    }
    return _tableView;
}
- (UIRefreshControl *)refreshControl{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(downrefresh) forControlEvents:UIControlEventValueChanged];
    }
    return  _refreshControl;
}
- (UIActivityIndicatorView *)actiView{
    if (!_actiView) {
        _actiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _actiView.frame = CGRectMake((MSScreenWidth-20)/2, (MSScreenHeight-20)/2-50, 20, 20);
        _actiView.hidesWhenStopped = YES;
        [_actiView startAnimating];
        
    }
    return _actiView;
}

#pragma mark - UITableView代理

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    
    NSInteger rowCount = [tableView numberOfRowsInSection:0];
    
    if (row == rowCount - 1 && !_isPullup) {
        // ------------------------埋点  9-----------------
        // umeng
        [MobClick event:@"A0011"];
        // wangmai
        TRSOperationInfo *eventInfo = [[TRSOperationInfo alloc] init];
        eventInfo.eventCode = @"A0011";
        eventInfo.eventName = @"上拉刷新";
        eventInfo.objectIDs = @"97546545,97546598,97546554";
        [TRSRequest TRSRecordGeneral:eventInfo];
        _isPullup = true;
        [self loadData];
        
        
    }
    
}

@end
