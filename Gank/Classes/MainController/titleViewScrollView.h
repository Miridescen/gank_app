//
//  titleViewScrollView.h
//  donews
//
//  Created by 牟松 on 16/3/21.
//  Copyright © 2016年 DoNews. All rights reserved.
//

#import <UIKit/UIKit.h>
@class titleViewScrollView;

@protocol titleViewScrollViewDelegate <NSObject>

@optional
- (void)titleButtonDidClickWithCurrentTitleNO:(NSInteger)currentTitleNO;

@end

@interface titleViewScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray<NSString *> *titleArray; //放所有标题的名字

@property (nonatomic, assign) NSInteger currentTitleNO;
@property (nonatomic, assign) NSInteger totleTitlesNO;

@property (nonatomic, assign) CGFloat contentOfSetX;

@property (nonatomic, assign) id<titleViewScrollViewDelegate> delegate;



- (instancetype)initWithTitleArray:(NSArray *)titleArray;
@end
