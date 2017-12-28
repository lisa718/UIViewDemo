//
//  LSUserInfoList.h
//  LSMessages
//
//  Created by baidu on 2017/12/28.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LSUserInfo.h"

@protocol LSUserInfo @end


@interface LSUserInfoList : JSONModel

@property (nonatomic,strong) NSMutableArray<LSUserInfo> * feed;


@end
