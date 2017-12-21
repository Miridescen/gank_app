//
//  ListDataModel.h
//  Gank
//
//  Created by 824810056 on 2017/12/13.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListDataModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *publishedAt;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *used;
@property (nonatomic, copy) NSString *who;
@property (nonatomic, strong) NSArray *images;

@end
