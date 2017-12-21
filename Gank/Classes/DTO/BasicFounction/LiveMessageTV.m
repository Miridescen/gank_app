//
//  LiveMessageTV.m
//  Gank
//
//  Created by 824810056 on 2017/12/18.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "LiveMessageTV.h"

@implementation LiveMessageTV

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanges) name:UITextViewTextDidChangeNotification object:self];
        self.font = [UIFont systemFontOfSize:15];
    }
    
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholde = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    if (self.hasText) return;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [self.placeholde drawInRect:CGRectMake(10, 10, 320, 20) withAttributes:attrs];
}

- (void)textDidChanges{
    [self setNeedsDisplay];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
