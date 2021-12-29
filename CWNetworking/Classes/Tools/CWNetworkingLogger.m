//
//  CWNetworkingLogger.m
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import "CWNetworkingLogger.h"

@implementation CWNetworkingLogger
+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                           path:(NSString *)path
                         isJSON:(BOOL)isJSON
                         params:(id)requestParams
                    requestType:(NSString *)type {
#if CWNetworkingLog && DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ CWNetworking Request Info ] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
    [log appendFormat:@"\nReuqest Path   : %@", path];
    [log appendFormat:@"\nReuqest Params : %@", requestParams];
    [log appendFormat:@"\nParams is JSON : %@", isJSON?@"YES":@"NO"];
    [log appendFormat:@"\nRequest Type   : %@", type];
    [log appendFormat:@"\nRaw Request    : %@", request];
    [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ CWNetworking Request Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
    NSLog(@"%@",log);
#endif
}

+ (void)logResponseWithRequest:(NSURLRequest *)request
                          path:(NSString *)path
                        params:(id)requestParams
                      response:(NSString *)response {
#if CWNetworkingLog && DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ CWNetworking Response Info ] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
    [log appendFormat:@"\nReuqest Path   : %@", path];
    [log appendFormat:@"\nReuqest Params : %@", requestParams];
    [log appendFormat:@"\nResponse String: %@", response];
    [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ CWNetworking Response Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
    NSLog(@"%@",log);
#endif
}

+ (void)logInfo:(NSString *)msg {
    [self logInfo:msg label:@"Log"];
}

+ (void)logInfo:(NSString *)msg label:(NSString *)label {
#if DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendFormat:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ CWNetworking %@ Info ] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙",label];
    [log appendFormat:@"\n%@", msg];
    [log appendFormat:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ CWNetworking %@ Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖",label];
    NSLog(@"%@",log);
#endif
}

+ (void)logError:(NSString *)msg {
#if DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ CWNetworking Error Info ] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
    [log appendFormat:@"\n%@", msg];
    [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ CWNetworking Error Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
    NSLog(@"%@",log);
#endif
}
@end
