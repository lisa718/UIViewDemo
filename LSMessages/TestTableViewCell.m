//
//  TestTableViewCell.m
//  LSMessages
//
//  Created by lisa on 2017/12/10.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "TestTableViewCell.h"

@implementation TestTableViewCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.textColor = [UIColor redColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
//        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
        
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentLabel.frame = CGRectMake(0, 10, self.bounds.size.width-200, 14);
    // 改变label的bounds
    CGSize temp = CGSizeMake(self.bounds.size.width-200, 9000);
    CGFloat height = [self.contentLabel sizeThatFits:temp].height;
    [_contentLabel sizeToFit];
    NSLog(@"_contentlabel.height = %f",_contentLabel.bounds.size.height);
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    CGSize temp = CGSizeMake(self.bounds.size.width-200, 9000);
//    totalHeight += [self.contentLabel.text boundingRectWithSize:temp options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size.height;
    totalHeight += [self.contentLabel sizeThatFits:temp].height;
    totalHeight += 10; // margins
    NSLog(@"sizeThatFits totalHeight = %f",totalHeight);
    return CGSizeMake(size.width, totalHeight+1);
}

+ (CGFloat)cellHeightWithModel:(NSString*)model {
    CGFloat totalHeight = 0;
    CGSize temp = CGSizeMake([UIScreen mainScreen].bounds.size.width-200, 9000);
    totalHeight += [model boundingRectWithSize:temp options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    totalHeight += 10; // margins
    return totalHeight;
}

@end
