//
//  ViewControllerTestTableView.m
//  LSMessages
//
//  Created by lisa on 2017/12/10.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "ViewControllerTestTableView.h"
#import "TestTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ViewControllerTestTableView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) UITableViewCell *currentCell;

@end

@implementation ViewControllerTestTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableview];
    
    //
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * source = @[@"我们是的水电费水电费三等分是防守打法三等分说的三等分说的说的都是导师发生的发生的发生的都是顺丰速递说的说的说的说的是所得税是 都是发生的发生的说的都是粉色说的",
                             @"我的的水电费水电费",
                             @"我们是的水电费水电费三等分是防守打法三等分说的三等分说的说的都是导师发生的发生的发生的都是顺丰速递说的说的说的说的是所得税是我们是的水电费水电费三等分是防守打法三等分说的三等分说的说的都是导师发生的发生的发生的都是顺丰速递说的说的说的说的是所得税是我们是的水电费水电费三等分是防守打法三等分说的三等分说的说的都是导师发生的发生的发生的都是顺丰速递说的说的说的说的是所得税是"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.data = @[].mutableCopy;
            [self.data addObjectsFromArray:[source mutableCopy]];
            [self.tableview reloadData];
        });
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableview.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"FDFeedCell" configuration:^(TestTableViewCell *cell) {
//        cell.fd_enforceFrameLayout = YES;
//        cell.contentLabel.text = self.data[indexPath.row];
//    }];
//    return height;
    CGFloat height;
    static NSUInteger counts = 0;
    counts++;
    // 获取到当前的model
    height = [TestTableViewCell cellHeightWithModel:self.data[indexPath.row]];

    NSLog(@"call time %ld,height = %f",counts,height);
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
        cell.backgroundColor = altCellColor;
    }}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FDFeedCell" forIndexPath:indexPath];
    // old way
//    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FDFeedCell"];
//    if (cell == nil) {
//        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FDFeedCell"];
//    }
    cell.contentLabel.text = self.data[indexPath.row];
    
    return cell;
}

#pragma mark - getters & setters
- (UITableView *)tableview {
    if (_tableview == nil) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[TestTableViewCell class] forCellReuseIdentifier:@"FDFeedCell"];
        
    }
    return _tableview;
}

@end

