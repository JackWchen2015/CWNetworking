//
//  CWNetworking+ReactiveExtension.h
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//


#import "CWBaseAPIManager.h"
#import "CWPageAPIManager.h"
#import "NSMapTable+CWNetworking.h"
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@protocol CWNetworkingRACOperationProtocol;
typedef NSMapTable<NSString *,id<CWNetworkingRACOperationProtocol>> CWNetworkingRACTable;

@protocol CWNetworkingRACOperationProtocol<NSObject>
- (RACCommand *)requestCommand;
- (RACCommand *)cancelCommand;
- (RACSignal *)requestErrorSignal;
- (RACSignal *)executionSignal;
@end

@protocol CWNetworkingListRACOperationProtocol<CWNetworkingRACOperationProtocol>
- (RACCommand *)refreshCommand;
- (RACCommand *)requestNextPageCommand;
@end

@protocol CWNetworkingRACProtocol <NSObject>

@optional
- (id<CWNetworkingRACOperationProtocol>)networkingRAC;
// 定义枚举在这允许获取多个APIManager的RAC
- (CWNetworkingRACTable *)networkingRACs;
@end

@protocol CWNetworkingListRACProtocol <NSObject>
@required
- (id<CWNetworkingListRACOperationProtocol>)networkingRAC;
@end

@interface CWBaseAPIManager (ReactiveExtension)<CWNetworkingRACOperationProtocol>
@property (nonatomic, strong, readonly) RACCommand *requestCommand;
@property (nonatomic, strong, readonly) RACCommand *cancelCommand;
@property (nonatomic, strong, readonly) RACSignal *requestErrorSignal; //已为主线程
@property (nonatomic, strong, readonly) RACSignal *executionSignal;

- (RACSignal *)requestSignal;
@end

@interface CWPageAPIManager (ReactiveExtension)<CWNetworkingListRACOperationProtocol>
@property (nonatomic, strong, readonly) RACCommand *refreshCommand;
@property (nonatomic, strong, readonly) RACCommand *requestNextPageCommand;
@end

@interface RACCommand (CWExtension)
@property (nonatomic, assign, setter=cw_setTimestamp:) NSTimeInterval cw_timestamp;
// 尝试execute，但是需要与上次执行的间隔大于seconds才会执行
- (BOOL)tryExecuteIntervalLongerThan:(NSInteger)seconds;
@end
NS_ASSUME_NONNULL_END
