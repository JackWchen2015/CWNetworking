//
//  Foundation+WSFNetworking.m
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import "Foundation+CWNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

@implementation NSObject (CWSwizzling)
+ (void)cw_methodSwizzlingWithTarget:(SEL)originalSelector
                             using:(SEL)swizzledSelector
                          forClass:(Class)clazz {
    
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(clazz,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(clazz,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end

@implementation NSString (CWNetworking)
- (NSString *)yl_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)cw_urlStringForHost:(NSString *)host
                          path:(NSString *)path
                    apiVersion:(NSString *)version {
    NSString *urlString;
    if (version.length != 0) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@",host, version, path];
    } else {
        urlString = [NSString stringWithFormat:@"%@/%@",host, path];
    }
    return urlString;
}
@end


@implementation NSData(CWNetworking)
- (NSString*)cw_md5 {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( self.bytes, (int)self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

@implementation NSDictionary (CWNetworking)
- (NSString *)cw_md5 {
    return [[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] cw_md5];
}


@end
