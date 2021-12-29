//
//  CWResponseModel.m
//  AFNetworking
//
//  Created by jack on 2021/12/29.
//

#import "CWResponseModel.h"
#import "NSURLRequest+CWNetworking.h"
#import "CWAuthParamsGenerator.h"

NSString * const CWNetworkingResponseErrorKey = @"xyz.jack.error.responsee";

@implementation CWResponseError
@dynamic message;
- (instancetype)initWithMessage:(NSString *)message
                           code:(NSInteger)code
                      requestId:(NSInteger)requestId {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message
                                                         forKey:NSLocalizedDescriptionKey];
    self = [super initWithDomain:CWNetworkingResponseErrorKey code:code userInfo:userInfo];
    if (self) {
        _requestId = requestId;
    }
    return self;
}


+ (CWResponseError *)errorWithMessage:(NSString *)message
                                 code:(NSInteger)code
                            requestId:(NSInteger)requestId {
    return [[self alloc] initWithMessage:message code:code requestId:requestId];
}
#pragma mark -
- (NSString *)message {
    return [self localizedDescription];
}
#pragma mark -
- (NSString *)description {
    return [NSString stringWithFormat:@"[%lu]code:%lu, message:%@",self.requestId,self.code,self.message];
}
@end


@implementation CWResponseModel
- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSInteger)requestId
                               request:(NSURLRequest *)request
                              response:(NSURLResponse *)response
                          responseData:(NSData *)responseData
                                status:(CWResponseStatus)status {
    self = [super init];
    if (self) {
        _contentString = responseString;
        _requestId = requestId;
        _response = response;
        _responseData = responseData;
        _request = request;
        _requestParams = request.cw_requestParams;
        _isCache = NO;
    }
    return self;
}


- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _requestId = 0;
        _request = nil;
        _responseData = [data copy];
        _requestParams = nil;
        _isCache = YES;
    }
    return self;
}

- (NSDictionary *)requestParamsExceptToken {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.requestParams];
    NSArray<NSString *> *keys = [CWAuthParamsGenerator authParams].allKeys;
    // 这里保留UserId以防止不同用户的脏数据
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqualToString:kCWAuthParamsKeyUserId]) {
            [dict removeObjectForKey:obj];
        }
    }];
    return [dict copy];
}
@end
