//
//  LSCollectionViewController.m
//  LSMessages
//
//  Created by lisa on 2017/12/17.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSBannerViewWrapperController.h"
#import "UIView+LayoutMethods.h"
#import "LSBannerHeaderView.h"
#import "LSBannerView.h"
#import "LSBannerCell.h"
#import "LSBannerEntity.h"


@interface LSBannerViewWrapperController() <LSBannerDataSource,LSBannerDelegate>
@property (nonatomic,strong) LSBannerView *bannerView;
@property (nonatomic,strong) NSMutableArray<LSBannerEntity *> *bannerDataArray;

@end

@implementation LSBannerViewWrapperController

@synthesize configureCellBlock;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.bannerView];
    
    __weak typeof(self) weakSelf = self;
    self.configureCellBlock = ^(LSBannerCell *cell,NSInteger index) {

        __strong typeof(self) strongSelf = weakSelf;
        cell.entity = strongSelf.bannerDataArray[index];
        cell.labelFont = [UIFont systemFontOfSize:10];

    };

    // loaddata From jsonFile
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 从文件中读取
        NSString * jsonFilePath = [[NSBundle mainBundle] pathForResource:@"banner_data" ofType:@"json"];
        NSData * data = [NSData dataWithContentsOfFile:jsonFilePath];
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray *bannerArray = @[].mutableCopy;
        [rootDic[@"list"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LSBannerEntity * entity = [[LSBannerEntity alloc] initWithDictionary:obj];
            [bannerArray addObject:entity];
        }];
        
        // main 更新
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.bannerDataArray = @[].mutableCopy;
                [self.bannerDataArray addObjectsFromArray:bannerArray.mutableCopy];
                [self.bannerView reloadData];

            });
        });
        
    });
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.bannerView.frame = CGRectMake(0, 100, self.view.ct_width, 300);
    [self.bannerView sizeToFit];

}

#pragma mark -
- (NSInteger)numberOfItemsInBannerView:(LSBannerView *)bannerView {
    return self.bannerDataArray.count;
}
- (void)bannerView:(LSBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index = %d",index);
}


#pragma mark - getters & setters
- (LSBannerView *)bannerView {
    if (_bannerView == nil) {
        _bannerView = [LSBannerView new];
        _bannerView.itemSpacing = 10;
        _bannerView.imageSize = CGSizeMake(680/2.0, 280/2.0);
        _bannerView.sectionInset = UIEdgeInsetsMake(10, 12, 10, 12);
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        _bannerView.enableTransformAnimation = YES;
    }
    return _bannerView;
}



@end
