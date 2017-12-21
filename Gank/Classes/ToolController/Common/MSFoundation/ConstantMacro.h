//
//  ConstantMacro.h
//  Gank
//
//  Created by 824810056 on 2017/12/7.
//  Copyright © 2017年 牟松. All rights reserved.
//

#ifndef ConstantMacro_h
#define ConstantMacro_h

#define MSScreenHeight [[UIScreen mainScreen] bounds].size.height
#define MSScreenWidth  [[UIScreen mainScreen] bounds].size.width

#define is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//颜色创建
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#undef  RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#undef    HEX_RGB
#define HEX_RGB(V)        [UIColor colorWithRGBHex:V]

#ifdef DEBUG
#define TRSNSLog(FORMAT, ...) fprintf(stderr,"file__%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define TRSNSLog(...)
#endif

#define collectionDBPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/collection.db"]

#import "AFNetworkTool.h"
#import "YYModel.h"
#import "FMDB.h"
#import "MBProgressHUD.h"
#import "MBProgress+extend.h"
// TRS_SDK ------------------------------------
#import <trs_ta_sdk/TRSRequest.h>
#import <trs_ta_sdk/TRSOperationInfo.h>
// UM ----------------------------------------
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>
#import <UMShare/UMShare.h>

#endif /* ConstantMacro_h */
