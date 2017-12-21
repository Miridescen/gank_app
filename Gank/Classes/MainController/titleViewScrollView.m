//
//  titleViewScrollView.m
//  donews
//
//  Created by 牟松 on 16/3/21.
//  Copyright © 2016年 DoNews. All rights reserved.
//

#import "titleViewScrollView.h"

@interface titleViewScrollView ()<UIScrollViewDelegate>


@end

@implementation titleViewScrollView

- (instancetype)initWithTitleArray:(NSArray *)titleArray{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(60, 0, 216, 30);
        self.backgroundColor = [UIColor clearColor];
        
        self.totleTitlesNO = titleArray.count;
        
        self.titleArray = titleArray;
        
        self.currentTitleNO = 0;
        
        self.contentOfSetX = 0;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width/4*(_totleTitlesNO+3), 0);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.bounces = NO;
        
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipResponse)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [_scrollView addGestureRecognizer:leftSwipe];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipResponse)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [_scrollView addGestureRecognizer:rightSwipe];
        

        [self addSubview:_scrollView];
        
    }
    return self;
}

- (void)setCurrentTitleNO:(NSInteger)currentTitleNO{
    _currentTitleNO = currentTitleNO;
    for (UIButton *btn in [_scrollView subviews]) {
        if (btn.tag-10000 == _currentTitleNO) {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }

    
}
- (void)setTotleTitlesNO:(NSInteger)totleTitlesNO{
    _totleTitlesNO = totleTitlesNO;
    
    
}
- (void)setContentOfSetX:(CGFloat)contentOfSetX{
    _contentOfSetX = contentOfSetX;
    
    [_scrollView setContentOffset:CGPointMake(_contentOfSetX, 0)];

}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray{
    
    _titleArray = titleArray;
    
    
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((i*70)+81, 0, 70, 30)];
        
        btn.tag = 10000+i;
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitle:[NSString stringWithFormat:@"%@", _titleArray[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(ButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
    
    
    
}
- (void)ButtonDidClick:(UIButton *)button{
    NSInteger buttonTag = button.tag-10000;
    
    self.currentTitleNO = buttonTag;
    if ([self.delegate respondsToSelector:@selector(titleButtonDidClickWithCurrentTitleNO:)]) {
        [self.delegate titleButtonDidClickWithCurrentTitleNO:buttonTag];
    }
    
}


- (void)leftSwipResponse{
    if (self.currentTitleNO == 6) {
        return;
    }
    self.currentTitleNO += 1;
    
    if ([self.delegate respondsToSelector:@selector(titleButtonDidClickWithCurrentTitleNO:)]) {
        [self.delegate titleButtonDidClickWithCurrentTitleNO:self.currentTitleNO];
    }
}
- (void)rightSwipResponse{
    if (self.currentTitleNO == 0) {
        return;
    }
    
    self.currentTitleNO -= 1;
    
    if ([self.delegate respondsToSelector:@selector(titleButtonDidClickWithCurrentTitleNO:)]) {
        [self.delegate titleButtonDidClickWithCurrentTitleNO:self.currentTitleNO];
    }
}


@end
