//
//  SettingTVC.m
//  Gank
//
//  Created by 824810056 on 2017/12/14.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "SettingTVC.h"

#import "HelpVC.h"
#import "AbothUsVC.h"

@interface SettingTVC ()
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation SettingTVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.titleArray = @[@"帮助与反馈", @"关于技术干货铺"];
    [self setUpNav];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ------------------------埋点  3-----------------
    // umeng
    [MobClick beginLogPageView:@"设置页"];
    // wangmai
    [TRSRequest beginLogPageView];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // ------------------------埋点  3-----------------
    // umeng
    [MobClick endLogPageView:@"设置页"];
    // wangmai
    TRSOperationInfo *pageInfo = [[TRSOperationInfo alloc] init];
    pageInfo.eventCode = @"A0010";
    pageInfo.pageType = @"设置页";
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
- (void)setUpNav{
    self.navigationItem.title = @"设置";
}
- (void)backButtonDidClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(18, 56, MSScreenWidth-36, 0.5)];
    lineView.backgroundColor = RGBCOLOR(232, 232, 232);
    [cell.contentView addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16+16, 0, 200, 57)];
    titleLabel.textColor = RGBCOLOR(153, 164, 181);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = self.titleArray[indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [cell.contentView addSubview:titleLabel];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HelpVC *helpVC = [[HelpVC alloc] init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }
    if (indexPath.row == 1) {
        AbothUsVC *tongyong = [[AbothUsVC alloc] init];
        [self.navigationController pushViewController:tongyong animated:YES];
    }
    
}

@end
