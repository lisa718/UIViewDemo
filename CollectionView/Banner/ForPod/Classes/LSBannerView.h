//
//  LSBannerView.h
//  LSMessages
//
//  Created by lisa on 2017/12/18.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSBannerViewDelegate.h"


@interface LSBannerView : UIView

// delegate
@property (nonatomic,weak)  id<LSBannerDelegate>    delegate;
@property (nonatomic,weak)  id<LSBannerDataSource>  dataSource;

// layout
@property (nonatomic,assign) CGFloat        itemSpacing;
@property (nonatomic,assign) CGSize         imageSize;
@property (nonatomic,assign) UIEdgeInsets   sectionInset;
@property (nonatomic,strong) UIImage        *placeholderItemImage; // each banner image

@property (nonatomic,assign) BOOL           enableTransformAnimation;
@property (nonatomic,assign) BOOL           enableInfinite;
@property (nonatomic,assign) BOOL           enableAutoScroll;
@property (nonatomic,assign,readonly) NSInteger numberOfItems;


// action
- (void)reloadData;

- (void)stopTimer;// called on viewDidDisappear
- (void)fireTimer;// called on viewWillAppear



@end
