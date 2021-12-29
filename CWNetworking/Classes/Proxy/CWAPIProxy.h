//
//  CWAPIProxy.h
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import <Foundation/Foundation.h>
#import "CWResponseModel.h"
NS_ASSUME_NONNULL_BEGIN

/*
 * The purpose of this file is to facilitate the replacement of AFNetworking
 */

typedef void(^CWAPIProxySuccess)(CWResponseModel *response);
typedef void(^CWAPIProxyFail)(CWResponseError *error);

@interface CWAPIProxy : NSObject
+ (instancetype)sharedInstance;

- (BOOL)isReachable;

- (NSInteger)loadGETWithParams:(NSDictionary *)params
                       useJSON:(BOOL)useJSON
                          host:(NSString *)host
                          path:(NSString *)path
                    apiVersion:(NSString *)version
                       success:(CWAPIProxySuccess)success
                          fail:(CWAPIProxyFail)fail;

- (NSInteger)loadPOSTWithParams:(NSDictionary *)params
                        useJSON:(BOOL)useJSON
                           host:(NSString *)host
                           path:(NSString *)path
                     apiVersion:(NSString *)version
                        success:(CWAPIProxySuccess)success
                           fail:(CWAPIProxyFail)fail;

- (NSNumber *)loadRequest:(NSURLRequest *)request
                  success:(CWAPIProxySuccess)success
                     fail:(CWAPIProxyFail)fail;

- (void)cancelRequestWithRequestId:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIdList:(NSArray *)requestIdList;
@end


@class CWBaseAPIManager;
@protocol CWAPIManager;
@interface CWAPIProxy (CWRequestGenerator)
+ (NSURLRequest *)requestWithParams:(NSDictionary *)params
                            useJSON:(BOOL)useJSON
                             method:(NSString *)method
                               host:(NSString *)host
                               path:(NSString *)path
                         apiVersion:(NSString *)version;
@end
NS_ASSUME_NONNULL_END
