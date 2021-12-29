//
//  CWTokenRefresher.h
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import "CWBaseAPIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CWTokenRefresher : CWBaseAPIManager<CWAPIManager>
- (void)needRefresh;


+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
