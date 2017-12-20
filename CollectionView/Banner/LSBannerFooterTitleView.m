//
//  LSBannerFooterTitleView.m
//  LSMessages
//
//  Created by baidu on 2017/12/18.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "LSBannerFooterTitleView.h"
#import "UIView+LayoutMethods.h"
#import "HexColors.h"

@implementation LSBannerFooterTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.ct_top = self.ct_bottom + 6;
    self.label.ct_left = self.ct_left;
    self.label.ct_width = self.ct_width;
    self.label.ct_height = [self.label sizeThatFits:CGSizeMake(self.label.ct_width, CGFLOAT_MAX)].height;
    
}

#pragma mark - getters & setters

- (UILabel*)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor colorWithHexString:@"#333333"];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 1;
#warning ...
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
        _label.font = [UIFont systemFontOfSize:15];
        _label.layer.borderColor = [UIColor blueColor].CGColor;
        _label.layer.borderWidth = 1;
    }
    return _label;
}

@end
