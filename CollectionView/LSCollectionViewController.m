//
//  LSCollectionViewController.m
//  LSMessages
//
//  Created by lisa on 2017/12/17.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSCollectionViewController.h"
#import "LSCollectionViewCell.h"
#import "UIView+LayoutMethods.h"

@interface LSCollectionViewController() <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout * flowLayout;
@end

@implementation LSCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 200);
//    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//        self.collectionView.ct_width = self.collectionView.collectionViewLayout.collectionViewContentSize.width+1;
//    }
//    else {
//        self.collectionView.ct_width = self.collectionView.collectionViewLayout.collectionViewContentSize.height+1;
//    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10000;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSCollectionViewCell" forIndexPath:indexPath];
    cell.label.text = [@(indexPath.item) stringValue];
    return cell;
}

#pragma mark - UICollectionViewLayoutDelegate
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item % 2 == 0) {
//        return CGSizeMake(collectionViewLayout.itemSize.width * 2, collectionViewLayout.itemSize.height *2);
//    }
//    return collectionViewLayout.itemSize;
//}


#pragma mark - getters & setters
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LSCollectionViewCell class] forCellWithReuseIdentifier:@"LSCollectionViewCell"];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _collectionView.backgroundColor = [UIColor grayColor];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(50, 50);
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.minimumLineSpacing = 20;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
        _flowLayout.headerReferenceSize = CGSizeMake(50, 50);
    }
    return _flowLayout;
}

@end
