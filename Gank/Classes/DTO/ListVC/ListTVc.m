//
//  ListTVc.m
//  Gank
//
//  Created by 824810056 on 2017/12/13.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "ListTVc.h"
#import "ConstantMacro.h"
#import "ListDataModel.h"
#import "UIImageView+WebCache.h"

@interface ListTVc()

@property (nonatomic, strong) UITextView *TitleL;
@property (nonatomic, strong) UILabel *TitleTagL;
@property (nonatomic, strong) UIImageView *MainIV;
@property (nonatomic, strong) UILabel *AuthorL;
@property (nonatomic, strong) UILabel *DateL;

@end

@implementation ListTVc

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubView];
    }
    return self;
}
- (void)setupSubView{
    _TitleL = [[UITextView alloc] init];
    _TitleL.textColor = [UIColor blackColor];
    _TitleL.font = [UIFont systemFontOfSize:14];
    _TitleL.userInteractionEnabled = NO;
    _TitleL.editable = NO;
    _TitleL.scrollsToTop = YES;
    [self addSubview:_TitleL];
    
    _TitleTagL = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 44, 14)];
    _TitleTagL.textAlignment = NSTextAlignmentCenter;
    _TitleTagL.layer.cornerRadius = 2.5f;
    _TitleTagL.layer.masksToBounds = YES;
    _TitleTagL.textColor = [UIColor whiteColor];
    _TitleTagL.font = [UIFont systemFontOfSize:10];
    [_TitleL addSubview:_TitleTagL];
    
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
    
    _DateL = [[UILabel alloc] initWithFrame:CGRectMake(169, 73, 80, 10)];
    _DateL.numberOfLines = 1;
    _DateL.textColor = [UIColor blackColor];
    _DateL.font = [UIFont systemFontOfSize:10];
    _DateL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_DateL];
    
    _MainIV = [[UIImageView alloc] initWithFrame:CGRectMake(MSScreenWidth-20-108, 15, 108, 72)];
    _MainIV.backgroundColor = [UIColor lightGrayColor];
    _MainIV.layer.cornerRadius = 2.5f;
    _MainIV.layer.masksToBounds = YES;
    [self addSubview:_MainIV];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(20, 99, MSScreenWidth-40, 0.5)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineV];
}
- (void)setModel:(ListDataModel *)model{
    _model = model;
    
    NSString *useStr = model.desc;
    if (model.desc.length > 57) {
        useStr = [model.desc substringWithRange:NSMakeRange(0, 57)];
    }
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    style.firstLineHeadIndent = 50.0f;
    style.allowsDefaultTighteningForTruncation = NO;
    style.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByCharWrapping;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:useStr attributes:@{ NSParagraphStyleAttributeName : style}];
    _TitleL.attributedText = attrText;
    
    _TitleTagL.text = model.type;
    if ([model.type isEqualToString:@"Android"]) {
        _TitleTagL.backgroundColor = RGBCOLOR(118, 178, 0);
    } else if ([model.type isEqualToString:@"iOS"]) {
        _TitleTagL.backgroundColor = RGBCOLOR(17, 118, 255);
    } else if ([model.type isEqualToString:@"前端"]) {
        _TitleTagL.backgroundColor = RGBCOLOR(241, 143, 56);
    } else if ([model.type isEqualToString:@"瞎推荐"]) {
        _TitleTagL.backgroundColor = RGBCOLOR(210, 0, 89);
    } else if ([model.type isEqualToString:@"拓展资源"]) {
        _TitleTagL.backgroundColor = RGBCOLOR(133, 143, 255);
    } else if ([model.type isEqualToString:@"App"]) {
        _TitleTagL.backgroundColor = RGBCOLOR(40, 197, 255);
    } else {
        _TitleTagL.backgroundColor = RGBCOLOR(189, 143, 255);
    }
    
    
    
    _AuthorL.text = model.who;
    
    
    if (model.images.count>0) {
        _TitleL.frame = CGRectMake(20, 15, MSScreenWidth-60-108, 52);
        _MainIV.hidden = NO;
        [_MainIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.images[0]]]];
    } else {
        _MainIV.hidden = YES;
        _TitleL.frame = CGRectMake(20, 15, MSScreenWidth-40, 52);
    }
    
    
    if (model.publishedAt.length >= 24) {
        NSString *montdStr = [model.publishedAt substringWithRange:NSMakeRange(5, 5)];
        NSString *hourStr = [model.publishedAt substringWithRange:NSMakeRange(11, 5)];
        _DateL.text = [NSString stringWithFormat:@"%@ %@", montdStr, hourStr];
        
    }
    
    
}

@end
