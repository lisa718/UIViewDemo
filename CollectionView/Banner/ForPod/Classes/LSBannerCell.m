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

@interface LSBannerCell ()


@end

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
        self.label.hidden = YES;

        [self.label addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self calculateLayout];
}

- (void)dealloc {
    [self.label removeObserver:self forKeyPath:@"font"];
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
    BOOL isEmptyLabel = self.label.text == nil
                         || [self.label.text isKindOfClass:[NSNull class]]
                         || self.label.text.length==0;
    
    
    if (!isEmptyLabel) {
        self.label.hidden = NO;
        // label
        self.label.ct_top = self.imageView.ct_bottom + spaceBetweenImageAndDescription;
        self.label.ct_left = self.imageView.ct_left;
        self.label.ct_width = totalWidth;
        self.label.ct_height = lableRect.size.height;
    }
    else {
        self.label.hidden = YES;
    }
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
    if ([keyPath isEqualToString:@"font"]) {
        if (self.label.attributedText) {
              [cellLableStyledString setAttributedString:self.label.attributedText];
        }
    }
}

#pragma marg - getters & setters
//- (void)setEntity:(LSBannerEntity *)entity {
//    _entity = entity;
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:entity.imageName] placeholderImage:_placeholderImage];
//    self.label.text = entity.title;
//}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
#warning need to optimize
        _imageView.layer.cornerRadius = 6.0;
        _imageView.layer.masksToBounds = YES;
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
        if (cellLableStyledString == nil) {
            cellLableStyledString = [[NSMutableAttributedString alloc] initWithAttributedString:_label.attributedText];
        }
    }
    return _label;
}

//- (void)setLabelFont:(UIFont *)labelFont {
//    _labelFont = labelFont;
//    [self.label setFont:labelFont];
//}
//
//- (void)setLabelColor:(UIColor *)lableColor {
//    _labelColor = lableColor;
//    self.label.textColor = lableColor;
//}

@end
