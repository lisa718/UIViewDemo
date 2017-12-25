//
//  LSBannerView.m
//  LSMessages
//
//  Created by lisa on 2017/12/18.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSBannerView.h"
#import "UIView+LayoutMethods.h"
#import "LSBannerCell.h"
#import "LSBannerEntity.h"
#import "LSBannerLayout.h"
#import "NSTimer+NonRetain.h"

@interface LSBannerView ()<UICollectionViewDataSource,UICollectionViewDelegate>
//
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) LSBannerLayout * customLayout;
@property (nonatomic,strong) NSTimer * timer;

//
@property (nonatomic,assign,readwrite) NSInteger numberOfItems;

@end

@implementation LSBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, self.ct_width, 200);
}


//- (UIEdgeInsets)calculateSectionInset {
//    CGFloat top = self.sectionInset.top*2 + [self.headerView sizeThatFits:self.headerView.ct_size].height;
//    return UIEdgeInsetsMake(top, self.sectionInset.left, self.sectionInset.bottom, self.sectionInset.right);
//}

- (void)dealloc {
    [_collectionView removeObserver:self forKeyPath:@"contentSize"];
    [_timer invalidate];
    self.timer = nil;
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark - public
- (void)reloadData {
    [self.collectionView reloadData];
   
    // 要默认滚动到中间位置
    NSIndexPath * currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    NSIndexPath * targetIndexPath = [NSIndexPath indexPathForItem:[self.collectionView numberOfItemsInSection:0]/3 inSection:0];
    
//    CGPoint correctOffset = [self.customLayout offsetScrollFromIndexPath:currentIndexPath toTargetIndexPath:targetIndexPath];
    
    UICollectionViewLayoutAttributes *targetAttr = [self.customLayout layoutAttributesForItemAtIndexPath:targetIndexPath];
    UICollectionViewLayoutAttributes *attr = [self.customLayout layoutAttributesForItemAtIndexPath:currentIndexPath];
    
    CGFloat newOffsetX = targetAttr.center.x - attr.center.x - (self.collectionView.ct_width/2 -  self.customLayout.itemSize.width/2.0);
    CGPoint newOffset = CGPointMake(self.collectionView.contentOffset.x + newOffsetX, self.collectionView.contentOffset.y);
    // 直接改变offset会引起动画暂停的问题，那是因为setContentOffset还会去调用didScroll代理
    [self.collectionView setContentOffset:newOffset animated:NO];
    

}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize collectionViewSize = [LSBannerCell calulateCellSizeWithImageSize:self.imageSize];
//    UIEdgeInsets sectionInset = [self calculateSectionInset];
    return CGSizeMake(size.width, collectionViewSize.height+self.sectionInset.top+self.sectionInset.bottom);
}

// 原理：改变scrollview的contentOffset或者bounds来翻页
- (void)flipNext {
    
//    // 要根据当前的offset，来计算下一页的新的offset，
//    CGPoint currentOffset = self.collectionView.contentOffset;
//
//    // 使用布局函数计算target的contentOffset
//    CGPoint newoffset = [self.collectionView.collectionViewLayout targetContentOffsetForProposedContentOffset:CGPointMake(currentOffset.x+self.collectionView.ct_width,currentOffset.y) withScrollingVelocity:(CGPoint){0,0}];
//
//    // 当当前的offer是最后一个的时候，需要回到0
//    if (newoffset.x == self.collectionView.contentOffset.x) {
//        newoffset = CGPointMake(0, newoffset.y);
//    }
    
    NSIndexPath * currentIndex = [self currentShowingItem];
    if (currentIndex == nil) {
        return;
    }
    
    NSInteger current = currentIndex.item;
    NSIndexPath *targetIndexPath;
    if (self.enableInfinite) {
        if (current == 1 ) {
            targetIndexPath = [NSIndexPath indexPathForItem:current + _numberOfItems + 1 inSection:0];
        }
        else if (current == self.numberOfItems - 2) {
            targetIndexPath = [NSIndexPath indexPathForItem:current - _numberOfItems + 1 inSection:0];
            
        }
        else {
            targetIndexPath = [NSIndexPath indexPathForItem:current+1 inSection:0];

        }
    }
    else {
        targetIndexPath = [NSIndexPath indexPathForItem:current+1 inSection:0];
    }
  
    CGPoint correctOffset = [self.customLayout offsetScrollFromIndexPath:currentIndex toTargetIndexPath:targetIndexPath];
    
    [self.collectionView setContentOffset:correctOffset animated:YES];
    
}


- (NSIndexPath *)currentShowingItem{
    
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        UICollectionViewLayoutAttributes * attribute = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
        CGPoint center = [self.collectionView convertPoint:self.collectionView.center fromView:self];
        if (CGRectContainsPoint(attribute.frame,center)) {
//            NSLog(@"%@",indexPath);
            return indexPath;
            
        }
    }
    return nil;
}
#pragma mark - tool
- (BOOL) shouldLayoutAsInfinite {
    
    return _enableInfinite && _numberOfItems > 2;
}
// 判断View是否显示在屏幕上
+ (BOOL)isDisplayedInScreen:(UIView*)view;
{
    if (self == nil) {
        return NO;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [view convertRect:view.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    
    // 若view 隐藏
    if (view.hidden) {
        return NO;
    }
    
    // 若没有superview
    if (view.superview == nil) {
        return NO;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  NO;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    
    return YES;
}


#pragma mark - timer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        BOOL canScroll = self.collectionView.contentSize.width > self.collectionView.frame.size.width ? YES:NO;
        if (canScroll) {
            if (_timer == nil && [[self class] isDisplayedInScreen:self.collectionView]) {
                
                [self fireTimer];
            }
        }
    }
}

- (void)fireTimer {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fire) object:nil];
    if (_timer == nil) {
        [self performSelector:@selector(fire) withObject:nil afterDelay:2];
    }
}

- (void)fire {
    [self.timer fire];
}

- (void)stopTimer {// called on viewDidDisappear
    if (_timer != nil) {
        [_timer invalidate];
        self.timer = nil;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {     // called when scroll view grinds to a halt
    [self fireTimer];
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSIndexPath * currentIndex = [self currentShowingItem];
    if (currentIndex == nil) {
        return;
    }
    
    NSInteger current = currentIndex.item;
    if (current == 1 ) {
        NSIndexPath *targetIndexPath = [NSIndexPath indexPathForItem:current + _numberOfItems inSection:0];

        CGPoint correctOffset = [self.customLayout offsetScrollFromIndexPath:currentIndex toTargetIndexPath:targetIndexPath];
        // 直接改变offset会引起动画暂停的问题，那是因为setContentOffset还会去调用didScroll代理
//        [self.collectionView setContentOffset:correctOffset animated:NO];
        CGRect scrollBounds = scrollView.bounds;
        scrollBounds.origin = correctOffset;
        scrollView.bounds = scrollBounds;
        current = current+_numberOfItems;
    }
    else if (current == self.numberOfItems - 2) {
        NSIndexPath *targetIndexPath = [NSIndexPath indexPathForItem:current - _numberOfItems inSection:0];

        CGPoint correctOffset = [self.customLayout offsetScrollFromIndexPath:currentIndex toTargetIndexPath:targetIndexPath];
//        [self.collectionView setContentOffset:correctOffset animated:NO];
        CGRect scrollBounds = scrollView.bounds;
        scrollBounds.origin = correctOffset;
        scrollView.bounds = scrollBounds;
        current = current - _numberOfItems;
    }

    
    current = current%_numberOfItems + 1;
    if ([self.delegate respondsToSelector:@selector(bannerViewDidScroll:forCurrentItemAtIndex:)]) {
        [self.delegate bannerViewDidScroll:self forCurrentItemAtIndex:current];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInBannerView:)]) {
        self.numberOfItems = [self.dataSource numberOfItemsInBannerView:self];
    }
    
    return self.numberOfItems;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSBannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LSBannerCell class]) forIndexPath:indexPath];
    cell.label.text = [@(indexPath.item) stringValue];
    
//    // 捕获上下文cell和indexPath，用于让外面配置cell
//    if (self.dataSource.configureCellBlock) {
//        self.dataSource.configureCellBlock(cell, indexPath.item);
//    }
    NSInteger index = indexPath.item;
    if ([self shouldLayoutAsInfinite]) {
        index = (index)%(_numberOfItems);
    }

    if ([self.dataSource respondsToSelector:@selector(bannerView:cellForConfig:index:)]) {
        [self.dataSource bannerView:self cellForConfig:(&cell) index:index];
    }
    return cell;
    
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
//    if ([kind isEqualToString:NSStringFromClass([LSBannerHeaderView class])]) {
//        LSBannerHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([LSBannerHeaderView class]) forIndexPath:indexPath];
//        header.label.text = @"今日活动";
//        [header updateCurrentPage:indexPath.item+1 totalPage:[collectionView numberOfItemsInSection:0]];
//        return header;
//    }
//    return nil;
//}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [self.delegate bannerView:self didSelectItemAtIndex:indexPath.item%_numberOfItems];
    }
}


#pragma mark - getters & setters
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.customLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[LSBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([LSBannerCell class])];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    }
    return _collectionView;
}


- (LSBannerLayout *)customLayout{
    if (_customLayout == nil) {
        _customLayout = [[LSBannerLayout alloc] init];
    }
    return _customLayout;
}

- (NSTimer *)timer {
    if (_timer == nil && self.enableAutoScroll) {
        _timer = [NSTimer scheduledNonRetainTimerWithTimeInterval:3 target:self selector:@selector(flipNext) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    _itemSpacing = itemSpacing;
    self.customLayout.itemSpacing = itemSpacing;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    self.customLayout.itemSize = [LSBannerCell calulateCellSizeWithImageSize:imageSize];
    [self.collectionView.collectionViewLayout invalidateLayout];

}

- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    _sectionInset = sectionInset;
    self.customLayout.sectionInset = self.sectionInset;
    [self.collectionView.collectionViewLayout invalidateLayout];

}

- (void)setEnableTransformAnimation:(BOOL)enableTransformAnimation {
    _enableTransformAnimation = enableTransformAnimation;
    self.customLayout.enableTransformAnimation = enableTransformAnimation;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)setEnableInfinite:(BOOL)enableInfinite {
    _enableInfinite = enableInfinite;
    self.customLayout.enableInfinite = enableInfinite;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (NSInteger)numberOfItems {
    if ([self shouldLayoutAsInfinite] && _numberOfItems > 0)
    {
        return (_numberOfItems*3);
    }
    return _numberOfItems;
}

@end
