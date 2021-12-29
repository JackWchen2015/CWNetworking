//
//  CWResponseModel.h
//  AFNetworking
//
//  Created by jack on 2021/12/29.
//

#import <Foundation/Foundation.h>
#import "CWNetworkingConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

#define CWResponseError(MSG,CODE,ID) [CWResponseError errorWithMessage:MSG code:CODE requestId:ID]

@interface CWResponseError : NSError
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, strong) NSDictionary *response;

- (instancetype)initWithMessage:(NSString *)message
                           code:(NSInteger)code
                      requestId:(NSInteger)requestId;

+ (CWResponseError *)errorWithMessage:(NSString *)message
                                 code:(NSInteger)code
                            requestId:(NSInteger)requestId;
@end


@interface CWResponseModel : NSObject
@property (nonatomic, assign, readonly) CWResponseStatus status;
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSURLResponse *response;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, assign, readonly) BOOL isCache;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSInteger)requestId
                               request:(NSURLRequest *)request
                              response:(NSURLResponse *)response
                          responseData:(NSData *)responseData
                                status:(CWResponseStatus)status;

- (NSDictionary *)requestParamsExceptToken;
@end

NS_ASSUME_NONNULL_END
