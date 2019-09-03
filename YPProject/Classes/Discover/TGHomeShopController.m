//
//  TGHomeShopController.m
//  ScrollView嵌套悬停Demo
//
//  Created by Jtg_yao on 2019/8/22.
//  Copyright © 2019 谭高丰. All rights reserved.
//

#import "TGHomeShopController.h"

#import "TGHomeShopNewCell.h"
#import "MenuHeadView.h"
#import "TGShopFilterView.h"
#import "TGHomeTopView.h"

#define CELL_Identifer @"TGHomeShopNewCell"
static CGFloat MenuHeaderView_Height = 44;

@interface TGHomeShopController ()
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *dataList;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;

/** tableView 菜单 Section */
@property (nonatomic,strong) MenuHeadView  *menuHeadView;


/** 筛选弹框 */
@property (strong, nonatomic) TGShopFilterView *shopFilterView;
/** 排序类型 */
@property (copy, nonatomic) NSString *sortType;
/** 选中托管类型 */
@property (strong, nonatomic) TGProductOptionModel *selectedManagedModel;
/** 选中餐费模型 */
@property (strong, nonatomic) TGProductOptionModel *selectedMealsModel;
/** 选中辅导内容 */
@property (strong, nonatomic) TGProductOptionModel *selectedCoachModel;
/** 选中兴趣班 */
@property (strong, nonatomic) TGProductOptionModel *selectedInterestModel;
/** 选中 1 对 1 辅导班 */
@property (strong, nonatomic) TGProductOptionModel *selectedOnceCoachModel;
/** 选中 1 对 1 兴趣班 */
@property (strong, nonatomic) TGProductOptionModel *selectedOnceInterestModel;

@property (nonatomic,strong) MJRefreshHeader *mj_header;

@end

@implementation TGHomeShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
//    [self reloadDataSource];
}

-(void)setUpSubviews {
    
    _page = 1;
    _pageSize = 20;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.shopFilterView];
    
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
    cell.model = [self.dataList objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return MenuHeaderView_Height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.menuHeadView;
}

#pragma mark -- 同步菜单选项
/**
 同步菜单选项
 @param idx      选中的是第几个 Item
 */
-(void)synchronizationIndex:(TGMenuHeadType)idx{
    switch (idx) {
        case TGMenuHeadTypeUniversal:{      //综合排序
            _sortType = @"";
            [self reloadDataSource];
        }
            break;
        case TGMenuHeadTypeDistance:{       //距离排序
            _sortType = @"DISTANCE";
            [self reloadDataSource];
        }
            break;
        case TGMenuHeadTypeEvaluation:{     //好评优先
            _sortType = @"SCORE";
            [self reloadDataSource];
        }
            break;
        case TGMenuHeadTypeFilter:{         //筛选
            if (self.shopFilterView.hidden) {
                [self menuTap];
            } else {
                [self.shopFilterView hiddenFilter];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 点击事件
/** 点击菜单 */
- (void)menuTap {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHomeScrollTop_Notice object:nil];
    
    [self.shopFilterView setSelectedManagedModel:self.selectedManagedModel
                                      mealsModel:self.selectedMealsModel
                                      coachModel:self.selectedCoachModel
                                   interestModel:self.selectedInterestModel
                                  onceCoachModel:self.selectedOnceCoachModel
                               onceInterestModel:self.selectedOnceInterestModel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.shopFilterView show];
    });
}

- (void)updateMenuViewStatus {
    if (self.selectedManagedModel.choose || self.selectedMealsModel.choose) {
        self.menuHeadView.filterItem.select = YES;
    } else {
        self.menuHeadView.filterItem.select = NO;
    }
}

-(void)hiddenPagePopView {
    
    !self.shopFilterView.isHidden ? [self.shopFilterView hiddenFilter] : nil;
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    NSString *url = @"/search/shop/home-location-index/";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(_page) forKey:@"page"];
    [params setValue:@(_pageSize) forKey:@"pageSize"];
    
    [params setValue:@(23.135309) forKey:@"lat"];
    [params setValue:@(113.269043) forKey:@"lon"];
    [params setValue:_sortType forKey:@"sortType"];
    
    [YPProgressHUD yp_showDIYLoading];
    [YPHttpTool GET:url params:params complete:^(id  _Nonnull data) {
        
        NSArray *list = [[[data objectForKey:@"result"] objectForKey:@"pager"] objectForKey:@"list"];
        
        if ([[data objectForKey:@"code"] integerValue] == 200) {
            if (self.page == 1) {
                [self.dataList removeAllObjects];
            }
            NSMutableArray *newList = [TGShopInfoModel mj_objectArrayWithKeyValuesArray:list];
            [self.dataList addObjectsFromArray:newList];
        }
        
        if (self.page > 1) {
            if (list != nil && list.count < self.pageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            if (list != nil && list.count < self.pageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.mj_header ? [self.mj_header endRefreshing] : nil;
        }
        [YPProgressHUD yp_dismissHUD];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        if (self.page > 1) {
            self.page --;
        }
        
        self.tableView.mj_footer.state = MJRefreshStateIdle;
        self.mj_header ? [self.mj_header endRefreshing] : nil;
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

-(MenuHeadView *)menuHeadView {
    if (_menuHeadView == nil) {
        _menuHeadView = [[MenuHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, MenuHeaderView_Height)];
        
        __weak typeof(self) weakSelf = self;
        [_menuHeadView setClickBlock:^(TGMenuHeadType type, BOOL isSelect) {
            [weakSelf synchronizationIndex:type];
        }];
    }
    return _menuHeadView;
}

- (TGShopFilterView *)shopFilterView {
    if (!_shopFilterView) {
        _shopFilterView = [TGShopFilterView viewFromXib];
        _shopFilterView.frame = CGRectMake(0, MenuHeaderView_Height, kScreenWidth, kScreenHeight);
        _shopFilterView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _shopFilterView.hidden = YES;
        WeakSelf();
        [_shopFilterView setResetBlock:^{
            weakself.selectedManagedModel       = nil;
            weakself.selectedMealsModel         = nil;
            weakself.selectedCoachModel         = nil;
            weakself.selectedInterestModel      = nil;
            weakself.selectedOnceCoachModel     = nil;
            weakself.selectedOnceInterestModel  = nil;
            
            [weakself updateMenuViewStatus];
            [weakself reloadDataSource];
        } cancelBlock:^{
            [weakself updateMenuViewStatus];
        } confirmBlock:^(TGProductOptionModel * _Nonnull selectedManagedModel, TGProductOptionModel * _Nonnull selectedMealsModel, TGProductOptionModel * _Nonnull coachModel, TGProductOptionModel * _Nonnull interestModel,TGProductOptionModel *onceCoachModel, TGProductOptionModel *onceInterestModel) {
            
            weakself.selectedManagedModel       = selectedManagedModel;
            weakself.selectedMealsModel         = selectedMealsModel;
            weakself.selectedCoachModel         = coachModel;
            weakself.selectedInterestModel      = interestModel;
            weakself.selectedOnceCoachModel     = onceCoachModel;
            weakself.selectedOnceInterestModel  = onceInterestModel;
            
            [weakself updateMenuViewStatus];
            [weakself reloadDataSource];
        }];
    }
    return _shopFilterView;
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
