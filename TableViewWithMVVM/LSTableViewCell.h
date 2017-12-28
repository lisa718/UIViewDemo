//
//  LSTableViewCell.h
//  LSMessages
//
//  Created by baidu on 2017/12/28.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSUserInfo;
@interface LSTableViewCell : UITableViewCell

@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UILabel *contentLabel;


+ (CGFloat)cellHeight:(LSUserInfo *)info;

@end
