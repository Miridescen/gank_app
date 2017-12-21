//
//  HelpVC.m
//  Gank
//
//  Created by 824810056 on 2017/12/14.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "HelpVC.h"
#import "LiveMessageTV.h"

@interface HelpVC ()<UITextViewDelegate>
@property (nonatomic, strong) LiveMessageTV *messageTV;
@end

@implementation HelpVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ------------------------埋点  4-----------------
    // umeng
    [MobClick beginLogPageView:@"帮助与反馈页"];
    // wangmai
    [TRSRequest beginLogPageView];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // ------------------------埋点  4-----------------
    // umeng
    [MobClick endLogPageView:@"帮助与反馈页"];
    // wangmai
    TRSOperationInfo *pageInfo = [[TRSOperationInfo alloc] init];
    pageInfo.eventCode = @"A0010";
    pageInfo.pageType = @"帮助与反馈页";
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupnav];
    [self setupsubview];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)setupnav{
    self.navigationItem.title = @"帮助与反馈";
    
}
- (void)setupsubview{
    _messageTV = [[LiveMessageTV alloc] initWithFrame:CGRectMake(20, 20+64, MSScreenWidth-40, 150)];
    if (is_iPhoneX) {
        _messageTV.frame = CGRectMake(20, 20+64+24, MSScreenWidth-40, 150);
    }
    _messageTV.layer.borderColor = RGBCOLOR(207, 207, 207).CGColor;
    _messageTV.layer.borderWidth = 1;
    _messageTV.layer.cornerRadius = 6;
    _messageTV.layer.masksToBounds = YES;
    _messageTV.delegate = self;
    _messageTV.placeholde = @"请填写具体内容帮助我们了解您的意见与建议";
    [self.view addSubview:_messageTV];
    
    UIButton *putinButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 190+64, MSScreenWidth-80, 50)];
    if (is_iPhoneX) {
        putinButton.frame = CGRectMake(40, 190+64+24, MSScreenWidth-80, 50);
    }
    putinButton.backgroundColor = RGBCOLOR(17, 118, 255);
    [putinButton setTitle:@"提交" forState:UIControlStateNormal];
    [putinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [putinButton addTarget:self action:@selector(putinMessage:) forControlEvents:UIControlEventTouchUpInside];
    putinButton.layer.cornerRadius = 6;
    putinButton.layer.masksToBounds = YES;
    [self.view addSubview:putinButton];
}
- (void)backButtonDidClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)putinMessage:(UIButton *)button{
    
    if (_messageTV.text.length == 0) {
        [self logAlertViewWithStr:@"内容不能为空"];
        return;
    }
    // ------------------------埋点  11-----------------
    // umeng
    [MobClick event:@"1000"];
    // wangmai
    TRSOperationInfo *eventInfo = [[TRSOperationInfo alloc] init];
    eventInfo.eventCode = @"1000";
    eventInfo.eventName = @"提交帮助反馈";
    [TRSRequest TRSRecordGeneral:eventInfo];
    
    
    
    [MBProgressHUD showSuccess:@"反馈内容已经提交"];
    
}
- (void)logAlertViewWithStr:(NSString *)str{
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    [control addAction:action];
    [self presentViewController:control animated:YES completion:^{
        
    }];
}

@end
