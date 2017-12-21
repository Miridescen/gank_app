//
//  MyCollectionTVC.m
//  Gank
//
//  Created by 824810056 on 2017/12/14.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "MyCollectionTVC.h"
#import "ListDataModel.h"
#import "ListTVc.h"
#import "infoDetailVC.h"

@interface MyCollectionTVC ()
@property (nonatomic, strong) NSMutableArray *dateArray;

@property (nonatomic, strong) UILabel *noDataLabel; // 没有数据时显示
@end

@implementation MyCollectionTVC
- (UILabel *)noDataLabel{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake((MSScreenWidth-100)/2, 70, 100, 30)];
        _noDataLabel.text = @"暂无收藏";
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.textColor = [UIColor grayColor];
        _noDataLabel.font = [UIFont systemFontOfSize:24];
    }
    return _noDataLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setUpNav];
    
    [self getDateFromDB];
    
    if (self.dateArray.count == 0) {
        [self.tableView addSubview:self.noDataLabel];
    }
}
- (void)getDateFromDB{
    self.dateArray = [NSMutableArray array];
    FMDatabase *collectionDB = [FMDatabase databaseWithPath:collectionDBPath];
    if (collectionDB) {
        [collectionDB open];
        NSString * selectSql = [NSString stringWithFormat:
                                @"SELECT * FROM CollectionTable"];
        FMResultSet * rs = [collectionDB executeQuery:selectSql];
        while ([rs next]) {
            ListDataModel *model = [[ListDataModel alloc] init];
            model._id = [rs stringForColumn:@"_id"];
            model.createdAt = [rs stringForColumn:@"createdAt"];
            model.desc = [rs stringForColumn:@"desc"];
            model.publishedAt = [rs stringForColumn:@"publishedAt"];
            model.source = [rs stringForColumn:@"source"];
            model.type = [rs stringForColumn:@"type"];
            
            model.url = [rs stringForColumn:@"url"];
            model.used = [rs stringForColumn:@"used"];
            model.who = [rs stringForColumn:@"who"];
            model.images = @[[rs stringForColumn:@"images"]];
            
            [self.dateArray insertObject:model atIndex:0];
        }
        
        
        [collectionDB close];
        
    }
}
- (void)setUpNav{
    self.navigationItem.title = @"我的收藏";
    
}

- (void)backButtonDidClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *collectionCell = [NSString stringWithFormat:@"collectionCell"];
    ListTVc *cell = [tableView dequeueReusableCellWithIdentifier:collectionCell];
    if (!cell) {
        cell = [[ListTVc alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:collectionCell];
    }
    cell.model = self.dateArray[indexPath.row];
    return  cell;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    infoDetailVC *detail = [[infoDetailVC alloc] init];
    ListDataModel *model = (ListDataModel *)self.dateArray[indexPath.row];
    detail.urlStr = model.url;
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ListDataModel *model = self.dateArray[indexPath.row];
    [self.dateArray removeObjectAtIndex:[indexPath row]];  //删除_data数组里的数据
    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
    FMDatabase *collectionDB = [FMDatabase databaseWithPath:collectionDBPath];
    if (collectionDB) {
        [collectionDB open];
        NSString * deleateSql = [NSString stringWithFormat:@"DELETE FROM CollectionTable WHERE _id = %@", model._id];
        [collectionDB executeUpdate:deleateSql];
        
        [collectionDB close];
        
    }
    
}


@end
