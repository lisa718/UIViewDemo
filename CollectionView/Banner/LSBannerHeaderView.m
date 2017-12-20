//
//  LSBannerHeaderView.m
//  LSMessages
//
//  Created by lisa on 2017/12/18.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSBannerHeaderView.h"
#import "UIView+LayoutMethods.h"
#import "HexColors.h"

@interface LSBannerHeaderView ()
@property (nonatomic,strong) UILabel *pageLabel;
@property (nonatomic,assign) CGFloat height;


@end

@implementation LSBannerHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        [self addSubview:self.pageLabel];
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.height = self.ct_height;
    [self calculateLayout];
    
}

- (void)calculateLayout {
    
    CGFloat height = self.ct_height;
    
    self.imageView.ct_left = 0;
    self.imageView.ct_width = self.imageView.image.size.width;
    self.imageView.ct_height = self.imageView.image.size.height;
    
    // label
    self.label.ct_left = (self.imageView.image) ? self.imageView.ct_right + 8:0;
    [self.label sizeToFit];
    
    
    // pageLabel
    [self.pageLabel sizeToFit];
    self.pageLabel.ct_left = self.bounds.size.width - self.pageLabel.ct_width - 10;
    
    // ajust all view to center
    self.imageView.ct_centerY = height/2.0;
    self.label.ct_centerY = height/2.0;
    self.pageLabel.ct_centerY = height/2.0;
  
    // image
//    self.imageView.ct_left = 0;
//    self.imageView.ct_width = self.imageView.image.size.width;
//    self.imageView.ct_height = self.imageView.image.size.height;
//    self.height = MAX(self.height, self.imageView.ct_height);
//
//    // label
//    self.label.ct_left = (self.imageView.image) ? self.imageView.ct_right + 8:0;
//    [self.label sizeToFit];
//    self.height = MAX(self.height, self.label.ct_height);
//
//
//    // pageLabel
//    [self.pageLabel sizeToFit];
//    self.pageLabel.ct_left = self.bounds.size.width - self.pageLabel.ct_width - 10;
//    self.height = MAX(self.height,self.pageLabel.ct_height);
//
//    // ajust all view to center
//    self.imageView.ct_centerY = self.height/2.0;
//    self.label.ct_centerY = self.height/2.0;
//    self.pageLabel.ct_centerY = self.height/2.0;
}

- (CGSize)sizeThatFits:(CGSize)size {
    self.height = 0;
    [self calculateLayout];
    return CGSizeMake(self.ct_width,self.height);
}

#pragma mark - public
- (void)updateCurrentPage:(NSUInteger)currentPage totalPage:(NSUInteger)totalPage {

    self.pageLabel.text = [NSString stringWithFormat:@"%lu / %lu",(unsigned long)currentPage,totalPage];
    [self.pageLabel sizeToFit];

    [self.pageLabel setNeedsDisplay];
    [self.pageLabel setNeedsLayout];
}


#pragma marg - getters & setters

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.backgroundColor = [UIColor greenColor];
    }
    return _imageView;
}

- (UILabel*)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor colorWithHexString:@"#333333"];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 1;
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
        _label.font = [UIFont systemFontOfSize:15];

    }
    return _label;
}

- (UILabel*)pageLabel {
    if (_pageLabel == nil) {
        _pageLabel = [[UILabel alloc] init];
        _pageLabel.textColor = [UIColor colorWithHexString:@"#585858"];
        _pageLabel.textAlignment = NSTextAlignmentLeft;
        _pageLabel.numberOfLines = 1;
        _pageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _pageLabel.font = [UIFont systemFontOfSize:10];

    }
    return _pageLabel;
}

@end
