//
//  BaseVC.h
//  Gank
//
//  Created by 824810056 on 2017/12/14.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BaseVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) UIActivityIndicatorView *actiView; // tableView中间的菊花

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) BOOL isPullup;
@property (nonatomic, assign) BOOL isDownRefresh;

@property (nonatomic, strong) UILabel *noDataL;

// 加载数据方法
- (void)loadData;

// tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
