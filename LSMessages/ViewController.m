//
//  ViewController.m
//  LSMessages
//
//  Created by lisa on 2017/11/25.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "ViewController.h"
#import "LSMessage.h"
#import "ViewControllerTestTableView.h"
#import "LSHeightCalculationViewController.h"
#import "LSCollectionViewController.h"
#import "LSBannerViewController.h"
#import "LSBannerViewWrapperController.h"
#import "LSFloatingLabelManager.h"
#import "LSNavbarAnimationController.h"

static __weak UINavigationBar * lastNavBar;
@interface ViewController ()

// transition
@property (nonatomic,strong) UIStackView *transitionContainerView;
@property (nonatomic,strong) UIButton *pushBtn;
@property (nonatomic,strong) UIButton *presentBtn;
@property (nonatomic,strong) UIButton *overbarBtn;
@property (nonatomic,strong) UIButton *hideNavbarBtn;

// top
@property (nonatomic,strong) UIStackView *topContainerView;
@property (nonatomic,strong) UIButton *heightCalculateBtn;
@property (nonatomic,strong) UIButton *collectionViewBtn;
@property (nonatomic,strong) UIButton *bannerBtn;
@property (nonatomic,strong) UIButton *floatLabelBtn;


// bottom + stay
@property (nonatomic,strong) UIStackView *bottomContainerView;
@property (nonatomic,strong) UIButton *dimissBtn;
@property (nonatomic,strong) UIButton *navbarAnimationBtn;
@property (nonatomic,strong) UIButton *bottomErrorStayBtn;
@property (nonatomic,strong) UIButton *bottomSuccessBtn;



@end

@implementation ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // nav
    self.title = @"测试提示框";
//    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    UIView * systemBackgroundView = [self.navigationController.navigationBar valueForKey:@"backgroundView"];
    UIView * customBackgroundView = [[UIView alloc] initWithFrame:systemBackgroundView.frame];
    customBackgroundView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:1];
    if (lastNavBar != self.navigationController.navigationBar && lastNavBar != nil) {
        customBackgroundView.backgroundColor = [UIColor redColor];
    }
    lastNavBar = self.navigationController.navigationBar;

    [self.navigationController.navigationBar setValue:customBackgroundView forKey:@"backgroundView"];
    
    

    if (self.navigationController == nil) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setFrame:CGRectMake(0, 0, 70, 40)];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.view addSubview:closeButton];
    }
    
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    // image for blur test
    UIImage *img = [UIImage imageNamed:@"1"];
    UIImageView *blurTestView = [[UIImageView alloc] initWithImage:img];
    blurTestView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [self.view addSubview:blurTestView];
    
    // transition stack view
    self.transitionContainerView.frame = CGRectMake(0, 300, self.view.bounds.size.width, 100);
    [self.view addSubview:self.transitionContainerView];
    [self.transitionContainerView addArrangedSubview:self.presentBtn];
    [self.transitionContainerView addArrangedSubview:self.pushBtn];
    [self.transitionContainerView addArrangedSubview:self.overbarBtn];
    
    
    // Top stack view
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.topContainerView.frame = CGRectMake(0, 400, self.view.bounds.size.width, 100);

    [self.view addSubview:self.topContainerView];
    [self.topContainerView addArrangedSubview:self.heightCalculateBtn];
    [self.topContainerView addArrangedSubview:self.collectionViewBtn];
    [self.topContainerView addArrangedSubview:self.bannerBtn];
    [self.topContainerView addArrangedSubview:self.floatLabelBtn];

    // Bottom
    [self.view addSubview:self.bottomContainerView];
    [self.bottomContainerView addArrangedSubview:self.dimissBtn];
    [self.bottomContainerView addArrangedSubview:self.navbarAnimationBtn];
    [self.bottomContainerView addArrangedSubview:self.bottomErrorStayBtn];
    [self.bottomContainerView addArrangedSubview:self.bottomSuccessBtn];

    [self configLayout];
}


- (void)configLayout {
    self.transitionContainerView.frame = CGRectMake(0, 300, self.view.bounds.size.width, 100);
    self.topContainerView.frame = CGRectMake(0, 400, self.view.bounds.size.width, 100);
    self.bottomContainerView.frame = CGRectMake(0, 500, self.view.bounds.size.width, 100);
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self configLayout];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)close {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)transitionClick :(UIButton *)button {
    if (button == self.pushBtn) {
        [self.navigationController pushViewController:[ViewControllerTestTableView new] animated:YES] ;
    }
    else if (button == self.presentBtn) {
        [self presentViewController:[[[self class] alloc] init] animated:YES completion:nil];
    }
}

- (void)heightCalculateBtnClick:(UIButton *)button {

    [LSMessage showMessageWithTitle:@"计算高度" subtitle:@"这里有三种计算高度的方法：sizeToFit,sizeThatFit,boundRect" type:LSMessageType_Success];
    [self.navigationController pushViewController:[LSHeightCalculationViewController new] animated:YES];
}

- (void)floatLabelClick:(UIButton *)button {
//    [LSFloatingLabelManager show];
}

- (void)collectionViewClick:(UIButton *)button {
    [LSMessage showMessageInViewController:self.navigationController
                                         title:@"进入collectionView"
                                      subtitle:@"评论成功啦！"
                                         image:nil
                                          type:LSMessageType_Error
                                  durationSecs:LSMessageDuration_Seconds_AutoDisappear_After4
                                    atPosition:LSMessagePosition_Top];
    [self.navigationController pushViewController:[LSCollectionViewController new] animated:YES];
    
}
- (void)bannerBtnClick:(UIButton *)button {

    [self.navigationController pushViewController:[LSBannerViewWrapperController new] animated:YES];

    
}

- (void)navbarAnimationBtnClick:(UIButton *)button {
    [self.navigationController pushViewController:[LSNavbarAnimationController new] animated:YES];
}

- (void)overbarBtnClick:(UIButton *)button {
    [LSMessage showMessageInViewController:self.navigationController
                                         title:@"SDsdfSDfsdfdfsdfsdf"
                                      subtitle:@"sdfsdfsdfsdfsdf"
                                         image:nil
                                          type:LSMessageType_Message
                                  durationSecs:LSMessageDuration_Seconds_Stay
                                    atPosition:LSMessagePosition_OverNavBar];
}

- (void)bottomSuccessBtnClick:(UIButton *)button {
    [LSMessage showMessageInViewController:self.navigationController
                                         title:@"底部成功了"
                                      subtitle:@"设置成功了底部的弹框"
                                         image:nil
                                          type:LSMessageType_Success
                                  durationSecs:LSMessageDuration_Seconds_AutoDisappear_After4
                                    atPosition:LSMessagePosition_Bottom];
}
- (void)bottomErrorStayBtnClick:(UIButton *)button {
    [LSMessage showMessageInViewController:self.navigationController
                                         title:@"底部成功了"
                                      subtitle:@"设置成功了底部的弹框"
                                         image:nil
                                          type:LSMessageType_Error
                                  durationSecs:LSMessageDuration_Seconds_Stay
                                    atPosition:LSMessagePosition_Bottom];
}

- (void)dimissBtnClick:(UIButton *)button {
    [LSMessage dismissActiveMessage];
}


#pragma mark - getters & setters
- (UIButton *)heightCalculateBtn {
    if (_heightCalculateBtn == nil) {
        _heightCalculateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_heightCalculateBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_heightCalculateBtn setTitle:@"计算高度" forState:UIControlStateNormal];
        [_heightCalculateBtn addTarget:self action:@selector(heightCalculateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_heightCalculateBtn setFrame:CGRectMake(0, 0, 70, 40)];

    }
    return _heightCalculateBtn;
}

- (UIButton *)collectionViewBtn {
    if (_collectionViewBtn == nil) {
        _collectionViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionViewBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_collectionViewBtn setTitle:@"CollectionView" forState:UIControlStateNormal];
        [_collectionViewBtn addTarget:self action:@selector(collectionViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_collectionViewBtn setFrame:CGRectMake(0, 0, 70, 40)];
        
    }
    return _collectionViewBtn;
}

- (UIButton *)bannerBtn {
    if (_bannerBtn == nil) {
        _bannerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bannerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_bannerBtn setTitle:@"Banner" forState:UIControlStateNormal];
        [_bannerBtn addTarget:self action:@selector(bannerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bannerBtn setFrame:CGRectMake(0, 0, 70, 40)];
        
    }
    return _bannerBtn;
}

- (UIButton *)floatLabelBtn {
    if (_floatLabelBtn == nil) {
        _floatLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_floatLabelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_floatLabelBtn setTitle:@"浮动球" forState:UIControlStateNormal];
        [_floatLabelBtn addTarget:self action:@selector(floatLabelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_floatLabelBtn setFrame:CGRectMake(0, 0, 70, 40)];
        
    }
    return _floatLabelBtn;
}

- (UIButton *)navbarAnimationBtn {
    if (_navbarAnimationBtn == nil) {
        _navbarAnimationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navbarAnimationBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_navbarAnimationBtn setTitle:@"导航动画" forState:UIControlStateNormal];
        [_navbarAnimationBtn addTarget:self action:@selector(navbarAnimationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navbarAnimationBtn setFrame:CGRectMake(0, 0, 70, 40)];
        
    }
    return _navbarAnimationBtn;
}
- (UIButton *)dimissBtn {
    if (_dimissBtn == nil) {
        _dimissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dimissBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_dimissBtn setTitle:@"dismiss" forState:UIControlStateNormal];
        [_dimissBtn addTarget:self action:@selector(dimissBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_dimissBtn setFrame:CGRectMake(0, 0, 70, 40)];
    }
    return _dimissBtn;
}

- (UIStackView *)topContainerView {
    if (_topContainerView == nil) {
        _topContainerView = [[UIStackView alloc] init];
        _topContainerView.axis = UILayoutConstraintAxisHorizontal;
        _topContainerView.distribution = UIStackViewDistributionFillEqually;
        _topContainerView.alignment = UIStackViewAlignmentCenter;
        _topContainerView.spacing = 10;

    }
    return _topContainerView;
}

- (UIStackView *)bottomContainerView {
    if (_bottomContainerView == nil) {
        _bottomContainerView = [[UIStackView alloc] init];
        _bottomContainerView.axis = UILayoutConstraintAxisHorizontal;
        _bottomContainerView.distribution = UIStackViewDistributionFillEqually;
        _bottomContainerView.alignment = UIStackViewAlignmentCenter;
        _bottomContainerView.spacing = 10;
        
    }
    return _bottomContainerView;
}

- (UIStackView *)transitionContainerView {
    if (_transitionContainerView == nil) {
        _transitionContainerView = [[UIStackView alloc] init];
        _transitionContainerView.axis = UILayoutConstraintAxisHorizontal;
        _transitionContainerView.distribution = UIStackViewDistributionFillEqually;
        _transitionContainerView.alignment = UIStackViewAlignmentCenter;
        _transitionContainerView.spacing = 10;
        
    }
    return _transitionContainerView;
}

- (UIButton *)bottomSuccessBtn {
    if (_bottomSuccessBtn == nil) {
        _bottomSuccessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomSuccessBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_bottomSuccessBtn setTitle:@"BottomSuccess" forState:UIControlStateNormal];
        [_bottomSuccessBtn addTarget:self action:@selector(bottomSuccessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomSuccessBtn setFrame:CGRectMake(0, 0, 70, 60)];
    }
    return _bottomSuccessBtn;
}

- (UIButton *)bottomErrorStayBtn {
    if (_bottomErrorStayBtn == nil) {
        _bottomErrorStayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomErrorStayBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_bottomErrorStayBtn setTitle:@"BottomErrorStay" forState:UIControlStateNormal];
        [_bottomErrorStayBtn addTarget:self action:@selector(bottomErrorStayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomErrorStayBtn setFrame:CGRectMake(0, 0, 70, 60)];
        
    }
    return _bottomErrorStayBtn;
}

- (UIButton *)pushBtn {
    if (_pushBtn == nil) {
        _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_pushBtn setTitle:@"Push" forState:UIControlStateNormal];
        [_pushBtn addTarget:self action:@selector(transitionClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pushBtn setFrame:CGRectMake(0, 0, 70, 40)];
        
    }
    return _pushBtn;
}

- (UIButton *)presentBtn {
    if (_presentBtn == nil) {
        _presentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_presentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_presentBtn setTitle:@"Present" forState:UIControlStateNormal];
        [_presentBtn addTarget:self action:@selector(transitionClick:) forControlEvents:UIControlEventTouchUpInside];
        [_presentBtn setFrame:CGRectMake(0, 0, 70, 40)];
        
    }
    return _presentBtn;
}

- (UIButton *)overbarBtn {
    if (_overbarBtn == nil) {
        _overbarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_overbarBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_overbarBtn setTitle:@"OverbarSuccess" forState:UIControlStateNormal];
        [_overbarBtn addTarget:self action:@selector(overbarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_overbarBtn setFrame:CGRectMake(0, 0, 70, 40)];
        
    }
    return _overbarBtn;
}

@end
