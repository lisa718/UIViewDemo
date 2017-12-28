//
//  LSUserInfoViewModel.m
//  LSMessages
//
//  Created by baidu on 2017/12/28.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "LSUserInfoListViewModel.h"
#import "LSUserInfo.h"
#import "LSUserInfoList.h"

@implementation LSUserInfoListViewModel


- (void)loadFirstPage {
    // 模拟从文件加载数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 从文件中读取
        NSString * jsonFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData * data = [NSData dataWithContentsOfFile:jsonFilePath];
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        
        LSUserInfoList * list = [[LSUserInfoList alloc] initWithData:data error:nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.inforArray == nil) {
                self.inforArray = @[].mutableCopy;
            }
            else {
                [self.inforArray removeAllObjects];
            }
            [self.inforArray addObjectsFromArray:list.feed];
        });
    });
}

- (void)loadFirstPageWithComplicationBlock:(void(^)(void))complication {
    
    // 模拟从文件加载数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 从文件中读取
        NSString * jsonFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData * data = [NSData dataWithContentsOfFile:jsonFilePath];
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        
        LSUserInfoList * list = [[LSUserInfoList alloc] initWithData:data error:nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.inforArray == nil) {
                self.inforArray = @[].mutableCopy;
            }
            else {
                [self.inforArray removeAllObjects];
            }
            [self.inforArray addObjectsFromArray:list.feed];
            complication();
        });
    });
}

//- (NSMutableArray *)inforArray {
//    return [self mutableArrayValueForKey:@"inforArray"];
//}

//- (void)addInforArray:(NSArray *)inforArray {
//    [[self inforArray] addObjectsFromArray:inforArray];
//}
//
//- (void)addInfor:(LSUserInfo *)infor {
//    [[self inforArray] addObject:infor];
//}

@end
