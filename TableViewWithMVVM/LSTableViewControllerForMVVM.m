//
//  LSTableViewControllerForMVVM.m
//  LSMessages
//
//  Created by baidu on 2017/12/28.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "LSTableViewControllerForMVVM.h"
#import "LSTableViewCell.h"
#import "LSUserInfoListViewModel.h"
#import "LSUserInfo.h"

@interface LSTableViewControllerForMVVM ()

@property (nonatomic,strong) LSUserInfoListViewModel *listViewModel;


@end

@implementation LSTableViewControllerForMVVM

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[LSTableViewCell class] forCellReuseIdentifier:@"FDFeedCell"];
    
    [self.listViewModel addObserver:self forKeyPath:@"inforArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionNew context:nil];
    self.listViewModel = [[LSUserInfoListViewModel alloc] init];
//    [self.listViewModel loadFirstPage];
    [self.listViewModel loadFirstPageWithComplicationBlock:^{
        [self.tableView reloadData];

    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"inforArray"]) {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height = [LSTableViewCell cellHeight:self.listViewModel.inforArray[indexPath.row]];
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
        cell.backgroundColor = altCellColor;
    }}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listViewModel.inforArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FDFeedCell" forIndexPath:indexPath];
    LSUserInfo * infor = self.listViewModel.inforArray[indexPath.row];
    cell.titleLabel.text = infor.title;
    cell.contentLabel.text = infor.content;
    
    return cell;
}


@end
