//
//  LSBannerCell.h
//  LSMessages
//
//  Created by lisa on 2017/12/18.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LSBannerCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView    *imageView;
@property (nonatomic,strong) UILabel        *label;

+ (void)setSpaceBetweenImageAndDescription:(CGFloat)space;
+ (void)setImageSize:(CGSize)image_size;
+ (void)setTitleHeight:(CGFloat)title_height;

@end


