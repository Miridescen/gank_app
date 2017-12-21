//
//  infoDetailVC.m
//  Gank
//
//  Created by 824810056 on 2017/12/14.
//  Copyright © 2017年 牟松. All rights reserved.
//

#import "infoDetailVC.h"
#import <WebKit/WebKit.h>
#import "ListDataModel.h"
#import <UShareUI/UShareUI.h>

@interface infoDetailVC ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkView;
@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation infoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"技术干货铺";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(UshareUI)];
    [self.view addSubview:self.progressView];
    [self.view insertSubview:self.wkView belowSubview:self.progressView];
    [_wkView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.urlStr]]]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ------------------------埋点  5-----------------
    // umeng
    [MobClick beginLogPageView:@"文章详情页"];
    // wangmai
    [TRSRequest beginLogPageView];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // ------------------------埋点  5-----------------
    // umeng
    [MobClick endLogPageView:@"文章详情页"];
    // wangmai
    TRSOperationInfo *pageInfo = [[TRSOperationInfo alloc] init];
    pageInfo.eventCode = @"A0010";
    pageInfo.pageType = @"文章详情页";
    pageInfo.objectID = [NSString stringWithFormat:@"%@", self.model._id];
    pageInfo.objectName = [NSString stringWithFormat:@"%@", self.model.desc];
    pageInfo.objectType = NewsType;
    pageInfo.number = @"1000";
    pageInfo.percentage = @"0.2";
    pageInfo.openStyle = CommonOpenStytle;
    pageInfo.selfObjectID = [NSString stringWithFormat:@"%@", self.model._id];
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
- (void)UshareUI{
    [UMSocialUIManager setPreDefinePlatforms:@[
                                               @(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine)
                                               ]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        NSString* thumbURL = nil;
        if (self.model.images.count>0) {
            thumbURL = self.model.images[0];
        }
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.desc descr:self.model.desc thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = self.model.url;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            
        }];
    }];
}
#pragma mark - WKWebView代理
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkView.estimatedProgress;
        if (self.progressView.progress == 1) {
            
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


// 记得取消监听
- (void)dealloc {
    [self.wkView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - lazy
- (WKWebView *)wkView
{
    if(!_wkView)
    {
        _wkView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MSScreenWidth, MSScreenHeight)];
        if (is_iPhoneX) {
            _wkView.frame = CGRectMake(0, 0, MSScreenWidth, MSScreenHeight);
        }
        _wkView.navigationDelegate = self;
        [_wkView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _wkView;
}

- (UIProgressView *)progressView
{
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, MSScreenWidth, 2)];
        if (is_iPhoneX) {
            _progressView.frame = CGRectMake(0, 88, MSScreenWidth, 2);
        }
        _progressView.backgroundColor = [UIColor blueColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        
    }
    return _progressView;
}


@end
