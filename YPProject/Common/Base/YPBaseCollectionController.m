//
//  YPBaseCollectionController.m
//  YPProject
//
//  Created by Jtg_yao on 2019/8/14.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPBaseCollectionController.h"

@interface YPBaseCollectionController ()

@end

@implementation YPBaseCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSubViewInit];
}

- (void)baseSubViewInit {
    
    _page     = 1;
    _pageSize = 15;
    self.emptyTitle = @"暂无数据";
    self.emptyDesc  = @"";
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)setRefreshing {
    
    [self setUpRefreshing];
    
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page += 1;
        [weakSelf loadDataSource];
    }];
    self.collectionView.mj_footer.automaticallyChangeAlpha = YES;
}

-(void)setUpRefreshing {
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page = 1;
        [weakSelf loadDataSource];
    }];
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
}

-(void)loadDataSource {
    
    [self endRefreshing];
    [self.collectionView reloadData];
}

-(void)endRefreshing {
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)endNoMoreRefreshing {
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
}

-(void)setEmptyDelegate {
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
}

#pragma mark - UICollectionView Datasource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataList.count;
}

#pragma mark -- UICollectionView Delegte
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kScreenWidth, 44.0f);
}

//创建cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"view" forIndexPath:indexPath];
    if (view == nil) {
        view = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    }
    
    return view;
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
    return - (kStatusAndNavBarH/2);
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
-(NSMutableArray *)dataList {
    
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

#pragma mark -- flow
-(UICollectionViewFlowLayout *)flowLayout {
    
    if (_flowLayout == nil) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        //item行间距
        _flowLayout.minimumLineSpacing = 10;//默认10
        _flowLayout.minimumInteritemSpacing = 10;//默认10
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//默认竖直滚动
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);//边距屏幕宽
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator   = NO;
        _collectionView.keyboardDismissMode            = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

@end
