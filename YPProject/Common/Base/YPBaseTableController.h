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

/** 空白占位图 */
@property (nonatomic,strong) UIImage *emptyImage;
/** 空白 标题 */
@property (nonatomic,copy)   NSString *emptyTitle;
/** 空白 描述 */
@property (nonatomic,copy)   NSString *emptyDesc;

@property (nonatomic,strong) YPTableView *tableView;
@property (nonatomic,copy)   NSMutableArray *dataList;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;

/** 点击空白 */
@property (nonatomic,copy) EmptyTapBlock emptyTapBlock;

-(instancetype)initWithStyle:(UITableViewStyle)style;

/** 设置刷新 -- 下拉 */
-(void)setUpRefreshing;
/** 设置刷新 -- 上下拉 */
-(void)setRefreshing;
/** 刷新结束 -- 停止动画 */
-(void)endRefreshing;
/** 刷新结束 -- 没有更多数据 */
-(void)endNoMoreRefreshing;

/** 刷新调用方法 */
-(void)loadDataSource;

/** 设置 空白页 代理 */
-(void)setEmptyDelegate;

@end

NS_ASSUME_NONNULL_END
