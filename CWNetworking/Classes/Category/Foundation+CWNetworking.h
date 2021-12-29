//
//  Foundation+WSFNetworking.h
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzling)
+ (void)cw_methodSwizzlingWithTarget:(SEL)originalSelector
                             using:(SEL)swizzledSelector
                          forClass:(Class)clazz;
@end


@interface NSString (CWNetworking)
- (NSString *)cw_md5;
+ (NSString *)cw_urlStringForHost:(NSString *)host
                          path:(NSString *)path
                    apiVersion:(NSString *)version;
@end

@interface NSData (CWNetworking)
- (NSString *)cw_md5;
@end


@interface NSDictionary (CWNetworking)
- (NSString *)cw_md5;
@end


NS_ASSUME_NONNULL_END
