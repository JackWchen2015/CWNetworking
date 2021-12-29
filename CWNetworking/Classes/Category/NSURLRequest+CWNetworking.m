//
//  NSURLRequest+CWNetworking.m
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import "NSURLRequest+CWNetworking.h"
#import <objc/runtime.h>
@implementation NSURLRequest (CWNetworking)
- (void)setCw_requestParams:(NSDictionary *)cw_requestParams {
     objc_setAssociatedObject(self, @selector(cw_requestParams), cw_requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)cw_requestParams {
    return objc_getAssociatedObject(self, @selector(cw_requestParams));
}
@end
