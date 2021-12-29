//
//  CWTokenRefresher.m
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import "CWTokenRefresher.h"

@implementation CWTokenRefresher
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static CWTokenRefresher *instance;
    dispatch_once(&onceToken, ^{
        instance = [CWTokenRefresher new];
        
        // 默认有效
        dispatch_semaphore_signal(instance.continueMutex);
    });
    return instance;
}

- (NSString *)path {
    return @"updateToken";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    // 这里一定是NO，否则会让TokenRefresher依赖自己从而产生死锁
    return NO;
}

- (BOOL)shouldCache {
    return NO;
}


- (void)afterLoadRequestWithParams:(NSDictionary *)params {
    [super afterLoadRequestWithParams:params];
    
    // 请求并持有
    dispatch_semaphore_wait(self.continueMutex, DISPATCH_TIME_FOREVER);
    // 由于在基类中，当请求加载完毕时会进行dispatch_semaphore_signal，所以在此只考虑持有，不考虑释放
}


- (BOOL)beforePerformSuccessWithResponseModel:(CWResponseModel *)responseModel {
    [super beforePerformSuccessWithResponseModel:responseModel];
    // 在此写更新本地token的逻辑
    
    return YES;
}

- (BOOL)beforePerformFailWithResponseError:(CWResponseError *)error {
    [super beforePerformFailWithResponseError:error];
    // 在此写更新token失败的逻辑
    
    
    return YES;
}

- (void)needRefresh {
    if (!self.isLoading) {
        [self loadData];
    }
}

#pragma mark - CWAPIManagerDataSource

- (NSDictionary *)paramsForAPI:(CWBaseAPIManager *)manager {
    // 在此写参数
    
    
    return nil;
}

@end
