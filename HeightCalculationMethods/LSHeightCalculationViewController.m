//
//  LSHeightCalculationViewController.m
//  LSMessages
//  @ 此类的主要功能是用来总结，Text View各种高度计算方法以及计算效果对比
//  @ https://app.yinxiang.com/shard/s29/nl/6583317/ac9f895f-ff62-4737-9975-3b7316bb4cd9/
//  Created by lisa on 2017/12/14.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSHeightCalculationViewController.h"
#import "UIView+LayoutMethods.h"
// 策略模式
#import "LSHeightCalculationContext.h"
#import "LSSizeToFit.h"
#import "LSSizeThatFits.h"
#import "LSBoundsRect.h"
#import "LSHeightCalculationStrategy.h"

static NSString * nonStyledTexts;
static NSAttributedString * styledTexts;

typedef NS_ENUM(NSUInteger, LSHeightCalculation) {
    LSHeightCalculation_SizeToFit = 0,
    LSHeightCalculation_SizeThatFits = 1,
    LSHeightCalculation_boundingRectWithSize = 2
};

@interface LSHeightCalculationViewController ()

// 存放计算高度算法：有四种:sizeToFit,sizeThatFits,boundingRectWithSize,system...,
// 使用策略模式来进行结构行为优化
@property (nonatomic,strong) UISegmentedControl * segment;

// 展示Text的view
@property (nonatomic,strong) UILabel        *label;
@property (nonatomic,strong) UITextField    *textField;
@property (nonatomic,strong) UITextView     *textView;

@property (nonatomic,strong) UILabel        *labelStyled;
@property (nonatomic,strong) UITextField    *textFieldStyled;
@property (nonatomic,strong) UITextView     *textViewStyled;


@end

@implementation LSHeightCalculationViewController

#pragma mark - init
+ (void)initialize {
    if (self == [LSHeightCalculationViewController class] ) {
        nonStyledTexts = @"👌会大喊大叫奶粉会大喊大叫奶粉     👌会大喊大叫奶粉👌会大喊大叫奶粉👌会大喊大叫奶粉👌会大喊大叫奶粉👌";
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentRight;
        paragraphStyle.headIndent = 4.0;
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.lineSpacing = 2.0;
        styledTexts = [[NSAttributedString alloc] 
                       initWithString:nonStyledTexts
                       attributes:@{
                                    NSFontAttributeName:[UIFont systemFontOfSize:19],
                                    NSBackgroundColorAttributeName:[UIColor grayColor],
                                    NSParagraphStyleAttributeName:paragraphStyle}];
    }
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view addSubview:self.segment];
//    self.view.backgroundColor = [UIColor grayColor];
    [self.navigationItem setTitleView:self.segment];
    [self.view addSubview:self.label];
    [self.view addSubview:self.labelStyled];
//    [self.view addSubview:self.textField];
//    [self.view addSubview:self.textView];
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - layout
- (void)layout {
    
    CGFloat padding = 20;
    CGFloat width = 150;
    CGFloat height = 10;// should modifed
    // label
    self.label.ct_top = padding+64;
    self.label.ct_left = padding;
    self.label.ct_width = width;
    self.label.ct_height = height;
    
    self.labelStyled.ct_top = self.label.ct_top;
    self.labelStyled.ct_left = self.label.ct_right + padding;
    self.labelStyled.ct_width = self.label.ct_width;
    self.labelStyled.ct_height = height;
    
    LSHeightCalculationContext * context;
    if (self.segment.selectedSegmentIndex == LSHeightCalculation_SizeToFit) {
        
        context = [[LSHeightCalculationContext alloc] initWithHeightCalculationStrategy:[LSSizeToFit new]];
       
    }
    else if (self.segment.selectedSegmentIndex == LSHeightCalculation_SizeThatFits) {
        
        context = [[LSHeightCalculationContext alloc] initWithHeightCalculationStrategy:[LSSizeThatFits new]];
        
    }
    else if (self.segment.selectedSegmentIndex == LSHeightCalculation_boundingRectWithSize) {
        context = [[LSHeightCalculationContext alloc] initWithHeightCalculationStrategy:[LSBoundsRect new]];
    }
    [context sizeFitForTextView:self.label];
    [context sizeFitForTextView:self.labelStyled];
}

#pragma segment action
- (void)segmentSelected:(UISegmentedControl *)segment {
    [self.view setNeedsLayout];
}

#pragma mark - getters & setters
- (UISegmentedControl *)segment {
    if (_segment == nil) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"sizeToFit",@"sizeThatFit",@"boundRect"]];
        _segment.selectedSegmentIndex = LSHeightCalculation_SizeToFit;
        [_segment addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (UILabel*)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor redColor];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 0;
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        _label.font = [UIFont systemFontOfSize:15];
        _label.text = nonStyledTexts;
        _label.layer.borderColor = [UIColor blueColor].CGColor;
        _label.layer.borderWidth = 1;
    }
    return _label;
}

- (UILabel*)labelStyled {
    if (_labelStyled == nil) {
        _labelStyled = [[UILabel alloc] init];
        _labelStyled.textColor = [UIColor redColor];
        _labelStyled.textAlignment = NSTextAlignmentLeft;
        _labelStyled.numberOfLines = 0;
        _labelStyled.lineBreakMode = NSLineBreakByWordWrapping;
        _labelStyled.font = [UIFont systemFontOfSize:15];
        _labelStyled.attributedText = styledTexts;
        _labelStyled.layer.borderColor = [UIColor blueColor].CGColor;
        _labelStyled.layer.borderWidth = 1;
    }
    return _labelStyled;
}

@end
