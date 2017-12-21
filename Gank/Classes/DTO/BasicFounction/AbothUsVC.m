//
//  AbothUsVC.m
//  Gank
//
//  Created by 824810056 on 2017/12/14.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "AbothUsVC.h"

@interface AbothUsVC ()

@end

@implementation AbothUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupnav];
    [self setupsubview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ------------------------埋点  6-----------------
    // umeng
    [MobClick beginLogPageView:@"关于页"];
    // wangmai
    [TRSRequest beginLogPageView];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // ------------------------埋点  6-----------------
    // umeng
    [MobClick endLogPageView:@"关于页"];
    // wangmai
    TRSOperationInfo *pageInfo = [[TRSOperationInfo alloc] init];
    pageInfo.eventCode = @"A0010";
    pageInfo.pageType = @"关于页";
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
- (void)setupnav{
    self.navigationItem.title = @"关于技术干货铺";
    
}
- (void)setupsubview{
    UIView *logView = [[UIView alloc] initWithFrame:CGRectMake((MSScreenWidth-300)/2, (MSScreenHeight-300)/2-100+64, 300, 300)];
    logView.backgroundColor = [UIColor clearColor];
    
    UIImageView *logImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 80, 150, 150)];
    logImageView.backgroundColor = [UIColor clearColor];
    logImageView.image = [UIImage imageNamed:@"logo"];
    [logView addSubview:logImageView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, 300, 20)];
    label.text = [NSString stringWithFormat:@"版本号：%@",[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
    label.textColor = RGBCOLOR(153, 164, 181);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [logView addSubview:label];
    
    if (is_iPhoneX) {
        logView.frame = CGRectMake((MSScreenWidth-300)/2, (MSScreenHeight-300)/2-100+64+24, 300, 300);
    }
    [self.view addSubview:logView];
    
    
}
- (void)backButtonDidClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
