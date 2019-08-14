

//
//  YPBaseTableController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/13.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPBaseTableController.h"

@interface YPBaseTableController ()

@property (nonatomic,assign) UITableViewStyle style;

@end

@implementation YPBaseTableController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super init]) {
        _style = style;
    }
    return self;
}

-(instancetype)init {
    if (self == [super init]) {
        self.style = UITableViewStylePlain;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSubViewInit];
}

- (void)baseSubViewInit {
    
    _page     = 1;
    _pageSize = 15;
    self.emptyTitle = @"暂无数据";
    self.emptyDesc  = @"";

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)setRefreshing {
    
    [self setUpRefreshing];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page += 1;
        [weakSelf loadDataSource];
    }];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

-(void)setUpRefreshing {
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page = 1;
        [weakSelf loadDataSource];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}

-(void)loadDataSource {
    
    [self endRefreshing];
    [self.tableView reloadData];
}

-(void)endRefreshing {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)endNoMoreRefreshing {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

-(void)setEmptyDelegate {
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

#pragma mark -- TableView DataSource Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

#pragma mark -- TableView Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark -- Empty delegate
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    BOOL isNet = [YPReachability shareInstall].hasNet;
    return isNet ? ((self.dataList.count) ? NO : YES) : YES;
}

//是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return NO;
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    BOOL isNet = [YPReachability shareInstall].hasNet;
    return isNet ? self.emptyImage ? self.emptyImage : [UIImage imageNamed:@"emptyNothing"] : [UIImage imageNamed:@"emptyNoNet"];
}

-(CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 30.0f;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - (self.tableView.tableHeaderView.bounds.size.height/2 + kStatusAndNavBarH/2);
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = ([YPReachability shareInstall].hasNet == NO) ? @"网络走丢了" : self.emptyTitle;
    UIFont *font = [UIFont systemFontOfSize:14.0];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:HEXColor(0x666666) range:NSMakeRange(0, text.length)];
    return attStr;
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = ([YPReachability shareInstall].hasNet == NO) ? @"请检查您的网络" : self.emptyDesc;
    UIFont *font = [UIFont systemFontOfSize:12.0];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:HEXColor(0x999999) range:NSMakeRange(0, text.length)];
    return attStr;
}

-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    self.emptyTapBlock ? self.emptyTapBlock() : nil;
}

#pragma mark -- Getter
-(UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [[YPTableView alloc] initWithFrame:CGRectZero style:self.style];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.touchDelegate   = self;
        _tableView.backgroundColor = HEXColor(0xFFFFFF);

        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
        
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
        _tableView.layoutMargins   = UIEdgeInsetsMake(0, 8, 0, 8);
        _tableView.separatorInset  = UIEdgeInsetsMake(0, 8, 0, 8);

        _tableView.rowHeight          = UITableViewAutomaticDimension;
        _tableView.separatorColor     = HEXColor(0xF3F3F3);
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight           = 0.0f;
        
        _tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
        
        if (@available(iOS 11.0, *)) { // ios 11 以上
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
            _tableView.estimatedSectionHeaderHeight   = 0;
            _tableView.estimatedSectionFooterHeight   = 0;
        }
    }
    return _tableView;
}

-(NSMutableArray *)dataList {
    
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
