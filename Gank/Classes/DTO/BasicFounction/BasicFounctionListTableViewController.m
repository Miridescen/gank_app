//
//  BasicFounctionListTableViewController.m
//  donews
//
//  Created by 牟松 on 16/3/24.
//  Copyright © 2016年 DoNews. All rights reserved.
//

#import "BasicFounctionListTableViewController.h"

#import "MyCollectionTVC.h"
#import "SettingTVC.h"
@interface BasicFounctionListTableViewController ()

@end

@implementation BasicFounctionListTableViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ------------------------埋点  2-----------------
    // umeng
    [MobClick beginLogPageView:@"菜单页面"];
    // wangmai
    [TRSRequest beginLogPageView];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // ------------------------埋点  2-----------------
    // umeng
    [MobClick endLogPageView:@"菜单页面"];
    // wangmai
    TRSOperationInfo *pageInfo = [[TRSOperationInfo alloc] init];
    pageInfo.eventCode = @"A0010";
    pageInfo.pageType = @"菜单页面";
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"技术干货铺";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self setUpNav];
}

- (void)setUpNav{
    
}
- (void)backButtonDidClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell  *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, MSScreenWidth*3/5, 80)];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /*
    if (indexPath.row == 0) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, 20, 20)];
        image.image = [UIImage imageNamed:@"002-star"];
        [cell.contentView addSubview:image];
        
        UILabel *lestLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 20, MSScreenWidth*3/5-52, 20)];
        lestLabel.text = @"我的收藏";
        lestLabel.textColor = RGBCOLOR(153, 164, 181);
        lestLabel.textAlignment = NSTextAlignmentLeft;
        lestLabel.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:lestLabel];
        
        
    }
     */
    if (indexPath.row == 0) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, 20, 20)];
        image.image = [UIImage imageNamed:@"001-settings"];
        [cell.contentView addSubview:image];
        
        UILabel *lestLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 20, MSScreenWidth*3/5-52, 20)];
        lestLabel.text = @"设置";
        lestLabel.textColor = RGBCOLOR(153, 164, 181);
        lestLabel.textAlignment = NSTextAlignmentLeft;
        lestLabel.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:lestLabel];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(18, 59, MSScreenWidth-36, 0.5)];
    lineView.backgroundColor = RGBCOLOR(232, 232, 232);
    [cell.contentView addSubview:lineView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if (indexPath.row == 0) {
        MyCollectionTVC *myCollection = [[MyCollectionTVC alloc] init];
        [self.navigationController pushViewController:myCollection animated:YES];
    }
     */
    if (indexPath.row == 0) {
        SettingTVC *setting = [[SettingTVC alloc] init];
        [self.navigationController pushViewController:setting animated:YES];
    }
    
}


@end
