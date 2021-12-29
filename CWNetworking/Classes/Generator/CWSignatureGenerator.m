//
//  CWSignatureGenerator.m
//  AFNetworking
//
//  Created by jack on 2021/12/29.
//

#import "CWSignatureGenerator.h"
#import "Foundation+CWNetworking.h"
@implementation CWSignatureGenerator
+ (NSString *)signatureWithRequestPath:(NSString *)path params:(NSDictionary *)params extra:(NSString *)extra {
    return [[NSString stringWithFormat:@"%@%@%@",path, [params cw_md5], extra] cw_md5];
}
@end
