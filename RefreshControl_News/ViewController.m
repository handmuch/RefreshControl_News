//
//  ViewController.m
//  RefreshControl_News
//
//  Created by POWER on 16/11/14.
//  Copyright © 2016年 Control. All rights reserved.
//

#import "ViewController.h"
#import "RefreshControl.h"
#import "RefreshNewsView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) RefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initView];
    [self initDataWithLoad:NO];
}

- (void)initDataWithLoad:(BOOL)isLoad
{
    self.dataArray = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < 10; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"数据%d", arc4random()%1000]];
    }
    
    if (isLoad) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshControl finishTopRfreshWithString:[NSString stringWithFormat:@"为你推荐了%lu条新消息",(unsigned long)self.dataArray.count]];
            [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
            [self.tableView reloadData];
        });
    }else{
        [self.tableView reloadData];
    }

}

- (void)initView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.refreshControl = [[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    [self.refreshControl registerClassForRefreshNewsView:[RefreshNewsView class]];
   	self.refreshControl.sysDefaultInsetOfScroller = self.tableView.contentInset;
    self.refreshControl.refreshViewEnabled = YES;
    self.refreshControl.topEnabled = YES;
    self.refreshControl.bottomEnabled = NO;
}

#pragma mark - RefreshControl delegate

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    [self initDataWithLoad:YES];
}

#pragma mark - tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
