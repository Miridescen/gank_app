//
//  SearchTVCell.m
//  Gank
//
//  Created by 824810056 on 2017/12/15.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "SearchTVCell.h"
#import "SearchDataModel.h"
@interface SearchTVCell()
@property (nonatomic, strong) UILabel *TitleL;
@property (nonatomic, strong) UIImageView *MainIV;
@property (nonatomic, strong) UILabel *AuthorL;
@property (nonatomic, strong) UILabel *DateL;
@end
@implementation SearchTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubView];
    }
    return self;
}
- (void)setupSubView{
    _TitleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, MSScreenWidth-40, 52)];
    _TitleL.textColor = [UIColor blackColor];
    _TitleL.font = [UIFont systemFontOfSize:14];
    _TitleL.numberOfLines = 0;
    [self addSubview:_TitleL];
    
    UIImageView *authorLogIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 73, 10, 14)];
    authorLogIV.image = [UIImage imageNamed:@"Forma1"];
    [self addSubview:authorLogIV];
    
    _AuthorL = [[UILabel alloc] initWithFrame:CGRectMake(33, 75, 120, 10)];
    _AuthorL.numberOfLines = 1;
    _AuthorL.textColor = [UIColor blackColor];
    _AuthorL.font = [UIFont systemFontOfSize:10];
    _AuthorL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_AuthorL];
    
    UIImageView *dateLogIV = [[UIImageView alloc] initWithFrame:CGRectMake(153, 73, 13, 13)];
    dateLogIV.image = [UIImage imageNamed:@"Forma2"];
    [self addSubview:dateLogIV];
    
    _DateL = [[UILabel alloc] initWithFrame:CGRectMake(169, 75, 80, 10)];
    _DateL.numberOfLines = 1;
    _DateL.textColor = [UIColor blackColor];
    _DateL.font = [UIFont systemFontOfSize:10];
    _DateL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_DateL];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 99, MSScreenWidth-40, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    
}
- (void)setModel:(SearchDataModel *)model{
    _model = model;

    _TitleL.text = model.desc;
    

    _AuthorL.text = model.who;
    
   
    if (model.publishedAt.length >= 24) {
        NSString *montdStr = [model.publishedAt substringWithRange:NSMakeRange(5, 5)];
        NSString *hourStr = [model.publishedAt substringWithRange:NSMakeRange(11, 5)];
        _DateL.text = [NSString stringWithFormat:@"%@ %@", montdStr, hourStr];
        
    }
    
    
}

@end
