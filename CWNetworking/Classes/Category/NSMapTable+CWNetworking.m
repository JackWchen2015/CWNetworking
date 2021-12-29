//
//  NSMapTable+CWNetworking.m
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import "NSMapTable+CWNetworking.h"

@implementation NSMapTable (CWNetworking)
- (id)objectForKeyedSubscript:(id <NSCopying>)key {
    return [self objectForKey:key];
}
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    if (obj != nil) {
            [self setObject:obj forKey:key];
    } else {
            [self removeObjectForKey:key];
    }
}
@end
