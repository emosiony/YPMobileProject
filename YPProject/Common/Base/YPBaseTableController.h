//
//  YPBaseTableController.h
//  YPProject
//
//  Created by Jtg_yao on 2019/8/13.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "YPBaseController.h"
#import "YPTableView.h"
#import <UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EmptyTapBlock)(void);

@interface YPBaseTableController : YPBaseController
<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, TouchTableViewDelegate>

@property (nonatomic,strong) UIImage *emptyImage;
@property (nonatomic,copy) NSString *emptyDesc;

@property (nonatomic,strong) YPTableView *tableView;
@property (nonatomic,copy)   NSMutableArray *dataList;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,copy) EmptyTapBlock emptyTapBlock;

-(instancetype)initWithStyle:(UITableViewStyle)style;

-(void)setUpRefreshing;
-(void)setRefreshing;
-(void)endRefreshing;
-(void)endNoMoreRefreshing;

-(void)loadDataEnd;

-(void)setEmptyDelegate;

@end

NS_ASSUME_NONNULL_END
