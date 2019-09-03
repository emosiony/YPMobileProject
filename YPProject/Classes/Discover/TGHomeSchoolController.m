

//
//  TGHomeSchoolController.m
//  ScrollView嵌套悬停Demo
//
//  Created by Jtg_yao on 2019/8/22.
//  Copyright © 2019 谭高丰. All rights reserved.
//

#import "TGHomeSchoolController.h"
#import "TGHomeShopNewCell.h"

#import <UIScrollView+EmptyDataSet.h>

#define CELL_Identifer @"TGHomeShopNewCell"
//static CGFloat MenuHeaderView_Height = 44;

@interface TGHomeSchoolController ()
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *dataList;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,strong) MJRefreshHeader *mj_header;

@end

@implementation TGHomeSchoolController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
//    [self reloadDataSource];
}

-(void)setUpSubviews {
    
    _page = 1;
    _pageSize = 20;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view);
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //商铺展示
    TGHomeShopNewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_Identifer forIndexPath:indexPath];
    cell.school = [self.dataList objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark -- Empty Block
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.dataList.count <= 0;
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"emptyNothing"];
}

-(CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 30.0f;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - (self.tableView.tableHeaderView.bounds.size.height/2 + kStatusAndNavBarH /2);
}


-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"网络走丢了";
//    ([YPReachability shareInstall].hasNet == NO) ? @"网络走丢了" : self.emptyTitle;
    UIFont *font = [UIFont systemFontOfSize:14.0];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:HEXColor(0x666666) range:NSMakeRange(0, text.length)];
    return attStr;
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"请检查您的网络";
//    ([YPReachability shareInstall].hasNet == NO) ? @"请检查您的网络" : self.emptyDesc;
    UIFont *font = [UIFont systemFontOfSize:12.0];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:HEXColor(0x999999) range:NSMakeRange(0, text.length)];
    return attStr;
}


#pragma mark -- Request
-(void)reloadDataSource {
    
    self.mj_header = nil;
    _page = 1;
    [self loadBaseDataSource];
}


-(void)loadDataAfterLocation:(TGHomeLocationState)locationState withMjHeader:(nonnull MJRefreshHeader *)mj_header{
    
    self.locationState = locationState;
    self.mj_header     = mj_header;
    
    if (self.locationState == TGHomeLocationStateSuccess) {
        [self loadBaseDataSource];
    } else {
        _page = 1;
        self.mj_header ? [self.mj_header endRefreshing] : nil;
        [self.tableView  reloadData];
    }
}

-(void)loadBaseDataSource {
    
    
    NSString *url = @"/school/school-search/index/?page=%@&pageSize=%@";
    url = [NSString stringWithFormat:url, @(_page), @(_pageSize)];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@(23.135309) forKey:@"lat"];
    [params setValue:@(113.269043) forKey:@"lon"];
    
    [YPProgressHUD yp_showDIYLoading];
    [YPHttpTool POSTJson:url params:params complete:^(id  _Nonnull data) {
        
        NSArray *list = [[data objectForKey:@"result"] objectForKey:@"list"];
        if (self.page > 1) {
            if (list != nil && list.count < self.pageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            [self.dataList removeAllObjects];
            if (list != nil && list.count < self.pageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.mj_header ? [self.mj_header endRefreshing] : nil;
            self.tableView.mj_footer.state = MJRefreshStateIdle;
        }
        
        
        if ([[data objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *newList = [TGSchoolInfoModel mj_objectArrayWithKeyValuesArray:list];
            [self.dataList addObjectsFromArray:newList];
        }else {
            if (self.page > 1) {
                self.page --;
            }
        }
        [YPProgressHUD yp_dismissHUD];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView reloadData];
        [YPProgressHUD yp_showErrorHUDWithTitle:error.localizedDescription];
    }];
}

#pragma mark -- Getter
-(NSMutableArray *)dataList {
    
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

#pragma mark -- Getter
-(UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.backgroundColor = HEXColor(0xFFFFFF);
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
        
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
        _tableView.layoutMargins   = UIEdgeInsetsMake(0, 8, 0, 8);
        _tableView.separatorInset  = UIEdgeInsetsMake(0, 8, 0, 8);
        
        _tableView.rowHeight          = UITableViewAutomaticDimension;
        _tableView.separatorColor     = HEXColor(0xF3F3F3);
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight           = 40.0f;
        
        _tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
        
        _tableView.emptyDataSetSource   = self;
        _tableView.emptyDataSetDelegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:CELL_Identifer bundle:nil] forCellReuseIdentifier:CELL_Identifer];
        
        if (@available(iOS 11.0, *)) { // ios 11 以上
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
            _tableView.estimatedSectionHeaderHeight   = 0;
            _tableView.estimatedSectionFooterHeight   = 0;
        }
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page ++;
            [weakSelf loadBaseDataSource];
        }];
        _tableView.mj_footer.automaticallyChangeAlpha = YES;
    }
    return _tableView;
}

@end
