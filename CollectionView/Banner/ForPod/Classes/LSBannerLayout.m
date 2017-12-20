//
//  LSBannerLayout.m
//  LSMessages
//
//  Created by lisa on 2017/12/18.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSBannerLayout.h"
#import "UIView+LayoutMethods.h"

@interface LSBannerLayout ()
@property (nonatomic,assign) CGSize contentSize;
@property (nonatomic,assign) CGSize transformSize;
@property (nonatomic,strong) NSMutableArray<UICollectionViewLayoutAttributes *>*layoutInfoArr;

@end


@implementation LSBannerLayout

#pragma mark override father
- (void)prepareLayout {
    [super prepareLayout];
    
    if ([self.collectionView numberOfItemsInSection:0] == 0) {
        return;
    }
    //获取布局信息
    NSInteger maxNumberOfItems = 0;
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *subArr = @[].mutableCopy;
    
    for (NSInteger item = 0; item < numberOfItems; item++){
        // item的属性
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [subArr addObject:attributes];
        // 当有这个补充视图时，需要放开这里的注释，suplimentView属性
//        UICollectionViewLayoutAttributes *suplementAttributes = [self layoutAttributesForSupplementaryViewOfKind:@"LSBannerHeaderView" atIndexPath:indexPath];
//        if (suplementAttributes) {
//            [subArr addObject:suplementAttributes];
//        }
    }
    if(maxNumberOfItems < numberOfItems){
        maxNumberOfItems = numberOfItems;
    }

    //存储布局信息
    self.layoutInfoArr = @[].mutableCopy;
    [self.layoutInfoArr addObjectsFromArray:[subArr copy]];
}

- (CGSize)collectionViewContentSize {
    
    // 因为会改变，所以从prepareLayout拿出来，重新计算内容尺寸
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    // 间隔+item的尺寸
    CGFloat width = self.itemSize.width * (itemCount-1) + self.itemSpacing * (itemCount - 1) + self.transformSize.width;
    CGFloat height = 0;
    self.contentSize = CGSizeMake(width+self.sectionInset.left+self.sectionInset.right,height);
    return self.contentSize;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 要修改proposedContentOffset，根据当前的contentOffset
    if (proposedContentOffset.x > self.collectionView.contentOffset.x
        && self.collectionView.contentOffset.x >= 0) {
        proposedContentOffset.x = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.;
    }
    else if (proposedContentOffset.x < self.collectionView.contentOffset.x &&
             self.collectionView.contentOffset.x + self.collectionView.bounds.size.width <= self.contentSize.width) {

        proposedContentOffset.x = self.collectionView.contentOffset.x - self.collectionView.bounds.size.width / 2.;
    }

    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + self.collectionView.bounds.size.width / 2.;
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0., self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);

    NSArray *attributes = [self layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes *a in attributes) {
        if([[a representedElementKind] isEqualToString:@"LSBannerHeaderView"]) {
            continue;
        }
        CGFloat itemHorizontalCenter = a.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }

    CGPoint newOffset = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    // 当最后一个需要矫正一下
    CGFloat maxOffsetX = self.contentSize.width - self.collectionView.bounds.size.width;
    if (newOffset.x > maxOffsetX) {
        newOffset.x = maxOffsetX;
    }

    return newOffset;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
     UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect frame = CGRectZero;
    frame.origin.x = indexPath.item * (self.itemSize.width + self.itemSpacing);
    if (self.sectionInset.left > 0) {
        frame.origin.x += self.sectionInset.left;
    }
    // 居中对齐
    frame.origin.y = self.sectionInset.top;
    frame.size.width = self.itemSize.width;
    frame.size.height = self.itemSize.height;
    
    attributes.frame = frame;
    
    return attributes;
}


//- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
//    // fixed header
//    CGRect currentBounds = self.collectionView.bounds;
//    attributes.zIndex = 1;
//    attributes.hidden = NO;
//    CGFloat yCenterOffset = currentBounds.origin.y + attributes.size.height/2.f;
//    attributes.center = CGPointMake(CGRectGetMinX(currentBounds), yCenterOffset);
//    CGRect tmp = attributes.frame;
//    attributes.frame = CGRectOffset(tmp, self.sectionInset.left, self.sectionInset.top);
//    return attributes;
//}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    if (CGRectIsEmpty(rect) || rect.size.width <= 0) return nil;
    NSMutableArray * layoutAttributesArr = @[].mutableCopy;
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width/2.0f;

    // 得到可见的indexpaths,使用缓存的lyoutInfo来计算得到当前rect中的attribute,并返回
    [[self.layoutInfoArr copy] enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull attributes, NSUInteger idx, BOOL * _Nonnull stop) {
        if(CGRectIntersectsRect(attributes.frame, rect)) {
            
            if([[attributes representedElementKind] isEqualToString:@"LSBannerHeaderView"]){
                [layoutAttributesArr addObject:attributes];
                return;
            }
            // tranform
            if (self.enableTransformAnimation) {
                
                CGFloat distance = fabs(attributes.center.x - centerX);
                //移动的距离和屏幕宽度的的比例
                CGFloat apartScale = distance/self.collectionView.bounds.size.width;
                //把卡片移动范围固定到 -π/4到 +π/4这一个范围内
                CGFloat scale = fabs(cos(apartScale * M_PI/4));
                //设置cell的缩放 按照余弦函数曲线 越居中越趋近于1
                attributes.transform = CGAffineTransformMakeScale(1.0, scale);
                attributes.zIndex = 0;
                self.transformSize = attributes.frame.size;
            }
            
            [layoutAttributesArr addObject:attributes];
        }
    }];
    
    return layoutAttributesArr;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return true;
}
#pragma mark - getters & setters


- (void)setItemSize:(CGSize)item_size {
    _itemSize = item_size;
    self.transformSize = item_size;
}



@end
