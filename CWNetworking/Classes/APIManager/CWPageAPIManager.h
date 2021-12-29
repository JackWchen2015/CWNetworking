//
//  CWPageAPIManager.h
//  CWNetworking
//
//  Created by jack on 2021/12/29.
//

#import "CWBaseAPIManager.h"
extern const NSInteger kPageSizeNotFound;
extern const NSInteger kPageIsLoading;
NS_ASSUME_NONNULL_BEGIN

@protocol CWPageAPIManager<CWAPIManager>
@required
- (NSInteger)currentPageSize;// 从未加载过时，应返回kPageSizeNotFound
@end

// 子类化时必须实现YLPageAPIManager协议
@interface CWPageAPIManager : CWBaseAPIManager
@property (nonatomic, assign, readonly) NSInteger pageSize;
@property (nonatomic, assign, readonly) NSInteger currentPage;
@property (nonatomic, assign, readonly) BOOL hasNextPage;

// 重置currentPage
- (void)reset;
- (void)resetToPage:(NSInteger)page;

- (NSInteger)loadNextPage; // 如果正在加载则返回 kPageIsLoading，否则则返回requestId
- (NSInteger)loadNextPageWithoutCache;


- (instancetype)initWithPageSize:(NSInteger)pageSize;
- (instancetype)initWithPageSize:(NSInteger)pageSize startPage:(NSInteger)page NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
