//
//  LSBannerViewDelegate.h
//  LSMessages
//
//  Created by baidu on 2017/12/20.
//  Copyright © 2017年 baidu. All rights reserved.
//

#ifndef LSBannerViewDelegate_h
#define LSBannerViewDelegate_h
@class LSBannerView;
@class LSBannerCell;

// LSBannerViewDataSource--------------------------------------

@protocol LSBannerDataSource <NSObject>

- (NSInteger)numberOfItemsInBannerView:(LSBannerView *)bannerView;
//@property (nonatomic,copy) void(^configureCellBlock)(LSBannerCell *cell,NSInteger index);

- (void)bannerView:(LSBannerView *)bannerView cellForConfig:(LSBannerCell * __autoreleasing *)cell index:(NSInteger)index;

// 可以传入自定义cell，但是如果实现了上面的configCell方法，则下面的方法无效
//- (UICollectionViewCell *)bannerView:(LSBannerView *)bannerView cellForItemAtIndex:(NSInteger)index;
@optional
//- (NSURL*)bannerView:(LSBannerView *)bannerView prefetchBannerImageAtIndexPaths:(NSInteger)index NS_AVAILABLE_IOS(10_0);

@end


// LSBannerViewDelegate--------------------------------------

@protocol LSBannerDelegate <NSObject>

@optional

- (void)bannerView:(LSBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;
- (void)bannerViewDidScroll:(LSBannerView *)bannerView forCurrentItemAtIndex:(NSInteger)index;

@end

#endif /* LSBannerViewDelegate_h */
