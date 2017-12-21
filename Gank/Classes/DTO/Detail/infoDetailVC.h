//
//  infoDetailVC.h
//  Gank
//
//  Created by 824810056 on 2017/12/14.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListDataModel;
@interface infoDetailVC : UIViewController

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) ListDataModel *model;

@end
