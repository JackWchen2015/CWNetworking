//
//  CWSignatureGenerator.h
//  AFNetworking
//
//  Created by jack on 2021/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWSignatureGenerator : NSObject
+ (NSString *)signatureWithRequestPath:(NSString *)path params:(NSDictionary *)params extra:(NSString *)extra;
@end

NS_ASSUME_NONNULL_END
