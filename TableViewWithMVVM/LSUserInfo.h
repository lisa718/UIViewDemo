//
//  LSUserInfo.h
//  LSMessages
//
//  Created by baidu on 2017/12/28.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface LSUserInfo : JSONModel

@property (nonatomic,copy) NSString<Optional> * title;
@property (nonatomic,copy) NSString<Optional> * content;
//@property (nonatomic,copy) NSString * userName;
//@property (nonatomic,copy) NSString * time;
//@property (nonatomic,copy) NSString<Optional> * imageName;



@end
