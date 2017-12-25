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
//- (LSBannerCell *)bannerView:(LSBannerView *)bannerView cellForItemAtIndex:(NSInteger)index;

- (void)bannerView:(LSBannerView *)bannerView cellForConfig:(LSBannerCell * __autoreleasing *)cell index:(NSInteger)index;

@end


// LSBannerViewDelegate--------------------------------------

@protocol LSBannerDelegate <NSObject>

@optional

- (void)bannerView:(LSBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;
- (void)bannerViewDidScroll:(LSBannerView *)bannerView forCurrentItemAtIndex:(NSInteger)index;

@end

#endif /* LSBannerViewDelegate_h */
