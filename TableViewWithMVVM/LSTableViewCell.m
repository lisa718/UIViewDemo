//
//  LSTableViewCell.m
//  LSMessages
//
//  Created by baidu on 2017/12/28.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSUserInfo.h"
#import "UIView+LayoutMethods.h"

@implementation LSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
     CGSize size = [UIScreen mainScreen].bounds.size;
    self.titleLabel.frame = CGRectMake(0, 0, size.width, [self.titleLabel sizeThatFits:size].height);

    
    self.contentLabel.frame = CGRectMake(0, self.titleLabel.ct_bottom, self.titleLabel.ct_width, [self.contentLabel sizeThatFits:size].height);
//    [self.contentLabel sizeToFit];
}


+ (CGFloat)cellHeight:(LSUserInfo *)info {
    
    CGFloat totalHeight = 0;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    // title
    UILabel *_titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor redColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [_titleLabel setText:info.title];
    totalHeight +=[_titleLabel sizeThatFits:size].height;
    
    //content
    UILabel * _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor redColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.font = [UIFont systemFontOfSize:13];
    [_contentLabel setText:info.content];
    totalHeight +=[_contentLabel sizeThatFits:size].height;
    totalHeight += 10;
    
    return totalHeight;
}

#pragma mark -getters & setters
- (UILabel*)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.font = [UIFont systemFontOfSize:20];
//        _titleLabel.layer.borderColor = [UIColor blueColor].CGColor;
//        _titleLabel.layer.borderWidth = 1;
    }
    return _titleLabel;
}
- (UILabel*)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor redColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.font = [UIFont systemFontOfSize:13];
//        _contentLabel.layer.borderColor = [UIColor grayColor].CGColor;
//        _contentLabel.layer.borderWidth = 1;
    }
    return _contentLabel;
}


@end
