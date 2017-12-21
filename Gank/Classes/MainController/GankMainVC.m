//
//  GankMainVC.m
//  Gank
//
//  Created by 824810056 on 2017/12/14.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "GankMainVC.h"

#import "titleViewScrollView.h"
#import "BasicFounctionListTableViewController.h"
#import "ListMainVC.h"
#import "SearchTVC.h"


#import "BaseVC.h"

@interface GankMainVC ()<UIScrollViewDelegate, titleViewScrollViewDelegate>{
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
}
@property (nonatomic, strong) NSArray<UIViewController *> *subViewControllersArray;
@property (nonatomic, strong) NSArray *subViewControllerTitleArray; // 放控制器title的数组
@property (nonatomic, strong) UIScrollView *mainScrollerView;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, strong) titleViewScrollView *titleView;

@property (nonatomic, assign) CGFloat subControllerNumber;
@end

@implementation GankMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBasiData];
    [self setupNav];
    [self configSubController];
    [self configSubView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ------------------------埋点  1-----------------
    // umeng
    [MobClick beginLogPageView:@"首页列表页"];
    // wangmai
    [TRSRequest beginLogPageView];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // ------------------------埋点  1-----------------
    // umeng
    [MobClick endLogPageView:@"首页列表页"];
    // wangmai
    TRSOperationInfo *pageInfo = [[TRSOperationInfo alloc] init];
    pageInfo.eventCode = @"A0010";
    pageInfo.objectType = ColumnType;
    pageInfo.pageType = @"首页列表页";
    [TRSRequest TRSRecordGeneralWithDuration:pageInfo];
    
    
}

- (void)configBasiData{
    _subViewControllerTitleArray = @[@"首页",@"iOS",@"Android",@"App",@"前端",@"瞎推荐",@"拓展资源"];
    _subViewControllersArray = [@[] mutableCopy];
}
- (void)setupNav{
    
    self.navigationItem.titleView = self.titleView;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UIBarButtonItem *liftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(listButtonDidClick)];
    self.navigationItem.leftBarButtonItem = liftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonDidClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)configSubController{
    NSMutableArray *controllerArr = [@[] mutableCopy];
    for (NSInteger i = 0; i<_subViewControllerTitleArray.count; i++) {
        ListMainVC  *listVC = [[ListMainVC alloc] init];
        listVC.view.backgroundColor = [UIColor whiteColor];
        listVC.title = _subViewControllerTitleArray[i];
        listVC.tag = [NSString stringWithFormat:@"%@", _subViewControllerTitleArray[i]];
        [controllerArr addObject:listVC];
    }
    self.subViewControllersArray = controllerArr;
    self.subControllerNumber = self.subViewControllersArray.count;
}
- (void)configSubView{
    
    [self.view addSubview:self.mainScrollerView];
    
    [self.subViewControllersArray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *subVC = (UIViewController *)_subViewControllersArray[idx];
        subVC.view.frame = CGRectMake(idx*MSScreenWidth, 0, MSScreenWidth, MSScreenHeight-64);
        [self.mainScrollerView addSubview:subVC.view];
        [self addChildViewController:subVC];
        
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger i = ((scrollView.contentOffset.x-1)/(MSScreenWidth/2)+1)/2;
    self.titleView.contentOfSetX = (CGFloat)(scrollView.contentOffset.x*70)/MSScreenWidth;
    self.navigationItem.title = self.subViewControllerTitleArray[i];
    self.titleView.currentTitleNO = i;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{    //拖动前的起始坐标
    
    startContentOffsetX = scrollView.contentOffset.x;
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{    //将要停止前的坐标
    willEndContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    endContentOffsetX = scrollView.contentOffset.x;
    
    if (endContentOffsetX < willEndContentOffsetX && willEndContentOffsetX < startContentOffsetX) { //画面从右往左移动，前一页
        // ------------------------埋点  13-----------------
        // umeng
        [MobClick event:@"1003"];
        // wangmai
        TRSOperationInfo *eventInfo = [[TRSOperationInfo alloc] init];
        eventInfo.eventCode = @"1003";
        eventInfo.eventName = @"切换频道";
        [TRSRequest TRSRecordGeneral:eventInfo];
        
        
    } else if (endContentOffsetX > willEndContentOffsetX && willEndContentOffsetX > startContentOffsetX) {//画面从左往右移动，后一页
//        NSLog(@"scrollView.contentOffset.x = %f", scrollView.contentOffset.x);
        
        NSInteger currentTitleNO = ((scrollView.contentOffset.x-1)/(MSScreenWidth/2)+1)/2;
        
        for (int i = 0; i <= self.subViewControllersArray.count-1; i++) {
            ListMainVC *homeVC = (ListMainVC *)self.subViewControllersArray[i];
            if (i == currentTitleNO) {
                homeVC.tag = [NSString stringWithFormat:@"%@", self.subViewControllerTitleArray[currentTitleNO]];
            }
        }
        
        // ------------------------埋点  13-----------------
        // umeng
        [MobClick event:@"1003"];
        // wangmai
        TRSOperationInfo *eventInfo = [[TRSOperationInfo alloc] init];
        eventInfo.eventCode = @"1003";
        eventInfo.eventName = @"切换频道";
        [TRSRequest TRSRecordGeneral:eventInfo];
    
    }
    startContentOffsetX = 0;
    willEndContentOffsetX = 0;
    endContentOffsetX = 0;
    
    
    
}

#pragma mark - titleViewScrollViewDelegate
- (void)titleButtonDidClickWithCurrentTitleNO:(NSInteger)currentTitleNO{
    [self.mainScrollerView setContentOffset:CGPointMake(MSScreenWidth*currentTitleNO, -64) animated:YES];
    for (int i = 0; i <= self.subViewControllersArray.count-1; i++) {
        ListMainVC *homeVC = (ListMainVC *)self.subViewControllersArray[i];
        if (i == currentTitleNO) {
            homeVC.tag = [NSString stringWithFormat:@"%@", self.subViewControllerTitleArray[currentTitleNO]];
        }
    }
    
    // ------------------------埋点  13-----------------
    // umeng
    [MobClick event:@"1003"];
    // wangmai
    TRSOperationInfo *eventInfo = [[TRSOperationInfo alloc] init];
    eventInfo.eventCode = @"1003";
    eventInfo.eventName = @"切换频道";
    [TRSRequest TRSRecordGeneral:eventInfo];
}


#pragma mark -- btnClickMethod
- (void)listButtonDidClick{
    BasicFounctionListTableViewController *listTVC = [[BasicFounctionListTableViewController alloc] init];
    [self.navigationController pushViewController:listTVC animated:YES];
    
}
- (void)searchButtonDidClick{
    SearchTVC *searchVC = [[SearchTVC alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}
#pragma mark -- getter or setter
- (UIScrollView *)mainScrollerView{
    if (!_mainScrollerView) {
        _mainScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MSScreenWidth, MSScreenHeight)];
        _mainScrollerView.contentSize = CGSizeMake(MSScreenWidth*_subControllerNumber, 0);
        _mainScrollerView.backgroundColor = [UIColor whiteColor];
        _mainScrollerView.pagingEnabled = YES;
        _mainScrollerView.delegate = self;
        _mainScrollerView.showsHorizontalScrollIndicator = NO;
        _mainScrollerView.showsVerticalScrollIndicator = NO;
        _mainScrollerView.scrollEnabled = YES;
        _mainScrollerView.bounces = NO;
        _mainScrollerView.scrollsToTop = NO;
    }
    return _mainScrollerView;
}
- (titleViewScrollView *)titleView{
    if (!_titleView) {
        self.titleView = [[titleViewScrollView alloc] initWithTitleArray:self.subViewControllerTitleArray];
        self.titleView.delegate = self;
        self.titleView.titleArray = self.subViewControllerTitleArray;
    }
    return _titleView;
}

@end
