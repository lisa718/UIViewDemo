//
//  LSUserInfoViewModel.h
//  LSMessages
//
//  Created by baidu on 2017/12/28.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@class LSUserInfo;
@interface LSUserInfoListViewModel : JSONModel

@property (nonatomic,strong) NSMutableArray<LSUserInfo*> * inforArray;

- (void)loadFirstPage;
- (void)loadFirstPageWithComplicationBlock:(void(^)(void))complication;

@end
