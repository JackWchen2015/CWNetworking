//
//  NSURLRequest+CWNetworking.h
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (CWNetworking)
@property (nonatomic, copy) NSDictionary *cw_requestParams;
@end

NS_ASSUME_NONNULL_END
