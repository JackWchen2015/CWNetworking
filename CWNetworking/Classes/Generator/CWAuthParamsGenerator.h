//
//  CWAuthParamsGenerator.h
//  AFNetworking
//
//  Created by jack on 2021/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
extern NSString * const kCWAuthParamsKeyUserId;
@interface CWAuthParamsGenerator : NSObject
+ (NSDictionary *)authParams;
@end

NS_ASSUME_NONNULL_END
