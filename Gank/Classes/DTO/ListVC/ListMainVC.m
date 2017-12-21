//
//  ListMainVC.m
//  Gank
//
//  Created by 824810056 on 2017/12/14.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "ListMainVC.h"
#import "ListDataModel.h"
#import "ListTVc.h"
#import "infoDetailVC.h"



@interface ListMainVC ()
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation ListMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    _cellDataArray = [@[] mutableCopy];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)loadData{
    NSString *curTagStr = self.tag;
    if ([curTagStr isEqualToString:@"首页"]) {
        curTagStr = @"all";
    }
    if (self.isPullup) {
        _currentPage += 1;
    }
    NSString *urlStr = [[NSString stringWithFormat:@"http://gank.io/api/data/%@/20/%ld", curTagStr, _currentPage] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [AFNetworkTool JSONDataWithUrl:urlStr success:^(id json) {
        [self.actiView stopAnimating];
        [self.refreshControl endRefreshing];
        NSDictionary *dic = (NSDictionary *)json;
        NSString *errorCode = [NSString stringWithFormat:@"%@", dic[@"error"]];
        if ([errorCode isEqualToString:@"0"]) {
            NSArray *dataArray = [NSArray yy_modelArrayWithClass:[ListDataModel class] json:dic[@"results"]];
            if (dataArray.count > 0) {
                if (self.isPullup) {
                    [_cellDataArray addObjectsFromArray:dataArray];
                    
                } else {
                    _currentPage = 1;
                    [_cellDataArray removeAllObjects];
                    [_cellDataArray addObjectsFromArray:dataArray];
                }
            }
        } else {
            if (self.isPullup && _currentPage > 1) {
                _currentPage -= 1;
            }
        }
        [self.tableView reloadData];
        self.isPullup = NO;
        self.noDataL.hidden = self.cellDataArray.count > 0? YES:NO;
    } fail:^(NSError *error) {
        [self.actiView stopAnimating];
        [self.refreshControl endRefreshing];
        if (self.isPullup && _currentPage > 1) {
            _currentPage -= 1;
        }
        self.isPullup = NO;
        self.isDownRefresh = NO;
        self.noDataL.hidden = self.cellDataArray.count > 0? YES:NO;
    }];
    
    
}

#pragma mark -- UITableViewDelegate、 UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *listTVCell = @"listTVCell";
    ListTVc *cell = [tableView dequeueReusableCellWithIdentifier:listTVCell];
    if (!cell) {
        cell = [[ListTVc alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listTVCell];
    }
    cell.model = self.cellDataArray[indexPath.row];
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // ------------------------埋点  12-----------------
    // umeng
    [MobClick event:@"1001"];
    // wangmai
    TRSOperationInfo *eventInfo = [[TRSOperationInfo alloc] init];
    eventInfo.eventCode = @"1001";
    eventInfo.eventName = @"点击文章进入详情";
    [TRSRequest TRSRecordGeneral:eventInfo];
    
    infoDetailVC *detail = [[infoDetailVC alloc] init];
    ListDataModel *model = (ListDataModel *)_cellDataArray[indexPath.row];
    detail.urlStr = model.url;
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
    
}

@end
