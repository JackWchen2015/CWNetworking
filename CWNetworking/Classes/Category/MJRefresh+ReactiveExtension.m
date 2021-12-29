//
//  MJRefreshHeader+ReactiveExtension.m
//  AFNetworking
//
//  Created by jack on 2021/12/29.
//

#import "MJRefresh+ReactiveExtension.h"

@implementation MJRefreshHeader (ReactiveExtension)
+ (instancetype)headerWithRefreshingCommand:(RACCommand *)refreshingCommand {
    @weakify(refreshingCommand);
    return [self headerWithRefreshingBlock:^{
        @strongify(refreshingCommand);
        [refreshingCommand execute:nil];
    }];
}

@end


@implementation MJRefreshFooter(ReactiveExtension)
+ (instancetype)footerWithRefreshingCommand:(RACCommand *)refreshingCommand {
    @weakify(refreshingCommand);
    return [self footerWithRefreshingBlock:^{
        @strongify(refreshingCommand);
        [refreshingCommand execute:nil];
    }];
}
@end
