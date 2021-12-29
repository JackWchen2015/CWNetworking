//
//  CWNetworkingLogger.h
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWNetworkingLogger : NSObject
+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                           path:(NSString *)path
                         isJSON:(BOOL)isJSON
                         params:(id)requestParams
                    requestType:(NSString *)type;

+ (void)logResponseWithRequest:(NSURLRequest *)request
                          path:(NSString *)path
                        params:(id)requestParams
                      response:(NSString *)response;
+ (void)logInfo:(NSString *)msg;
+ (void)logInfo:(NSString *)msg label:(NSString *)label;
+ (void)logError:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
