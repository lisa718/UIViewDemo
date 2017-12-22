//
//  LSCollectionViewController.m
//  LSMessages
//
//  Created by lisa on 2017/12/17.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSBannerViewController.h"
#import "UIView+LayoutMethods.h"
#import "LSBannerView.h"
#import "LSBannerFlowLayout.h"
#import "LSBannerCell.h"
#import "LSBannerEntity.h"
#import "LSBannerFooterTitleView.h"
#import "LSBannerHeaderView.h"
#import "LSBannerLayout.h"

@interface LSBannerViewController() <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) LSBannerFlowLayout * flowLayout;
@property (nonatomic,strong) LSBannerLayout * customLayout;
@property (nonatomic,strong) LSBannerHeaderView * headerView;
@property (nonatomic,strong) NSMutableArray<LSBannerEntity *> *bannerDataArray;
@property (nonatomic,strong) NSTimer * timer;
@end

@implementation LSBannerViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_timer == nil) {
        [self.collectionView willChangeValueForKey:@"contentSize"];
        [self.collectionView didChangeValueForKey:@"contentSize"];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.headerView];
    
    // loaddata From jsonFile
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 从文件中读取
        NSString * jsonFilePath = [[NSBundle mainBundle] pathForResource:@"banner_data" ofType:@"json"];
        NSData * data = [NSData dataWithContentsOfFile:jsonFilePath];
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray *bannerArray = @[].mutableCopy;
        [rootDic[@"list"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LSBannerEntity * entity = [[LSBannerEntity alloc] initWithTitle:obj[@"title"] imageName:obj[@"img"]];
            [bannerArray addObject:entity];
        }];
        
        // main 更新
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.bannerDataArray = @[].mutableCopy;
                [self.bannerDataArray addObjectsFromArray:bannerArray.mutableCopy];
                [self.collectionView reloadData];
//                [self.headerView updateCurrentPage:1 totalPage:[self.collectionView numberOfItemsInSection:0]];

            });
        });
        
    });
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.headerView.ct_width = self.collectionView.ct_width-self.customLayout.sectionInset.left*2;
    self.headerView.ct_height = 60;
    self.headerView.ct_left = self.collectionView.ct_left+self.customLayout.sectionInset.left;
    [self.headerView sizeToFit];
    
    self.collectionView.frame = CGRectMake(0, 100, self.view.ct_width, 200);
    self.headerView.ct_top = self.collectionView.ct_top+self.customLayout.sectionInset.top;
//    [self.collectionView sizeToFit];

}

#pragma mark - timer
// 原理：改变scrollview的contentOffset来翻页
- (void)flipNext {
    
    // 要根据当前的offset，来计算下一页的新的offset，
    CGPoint currentOffset = self.collectionView.contentOffset;

    // 使用布局函数计算target的contentOffset
    CGPoint newoffset = [self.collectionView.collectionViewLayout targetContentOffsetForProposedContentOffset:CGPointMake(currentOffset.x+self.collectionView.ct_width,currentOffset.y) withScrollingVelocity:(CGPoint){0,0}];
    
    // 当当前的offer是最后一个的时候，需要回到0
    if (newoffset.x == self.collectionView.contentOffset.x) {
        newoffset = CGPointMake(0, newoffset.y);
    }

    [self.collectionView setContentOffset:newoffset animated:YES];
    
}
#pragma mark - tool
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

- (NSIndexPath *)currentShowingItem{
    
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        UICollectionViewLayoutAttributes * attribute = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
        CGPoint center = [self.collectionView convertPoint:self.collectionView.center fromView:nil];
        if (CGRectContainsPoint(attribute.frame,center)) {
//            NSLog(@"%@",indexPath);
            return indexPath;

        }
        
    }
    return nil;
}
#pragma mark - timer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    BOOL canScroll = self.collectionView.contentSize.width > self.collectionView.frame.size.width ? YES:NO;
    if (canScroll) {
        if (_timer == nil && [[self class] isDisplayedInScreen:self.collectionView]) {
           
            [self fireTimer];
        }
       
    }
}

- (void)fireTimer {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fire) object:nil];
    [self performSelector:@selector(fire) withObject:nil afterDelay:2];
    
}
- (void)fire {
    static NSInteger timerCount = 0;
    [self.timer fire];
    timerCount++;
//    NSLog(@"%ld",timerCount);

}

#pragma mark - collectionViewdelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {     // called when scroll view grinds to a halt
    [self fireTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    NSIndexPath * currentIndex = [self currentShowingItem];
    if (currentIndex == nil) {
        return;
    }
   [self.headerView updateCurrentPage:currentIndex.item+1 totalPage:[self.collectionView numberOfItemsInSection:0]];

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bannerDataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSBannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LSBannerCell class]) forIndexPath:indexPath];
    cell.entity = self.bannerDataArray[indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if ([kind isEqualToString:NSStringFromClass([LSBannerHeaderView class])]) {
        LSBannerHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([LSBannerHeaderView class]) forIndexPath:indexPath];
        header.label.text = @"今日活动";
        [header updateCurrentPage:indexPath.item+1 totalPage:[collectionView numberOfItemsInSection:0]];
        return header;
    }
    return nil;
}



#pragma mark - UICollectionViewLayoutDelegate
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return (CGSize){self.collectionView.ct_width,self.collectionView.ct_height};
//}


#pragma mark - getters & setters
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.customLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[LSBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([LSBannerCell class])];
//        [_collectionView registerClass:[LSBannerHeaderView class] forSupplementaryViewOfKind:NSStringFromClass([LSBannerHeaderView class]) withReuseIdentifier:NSStringFromClass([LSBannerHeaderView class])];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

    }
    return _collectionView;
}

- (LSBannerFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[LSBannerFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.minimumLineSpacing = 20;
//        CGSize item_size= CGSizeApplyAffineTransform(CGSizeMake(680/2.0,(280/2.0+21.0)),CGAffineTransformMakeScale(0.9, 0.9));
        _flowLayout.itemSize = CGSizeMake(680/2.0,(280/2.0+21.0));
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 12, 10, 12);
//        _flowLayout.headerReferenceSize = CGSizeMake(50, 50);
//        _flowLayout.footerReferenceSize = CGSizeMake(1.0f, 1.0f);
    }
    return _flowLayout;
}

- (LSBannerLayout *)customLayout{
    if (_customLayout == nil) {
        _customLayout = [[LSBannerLayout alloc] init];
        _customLayout.enableTransformAnimation = YES;
        _customLayout.itemSpacing = 10;
        _customLayout.itemSize = CGSizeMake(680/2.0,(280/2.0));
        _customLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        //        _customLayout.minimumInteritemSpacing = 10;
//        _customLayout.minimumLineSpacing = 20;
        //        CGSize item_size= CGSizeApplyAffineTransform(CGSizeMake(680/2.0,(280/2.0+21.0)),CGAffineTransformMakeScale(0.9, 0.9));
//        _customLayout.itemSize = CGSizeMake(680/2.0,(280/2.0+21.0));
//        _customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        _flowLayout.headerReferenceSize = CGSizeMake(50, 50);
        //        _flowLayout.footerReferenceSize = CGSizeMake(1.0f, 1.0f);
    }
    return _customLayout;
}

- (LSBannerHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[LSBannerHeaderView alloc] init];
        _headerView.label.text = @"今日活动";
    }
    return _headerView;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(flipNext) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

@end
