//
//  SearchTVC.m
//  Gank
//
//  Created by 824810056 on 2017/12/15.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "SearchTVC.h"
#import "MKDropdownMenu.h"
#import "SearchDataModel.h"
#import "SearchTVCell.h"
#import "infoDetailVC.h"


@interface SearchTVC ()<MKDropdownMenuDelegate, MKDropdownMenuDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIView *navBgV;
@property (nonatomic, strong) MKDropdownMenu *dropMenu;
@property (nonatomic, strong) UITextField *inputTF;
@property (nonatomic, strong) NSArray *categories;

@property (nonatomic, assign) NSInteger selectMenuIndex;
@property (nonatomic, strong) NSMutableArray *cellDataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString *selectParam;

@end

@implementation SearchTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPullup = NO;
    self.categories = @[@"所有分类", @"iOS", @"Android", @"App", @"前端", @"瞎推荐", @"拓展资源"];
    self.selectMenuIndex = 0;
    self.currentPage = 1;
    self.cellDataArray = [@[] mutableCopy];
    self.noDataL.hidden = YES;
    [self.refreshControl removeFromSuperview];
    [self.actiView stopAnimating];
    [self setupNav];
}

- (void)setupNav{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(defaultBtnDicClick)];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar addSubview:self.navBgV];
}
- (UIView *)navBgV{
    if (!_navBgV) {
        _navBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSScreenWidth-80, 44)];
        _navBgV.backgroundColor = [UIColor whiteColor];
        
        _dropMenu = [[MKDropdownMenu alloc] initWithFrame:CGRectMake(20, 7, 100, 30)];
        _dropMenu.backgroundColor = RGBCOLOR(248, 248, 248);
        _dropMenu.delegate = self;
        _dropMenu.dataSource = self;
        [_navBgV addSubview:_dropMenu];
        
        _inputTF = [[UITextField alloc] initWithFrame:CGRectMake(120, 7, MSScreenWidth-200, 30)];
        _inputTF.delegate = self;
        _inputTF.backgroundColor = RGBCOLOR(248, 248, 248);
        _inputTF.returnKeyType = UIReturnKeySearch;
        [_inputTF becomeFirstResponder];
        [_navBgV addSubview:_inputTF];
    }
    return _navBgV;
}
#pragma mark - MKDropdownMenuDelegate,MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu{
    return 1;
}
- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component{
    return 7;
}
- (nullable NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component{
    NSString *title = self.categories[self.selectMenuIndex];
    return [[NSAttributedString alloc] initWithString:title
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
}
- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {

    NSString *title = self.categories[row];
    return [[NSAttributedString alloc] initWithString:title
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
}
- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (self.selectMenuIndex == row) {
        [dropdownMenu closeAllComponentsAnimated:YES];
        return;
    }
    self.selectMenuIndex = row;
    [dropdownMenu reloadAllComponents];
    [dropdownMenu closeAllComponentsAnimated:YES];
    if (self.inputTF.text.length >0) {
        self.selectParam = self.inputTF.text;
    } else {
        self.selectParam = nil;
    }
    self.isPullup = NO;
    self.currentPage = 1;
    [self loadData];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    // ------------------------埋点  10-----------------
    // umeng
    [MobClick event:@"A0013"];
    // wangmai
    TRSOperationInfo *eventInfo = [[TRSOperationInfo alloc] init];
    eventInfo.eventCode = @"A0013";
    eventInfo.eventName = @"点击搜索";
    [TRSRequest TRSRecordGeneral:eventInfo];

    if (textField.text.length >0) {
        self.selectParam = textField.text;
    } else {
        self.selectParam = nil;
    }
    self.isPullup = NO;
    self.currentPage = 1;
    [self loadData];
    return YES;
}
- (void)loadData{
    [self.actiView startAnimating];
    [self.refreshControl endRefreshing];
    if (self.isPullup) {
        _currentPage += 1;
    }
    NSString *category = self.categories[self.selectMenuIndex];
    if ([category isEqualToString:@"所有分类"]) {
        category = @"all";
    }
    NSString *urlStr = [[NSString stringWithFormat:@"http://gank.io/api/search/query/%@/category/%@/count/20/page/%ld", self.selectParam, category, _currentPage] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [AFNetworkTool JSONDataWithUrl:urlStr success:^(id json) {
        
        [self.actiView stopAnimating];
        NSDictionary *dic = (NSDictionary *)json;
//        NSLog(@"%@", dic);
        NSString *errorCode = [NSString stringWithFormat:@"%@", dic[@"error"]];
        if ([errorCode isEqualToString:@"0"]) {
            NSArray *dataArray = [NSArray yy_modelArrayWithClass:[SearchDataModel class] json:dic[@"results"]];
            if (dataArray.count > 0) {
                if (self.isPullup) {
                    [_cellDataArray addObjectsFromArray:dataArray];
                } else {
                    _currentPage = 1;
                    [_cellDataArray removeAllObjects];
                    [_cellDataArray addObjectsFromArray:dataArray];
                }
            } else {
                [_cellDataArray removeAllObjects];
            }
        } else {
            if (self.isPullup && _currentPage > 1) {
                _currentPage -= 1;
            }
            
        }
        [self.tableView reloadData];
        self.isPullup = NO;
        self.noDataL.hidden = self.cellDataArray.count > 0? YES:NO;
        if (!self.noDataL.hidden) {
            self.noDataL.text = @"没有搜索到内容！";
            self.noDataL.frame = CGRectMake((MSScreenWidth-250)/2, 160, 250, 30);
        }
    } fail:^(NSError *error) {
        [self.actiView stopAnimating];
        [self.refreshControl endRefreshing];
        if (self.isPullup && _currentPage > 1) {
            _currentPage -= 1;
        }
        self.isPullup = NO;
        self.noDataL.hidden = self.cellDataArray.count > 0? YES:NO;
        if (!self.noDataL.hidden) {
            self.noDataL.text = @"网络不给力啊！";
            self.noDataL.frame = CGRectMake((MSScreenWidth-250)/2, 160, 250, 30);
        }
    }];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *searchTVCell = @"SearchTVCell";
    SearchTVCell *cell = [tableView dequeueReusableCellWithIdentifier:searchTVCell];
    if (!cell) {
        cell = [[SearchTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchTVCell];
    }
    cell.model = self.cellDataArray[indexPath.row];
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // ------------------------埋点  12-----------------
    // umeng
    [MobClick event:@"1002"];
    // wangmai
    TRSOperationInfo *eventInfo = [[TRSOperationInfo alloc] init];
    eventInfo.eventCode = @"1002";
    eventInfo.eventName = @"点击搜索结果";
    [TRSRequest TRSRecordGeneral:eventInfo];
    
    infoDetailVC *detail = [[infoDetailVC alloc] init];
    SearchDataModel *model = (SearchDataModel *)_cellDataArray[indexPath.row];
    detail.urlStr = model.url;
    [self.navigationController pushViewController:detail animated:YES];
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    
    NSInteger rowCount = [tableView numberOfRowsInSection:0];
    
    if (row == rowCount - 1 && !self.isPullup && self.cellDataArray.count >8) {
        self.isPullup = true;
        
        [self loadData];
        
        
    }
    
}
- (void)defaultBtnDicClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ------------------------埋点  7-----------------
    // umeng
    [MobClick beginLogPageView:@"搜索页"];
    // wangmai
    [TRSRequest beginLogPageView];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navBgV.hidden = YES;
    // ------------------------埋点  7-----------------
    // umeng
    [MobClick endLogPageView:@"搜索页"];
    // wangmai
    TRSOperationInfo *pageInfo = [[TRSOperationInfo alloc] init];
    pageInfo.eventCode = @"A0010";
    pageInfo.pageType = @"搜索页";
    [TRSRequest TRSRecordGeneralWithDuration:pageInfo];
    
    // ------------------------埋点  14-----------------
    // umeng
    [MobClick event:@"1004"];
    // wangmai
    TRSOperationInfo *eventInfo = [[TRSOperationInfo alloc] init];
    eventInfo.eventCode = @"1004";
    eventInfo.eventName = @"返回";
    [TRSRequest TRSRecordGeneral:eventInfo];
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    self.navBgV.hidden = NO;
    [super viewDidAppear:animated];
}
- (void)dealloc{
    [self.navBgV removeFromSuperview];
}



@end
