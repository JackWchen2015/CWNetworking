//
//  CWAPIProxy.m
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import "CWAPIProxy.h"
#import <AFNetworking/AFNetworking.h>
#import "CWBaseAPIManager.h"
#import "NSURLRequest+CWNetworking.h"
#import "CWNetworkingLogger.h"
#import "Foundation+CWNetworking.h"

@interface CWAPIProxy ()
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation CWAPIProxy
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static CWAPIProxy *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSInteger)loadGETWithParams:(NSDictionary *)params
                       useJSON:(BOOL)useJSON
                          host:(NSString *)host
                          path:(NSString *)path
                    apiVersion:(NSString *)version
                       success:(CWAPIProxySuccess)success
                          fail:(CWAPIProxyFail)fail {
    NSURLRequest *request = [CWAPIProxy requestWithParams:params
                                                  useJSON:useJSON
                                                   method:@"GET"
                                                     host:host
                                                     path:path
                                               apiVersion:version];
    
    NSNumber *requestId = [self loadRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)loadPOSTWithParams:(NSDictionary *)params
                        useJSON:(BOOL)useJSON
                           host:(NSString *)host
                           path:(NSString *)path
                     apiVersion:(NSString *)version
                        success:(CWAPIProxySuccess)success
                           fail:(CWAPIProxyFail)fail {
    NSURLRequest *request = [CWAPIProxy requestWithParams:params
                                                  useJSON:useJSON
                                                   method:@"POST"
                                                     host:host
                                                     path:path
                                               apiVersion:version];
    NSNumber *requestId = [self loadRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestId:(NSNumber *)requestId {
    if (requestId == nil) return;
    NSURLSessionDataTask *requestTask = self.dispatchTable[requestId];
    [requestTask cancel];
    [self.dispatchTable removeObjectForKey:requestId];
}

- (void)cancelRequestWithRequestIdList:(NSArray *)requestIDList {
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestId:requestId];
    }
}


- (NSNumber *)loadRequest:(NSURLRequest *)request
                  success:(CWAPIProxySuccess)success
                     fail:(CWAPIProxyFail)fail {
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request
                                         uploadProgress:nil
                                       downloadProgress:nil
                                      completionHandler:^(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable error) {
                                          NSNumber *requestID = @([dataTask taskIdentifier]);
                                          [self.dispatchTable removeObjectForKey:requestID];
                                          NSData *responseData = nil;
                                          if ([responseObject isKindOfClass:[NSData class]]) {
                                              responseData = responseObject;
                                          }
                                          if (error) {
                                              [CWNetworkingLogger logError:error.description];
                                              if (error.code == NSURLErrorCancelled) {
                                                  // 若取消则不发送任何消息
                                                  fail?fail(CWResponseError(@"取消访问",CWResponseStatusCancel,[requestID integerValue])):nil;
                                              } else if (error.code == NSURLErrorTimedOut) {
                                                  fail?fail(CWResponseError(@"网络超时",CWResponseStatusErrorTimeout,[requestID integerValue])):nil;
                                              } else {
                                                  fail?fail(CWResponseError(@"网络错误",CWResponseStatusErrorUnknown,[requestID integerValue])):nil;
                                              }
                                          } else {
                                              NSString *responseString = nil;
                                              if (responseData != nil) {
                                                  responseString = [[NSString alloc] initWithData:responseData
                                                                                         encoding:NSUTF8StringEncoding];;
                                              }
                                              [CWNetworkingLogger logResponseWithRequest:request path:request.URL.absoluteString params:request.cw_requestParams response:responseString];
                                              
                                              CWResponseModel *responseModel =
                                              [[CWResponseModel alloc] initWithResponseString:responseString
                                                                                    requestId:[requestID integerValue]
                                                                                      request:request
                                                                                     response:response
                                                                                 responseData:responseData
                                                                                       status:CWResponseStatusSuccess];
                                              success?success(responseModel):nil;
                                          }
                                      }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}

- (BOOL)isReachable {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

#pragma mark - Getter

- (NSMutableDictionary *)dispatchTable {
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        //        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}
@end

@implementation CWAPIProxy (CWRequestGenerator)
+ (NSURLRequest *)requestWithParams:(NSDictionary *)params
                            useJSON:(BOOL)useJSON
                             method:(NSString *)method
                               host:(NSString *)host
                               path:(NSString *)path
                         apiVersion:(NSString *)version {
    NSString *urlString = [NSString cw_urlStringForHost:host path:path apiVersion:version];
    NSError *error = nil;
    if (![method isEqualToString:@"GET"]
        && ![method isEqualToString:@"POST"]) {
        [CWNetworkingLogger logError:@"[CWAPIProxy]未知请求方法"];
        return nil;
    }
    
    AFHTTPRequestSerializer *serializer = useJSON?[AFJSONRequestSerializer serializer]
    :[AFHTTPRequestSerializer serializer];
    
    serializer.timeoutInterval = kCWNetworkingTimeoutSeconds;
    NSMutableURLRequest *request = [serializer requestWithMethod:method
                                                       URLString:urlString
                                                      parameters:params
                                                           error:&error];
    
    //    [request setValue:@"3" forHTTPHeaderField:@"User-Id"];
    //    [request setValue:@"3" forHTTPHeaderField:@"User-Token"];
    //
    // 自定义header
    
    request.cw_requestParams = params;
    
    if (error) {
        [CWNetworkingLogger logError:request.description];
        return nil;
    }
    
    [CWNetworkingLogger logDebugInfoWithRequest:request path:urlString isJSON:useJSON params:params requestType:method];
    return request;
}
@end
