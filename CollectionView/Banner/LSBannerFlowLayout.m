//
//  LSBannerFlowLayout.m
//  LSMessages
//
//  Created by lisa on 2017/12/18.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSBannerFlowLayout.h"

#define ACTIVE_DISTANCE 680/2.0
#define ZOOM_FACTOR 0.3

@implementation LSBannerFlowLayout

#warning need to figure it out
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 要修改proposedContentOffset，根据当前的contentOffset
    if (proposedContentOffset.x > self.collectionView.contentOffset.x) {
        proposedContentOffset.x = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.;
    }
    else if (proposedContentOffset.x < self.collectionView.contentOffset.x) {

        proposedContentOffset.x = self.collectionView.contentOffset.x - self.collectionView.bounds.size.width / 2.;
    }
    
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + self.collectionView.bounds.size.width / 2.;
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0., self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *attributes = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes *a in attributes) {
        CGFloat itemHorizontalCenter = a.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    
    CGPoint newOffset = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
//    if (newOffset.x == self.collectionView.contentOffset.x) {
//        newOffset = CGPointMake(0,newOffset.y);
//    }
    
    return newOffset;
}


//-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
//    return YES;
//}



//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    // 获得super已经计算好的布局属性
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//
//    // 计算collectionView最中心点的x值
//    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
//
//    // 在原有布局属性的基础上，进行微调
//    for (UICollectionViewLayoutAttributes *attrs in array) {
//        // cell的中心点x 和 collectionView最中心点的x值 的间距
//        CGFloat delta = ABS(attrs.center.x - centerX);
//
//        // 根据间距值 计算 cell的缩放比例
//        CGFloat scale = 1 - delta / self.collectionView.frame.size.width;
//
//        // 设置缩放比例
//        attrs.transform = CGAffineTransformMakeScale(scale, scale);
//    }
//
//    return array;
//}



////布局属性
//-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    //取父类的UICollectionViewLayoutAttributes
//    NSArray* array = [super layoutAttributesForElementsInRect:rect];
//
//
//    //可视rect
//    CGRect visibleRect;
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
//
//    //设置item的缩放
//    for (UICollectionViewLayoutAttributes* attributes in array) {
//        if (CGRectIntersectsRect(attributes.frame, rect)) {
//            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;//item到中心点的距离
//            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;//距离除以有效距离得到标准化距离
//            //距离小于有效距离才生效
//            if (ABS(distance) < ACTIVE_DISTANCE) {
//                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));//缩放率范围1~1.3,与标准距离负相关
//                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);//x,y轴方向变换
//                attributes.zIndex = 1;
//            }
//        }
//    }
//
//    return array;
//}

@end
