//
//  LSBannerLayout.h
//  LSMessages
//
//  Created by lisa on 2017/12/18.
//  Copyright © 2017年 lisa. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface LSBannerLayout : UICollectionViewLayout

@property (nonatomic,assign) CGFloat        itemSpacing;
@property (nonatomic,assign) CGSize         itemSize;
@property (nonatomic,assign) UIEdgeInsets   sectionInset;
@property (nonatomic,assign) BOOL           enableTransformAnimation;


@end
