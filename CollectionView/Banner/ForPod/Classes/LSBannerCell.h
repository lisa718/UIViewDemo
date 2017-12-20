//
//  LSBannerCell.h
//  LSMessages
//
//  Created by lisa on 2017/12/18.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSBannerEntity.h"
@interface LSBannerCell : UICollectionViewCell

@property (nonatomic,strong) LSBannerEntity *entity;
@property (nonatomic,strong) UIImage    *placeholderImage;
#warning better method?
@property (nonatomic,strong) UIFont     *labelFont;
@property (nonatomic,strong) UIColor    *labelColor;

+ (CGSize)calulateCellSizeWithImageSize:(CGSize)imageSize;
+ (void)setSpaceBetweenImageAndDescription:(CGFloat)space;



@end
