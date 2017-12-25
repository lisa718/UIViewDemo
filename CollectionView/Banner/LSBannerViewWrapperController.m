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
#import "UIImageView+WebCache.h"
#import "ViewController.h"

@interface LSBannerViewWrapperController() <LSBannerDataSource,LSBannerDelegate>
@property (nonatomic,strong) LSBannerView *bannerView;
@property (nonatomic,strong) NSMutableArray<LSBannerEntity *> *bannerDataArray;
@property (nonatomic,strong) UIButton *pushButton;

@end

@implementation LSBannerViewWrapperController

//@synthesize configureCellBlock;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bannerView stopTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.bannerView fireTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.bannerView];
    [self.view addSubview:self.pushButton];
    
//    __weak typeof(self) weakSelf = self;
//    self.configureCellBlock = ^(LSBannerCell *cell,NSInteger index) {
//        __strong typeof(self) strongSelf = weakSelf;
//        cell.entity = strongSelf.bannerDataArray[index];
//        cell.labelFont = [UIFont systemFontOfSize:10];
//
//    };
    
    
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
                [self.bannerView reloadData];

            });
        });
        
    });
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.bannerView.frame = CGRectMake(0, 100, self.view.ct_width, 300);
    [self.bannerView sizeToFit];
    
    self.pushButton.frame = CGRectMake(100, 300, 100, 30);

}
#pragma mark -
- (void)pushClick:(UIButton *)button {
    [self.navigationController pushViewController:[ViewController new] animated:YES];
}

#pragma mark - bannerview delegate

- (NSInteger)numberOfItemsInBannerView:(LSBannerView *)bannerView {
    return self.bannerDataArray.count;
}
- (void)bannerView:(LSBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index = %ld",index);
}

- (void)bannerViewDidScroll:(LSBannerView *)bannerView forCurrentItemAtIndex:(NSInteger)index {
     NSLog(@"index = %ld",index);
}

- (void)bannerView:(LSBannerView *)bannerView cellForConfig:(LSBannerCell * __autoreleasing *)cell index:(NSInteger)index {
    LSBannerCell * tagertCell =  *cell;
    LSBannerEntity *entity = self.bannerDataArray[index];
    [tagertCell.imageView sd_setImageWithURL:[NSURL URLWithString:entity.imageName] placeholderImage:nil];
//    tagertCell.label.font = [UIFont systemFontOfSize:30];
    tagertCell.label.text = entity.title;
//    [LSBannerCell setSpaceBetweenImageAndDescription:-10];
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
        _bannerView.enableAutoScroll = YES;
        _bannerView.enableInfinite = NO;
    }
    return _bannerView;
}
- (UIButton *)pushButton {
    if (_pushButton == nil) {
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_pushButton setTitle:@"push" forState:UIControlStateNormal];
        [_pushButton addTarget:self action:@selector(pushClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pushButton setFrame:CGRectMake(0, 0, 70, 40)];
        
    }
    return _pushButton;
}


@end
