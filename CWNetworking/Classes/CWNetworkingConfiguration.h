//
//  CWNetworkingConfiguration.h
//  Pods
//
//  Created by jack on 2021/12/29.
//

#ifndef CWNetworkingConfiguration_h
#define CWNetworkingConfiguration_h

#define CWNetworkingLog TRUE

typedef NS_ENUM(NSUInteger, CWResponseStatus) {
    // 底层仅有这四种状态
    CWResponseStatusSuccess,
    CWResponseStatusCancel,
    CWResponseStatusErrorTimeout,
    CWResponseStatusErrorUnknown
};

static BOOL kCWShouldCacheDefault = NO;
static BOOL kCWServiceIsOnline = NO;
static NSTimeInterval kCWNetworkingTimeoutSeconds = 20.0f;
static NSTimeInterval kCWCacheExpirationTimeDefault = 300; // 5分钟的cache过期时间


static NSString *kServerURL = @"https://api.douban.com";
#endif /* CWNetworkingConfiguration_h */
