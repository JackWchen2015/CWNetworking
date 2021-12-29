//
//  MJRefreshHeader+ReactiveExtension.h
//  AFNetworking
//
//  Created by jack on 2021/12/29.
//

#import <MJRefresh/MJRefresh.h>
#import "MJRefresh.h"
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface MJRefreshHeader (ReactiveExtension)
+ (instancetype)headerWithRefreshingCommand:(RACCommand *)refreshingCommand;

@end

@interface MJRefreshFooter(ReactiveExtension)
+ (instancetype)footerWithRefreshingCommand:(RACCommand *)refreshingCommand;
@end

NS_ASSUME_NONNULL_END
