//
//  LSBannerCell.m
//  LSMessages
//
//  Created by lisa on 2017/12/18.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSBannerCell.h"
#import "UIView+LayoutMethods.h"
#import "HexColors.h"

static const NSMutableAttributedString * cellLableStyledString;
static CGFloat spaceBetweenImageAndDescription;


@implementation LSBannerCell
+ (void)initialize {
    if (self == [LSBannerCell class]) {
        spaceBetweenImageAndDescription = 6;

    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];
        
        [self.label addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
        [self.label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self calculateLayout];
}

- (void)dealloc {
    [self.label removeObserver:self forKeyPath:@"font"];
    [self.label removeObserver:self forKeyPath:@"text"];
    cellLableStyledString = nil;
}

- (void)calculateLayout {
    
// 此处计算实现了
    CGFloat totalWidth = self.contentView.ct_width;
    CGFloat totalHeight = self.contentView.ct_height;
    
    CGRect lableRect = [cellLableStyledString boundingRectWithSize:CGSizeMake(totalWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading context:nil];
    
    // image
    CGFloat imageWidth = totalWidth;
    CGFloat imageHeight = totalHeight-spaceBetweenImageAndDescription-lableRect.size.height;
    self.imageView.frame = (CGRect){0,0,imageWidth,imageHeight};
    
    // label
    BOOL isEmptyLabel = [[self class] isEmptyLabel:self.label];
    
    if (!isEmptyLabel) {
        // label
        self.label.ct_top = self.imageView.ct_bottom + spaceBetweenImageAndDescription;
        self.label.ct_left = self.imageView.ct_left;
        self.label.ct_width = totalWidth;
        self.label.ct_height = lableRect.size.height;
    }

}

+ (BOOL)isEmptyLabel:(UILabel*)label {
    BOOL isEmptyLabel = label.text == nil
    || [label.text isKindOfClass:[NSNull class]]
    || label.text.length==0;
    return isEmptyLabel;
}

+ (CGSize)calulateCellSizeWithImageSize:(CGSize)imageSize {
    
    CGFloat totalHeight = 0;
    CGFloat totalWidth = imageSize.width;
    
    // image
    totalHeight += totalWidth*imageSize.height/imageSize.width;
    
    //
    CGRect lableRect = [cellLableStyledString boundingRectWithSize:CGSizeMake(totalWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading context:nil];
    totalHeight += lableRect.size.height>0?(lableRect.size.height+spaceBetweenImageAndDescription):0;
    
    return CGSizeMake(totalWidth, totalHeight);
}

+ (void)setSpaceBetweenImageAndDescription:(CGFloat)space {
    spaceBetweenImageAndDescription = space;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"font"] && !self.label.hidden) {
        if (cellLableStyledString == nil) {
            cellLableStyledString = [[NSMutableAttributedString alloc] initWithAttributedString:_label.attributedText];
        }
        if (self.label.attributedText) {
              [cellLableStyledString setAttributedString:self.label.attributedText];
        }
    }
    else  if ([keyPath isEqualToString:@"text"] && !self.label.hidden) {
        if (cellLableStyledString == nil) {
            cellLableStyledString = [[NSMutableAttributedString alloc] initWithAttributedString:_label.attributedText];
           
        }
        
        if (self.label.attributedText) {
            [cellLableStyledString setAttributedString:self.label.attributedText];
        }
    }
}

#pragma marg - getters & setters
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.backgroundColor = [UIColor lightGrayColor];
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

@end

