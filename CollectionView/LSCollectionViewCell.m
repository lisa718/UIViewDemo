//
//  LSCollectionViewCell.m
//  LSMessages
//
//  Created by lisa on 2017/12/17.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSCollectionViewCell.h"

@implementation LSCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (UILabel*)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor purpleColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        _label.font = [UIFont systemFontOfSize:15];
        _label.layer.borderColor = [UIColor blueColor].CGColor;
        _label.layer.borderWidth = 1;
    }
    return _label;
}

@end
