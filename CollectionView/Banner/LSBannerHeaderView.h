//
//  LSBannerHeaderView.h
//  LSMessages
//
//  Created by lisa on 2017/12/18.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSBannerHeaderView : UICollectionReusableView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *label;


- (void)updateCurrentPage:(NSUInteger)currentPage totalPage:(NSUInteger)totalPage;

@end
