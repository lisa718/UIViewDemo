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

@property (nonatomic,strong) UIImageView    *imageView;
@property (nonatomic,strong) UILabel        *label;

+ (CGSize)calulateCellSizeWithImageSize:(CGSize)imageSize;
+ (void)setSpaceBetweenImageAndDescription:(CGFloat)space;

@end


