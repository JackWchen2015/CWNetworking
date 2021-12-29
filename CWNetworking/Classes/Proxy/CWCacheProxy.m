//
//  CWCacheProxy.m
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import "CWCacheProxy.h"
#import "Foundation+CWNetworking.h"
#import <YYCache/YYCache.h>
#import "CWSignatureGenerator.h"
#import "CWNetworkingLogger.h"
#import "CWNetworkingConfiguration.h"

static NSString * const  kCWNetworkingCacheKeyCacheData = @"xyz.jack.kCWNetworkingCacheKeyCacheData";
static NSString * const  kCWNetworkingCacheKeyCacheTime = @"xyz.jack.kCWNetworkingCacheKeyCacheTime";
static NSString * const  kCWNetworkingCacheKeyCacheAgeLength = @"xyz.jack.kCWNetworkingCacheKeyCacheAgeLength";

static NSString * const  kCWNetworkingCache = @"xyz.jack.kYLNetworkingCache";


@interface CWCacheProxy()
@property (nonatomic, strong) YYCache *cache;
@end

@implementation CWCacheProxy
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static CWCacheProxy *instance;
    dispatch_once(&onceToken, ^{
        instance = [[CWCacheProxy alloc] init];
    });
    return instance;
}

- (NSData *)cacheForParams:(NSDictionary *)params host:(NSString *)host path:(NSString *)path apiVersion:(NSString *)version {
    NSString *urlString = [NSString cw_urlStringForHost:host path:path apiVersion:version];
    NSString *key = [CWSignatureGenerator signatureWithRequestPath:urlString params:params extra:nil];
    return [self cacheForKey:key];
}

- (NSData *)cacheForKey:(NSString *)key {
    NSDictionary *cacheDict = [self.cache objectForKey:key];
    
    NSData *cacheData = cacheDict[kCWNetworkingCacheKeyCacheData];
    NSTimeInterval cacheTime = [cacheDict[kCWNetworkingCacheKeyCacheTime] doubleValue];
    NSInteger cacheAgeLength = [cacheDict[kCWNetworkingCacheKeyCacheAgeLength] integerValue];
    
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    if (now - cacheTime > cacheAgeLength) {
        [CWNetworkingLogger logInfo:@"已过期" label:@"Cache"];
        [self.cache removeObjectForKey:key];
        return nil;
    } else {
        if ([cacheData isKindOfClass:[NSData class]]) {
            NSString *log =[NSString stringWithFormat:@"读取缓存:\n%@",[[NSString alloc] initWithData:cacheData encoding:NSUTF8StringEncoding]];
            [CWNetworkingLogger logInfo:log label:@"Cache"];
            return cacheData;
        } else {
            NSString *log = [NSString stringWithFormat:@"Return nil because cache data(%@) is NOT kind of NSData.",[cacheData class]];
            [CWNetworkingLogger logError:log];
            return nil;
        }
    }
    
}


- (void)setCacheData:(NSData *)data
           forParams:(NSDictionary *)params
                host:(NSString *)host
                path:(NSString *)path
          apiVersion:(NSString *)version
  withExpirationTime:(NSTimeInterval)length {
    NSString *urlString = [NSString cw_urlStringForHost:host path:path apiVersion:version];
    NSString *key = [CWSignatureGenerator signatureWithRequestPath:urlString params:params extra:nil];
    [self setCacheData:data forKey:key withExpirationTime:length];
}

- (void)setCacheData:(NSData *)data forKey:(NSString *)key withExpirationTime:(NSTimeInterval)length {
    if (data == nil) {
        return;
    }
    if ([data isKindOfClass:[NSData class]]) {
        NSDictionary *cacheDict =
        @{
          kCWNetworkingCacheKeyCacheData: data,
          kCWNetworkingCacheKeyCacheTime: @([NSDate timeIntervalSinceReferenceDate]),
          kCWNetworkingCacheKeyCacheAgeLength : @(length),
          };
        
        [self.cache setObject:cacheDict forKey:key];
        
        NSString *log =[NSString stringWithFormat:@"写入缓存:\n %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        [CWNetworkingLogger logInfo:log label:@"Cache"];
    } else {
        [CWNetworkingLogger logError:
         [NSString stringWithFormat:@"Cache data(%@) is NOT kind of NSData",[data class]]];
    }
}

- (YYCache *)cache {
    if (_cache == nil) {
        _cache = [[YYCache alloc] initWithName:kCWNetworkingCache];
        _cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    }
    return _cache;
}
@end
