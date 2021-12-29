//
//  CWBaseAPIManager.h
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "CWResponseModel.h"

@class CWBaseAPIManager;
extern NSString * const kCWAPIBaseManagerRequestId;

NS_ASSUME_NONNULL_BEGIN

// For transfer data
@protocol CWAPIManagerDataReformer <NSObject>
@required
- (id)apiManager:(CWBaseAPIManager *)manager reformData:(NSDictionary *)data;
@end


typedef NS_ENUM (NSUInteger, CWRequestType){
    CWRequestTypeGet,
    CWRequestTypePost,
};

typedef NS_ENUM (NSInteger, CWAPIManagerResponseStatus){
    CWAPIManagerResponseStatusDefault = -1,             //没有产生过API请求，默认状态。
    CWAPIManagerResponseStatusTimeout = 101,            //请求超时
    CWAPIManagerResponseStatusNoNetwork = 102,          //网络不通
    CWAPIManagerResponseStatusSuccess = 200,            //API请求成功且返回数据正确
    CWAPIManagerResponseStatusParsingError = 201,       //API请求成功但返回数据不正确
    CWAPIManagerResponseStatusTokenExpired = 300,       //token过期
    CWAPIManagerResponseStatusNeedLogin = 301,          //认证信息无效
    CWAPIManagerResponseStatusRequestError = 400,       //请求出错，参数或方法错误
    CWAPIManagerResponseStatusTypeServerCrash = 500,    //服务器出错
    CWAPIManagerResponseStatusTypeServerMessage = 600,  //服务器自定义消息
};

@protocol CWAPIManager <NSObject>
@required
- (NSString *)path;
- (NSString *)apiVersion;
- (BOOL)isAuth;

@optional
- (CWRequestType)requestType;
- (BOOL)isResponseJSONable;
- (BOOL)isRequestUsingJSON;

- (BOOL)shouldCache;
- (NSInteger)cacheExpirationTime; // 返回0或者负数则永不过期
@end

@protocol CWAPIManagerDataSource <NSObject>
@required
- (NSDictionary *)paramsForAPI:(CWBaseAPIManager *)manager;
@end


@protocol CWAPIManagerDelegate <NSObject>
@required
- (void)apiManagerLoadDataSuccess:(CWBaseAPIManager *)apiManager;
- (void)apiManager:(CWBaseAPIManager *)apiManager loadDataFail:(CWResponseError *)error;

@optional
- (void)apiManagerLoadDidCancel:(CWBaseAPIManager *)apiManager;
@end



@protocol CWAPIManagerInterceptor <NSObject>
@optional
- (BOOL)apiManager:(CWBaseAPIManager *)manager beforePerformSuccessWithResponseModel:(CWResponseModel *)responsemodel;
- (void)apiManager:(CWBaseAPIManager *)manager afterPerformSuccessWithResponseModel:(CWResponseModel *)responseModel;

- (BOOL)apiManager:(CWBaseAPIManager *)manager beforePerformFailWithResponseError:(CWResponseError *)error;
- (void)apiManager:(CWBaseAPIManager *)manager afterPerformFailWithResponseError:(CWResponseError *)error;

- (void)afterPerformCancel:(CWBaseAPIManager *)manager;

- (BOOL)apiManager:(CWBaseAPIManager *)manager shouldLoadRequestWithParams:(NSDictionary *)params;
- (void)apiManager:(CWBaseAPIManager *)manager afterLoadRequestWithParams:(NSDictionary *)params;
@end

@interface CWBaseAPIManager : NSObject
@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, readonly) dispatch_semaphore_t continueMutex;

@property (nonatomic, weak) id<CWAPIManagerDataSource> dataSource;
@property (nonatomic, weak) id<CWAPIManagerDelegate> delegate;
@property (nonatomic, weak) id<CWAPIManagerInterceptor> interceptor;

// addDependency和removeDependency仅在loadData前执行有效
- (void)addDependency:(CWBaseAPIManager *)apiManager;
- (void)removeDependency:(CWBaseAPIManager *)apiManager;

- (NSInteger)loadData;
- (NSInteger)loadDataWithoutCache;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

- (BOOL)isReachable;

- (id)fetchData;
- (id)fetchDataWithReformer:(id<CWAPIManagerDataReformer>)reformer;
- (id)fetchDataFromModel:(Class)clazz; //默认只实现单个model，且对应model字段为data，否则需重写这个方法

- (NSDictionary *)reformParams:(NSDictionary *)params;

// default
- (NSString *)host;
- (CWRequestType)requestType;   //default is YLRequestTypePost;
- (BOOL)isResponseJSONable;     //default is YES;
- (BOOL)isRequestUsingJSON;     //default is YES;

- (NSInteger)cacheExpirationTime; // 返回0或者负数则永不过期

#pragma mark - 拦截器
// 用于子类需要监听相关事件，覆盖时需调用super对应方法
- (BOOL)beforePerformSuccessWithResponseModel:(CWResponseModel *)responseModel;
- (void)afterPerformSuccessWithResponseModel:(CWResponseModel *)responseModel;

- (BOOL)beforePerformFailWithResponseError:(CWResponseError *)error;
- (void)afterPerformFailWithResponseError:(CWResponseError *)error;

- (void)afterPerformCancel;

- (BOOL)shouldLoadRequestWithParams:(NSDictionary *)params;
- (void)afterLoadRequestWithParams:(NSDictionary *)params;

#pragma mark - 校验
// 需要校验则重写此方法
- (BOOL)isResponseDataCorrect:(CWResponseModel *)reponseModel;
@end

NS_ASSUME_NONNULL_END
