//
//  TGShopFilterView.m
//  TGParent
//
//  Created by lwc on 2018/12/4.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import "TGShopFilterView.h"
#import "TGFilterContentView.h"

@interface TGShopFilterView()
<UIScrollViewDelegate>

/** 选择的 类型 */
@property (nonatomic,assign) NSInteger selectIndex;

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *managedView;
@property (weak, nonatomic) IBOutlet UIView *managedLine;
@property (strong, nonatomic) UIView *managedContentView;
@property (strong, nonatomic) TGFilterContentView *managedFilter;
@property (strong, nonatomic) TGFilterContentView *mealFilter;

@property (weak, nonatomic) IBOutlet UIView *coachView;
@property (weak, nonatomic) IBOutlet UIView *coachLine;
@property (strong, nonatomic) TGFilterContentView *coachFilter;


@property (weak, nonatomic) IBOutlet UIView *interestView;
@property (weak, nonatomic) IBOutlet UIView *interestLine;
@property (strong, nonatomic) TGFilterContentView *interestFilter;

@property (weak, nonatomic) IBOutlet UIView *onceView;
@property (weak, nonatomic) IBOutlet UIView *onceLice;
@property (strong, nonatomic) TGFilterContentView *onceFilter;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,strong) UIScrollView *contentScroll;

@property (strong, nonatomic) NSMutableArray *managedDataArray;
@property (strong, nonatomic) NSMutableArray *mealFeeDataArray;
@property (strong, nonatomic) NSMutableArray *coachDataArray;
@property (strong, nonatomic) NSMutableArray *interestDataArray;
@property (strong, nonatomic) NSMutableArray *onceDataArray;

@property (strong, nonatomic) TGProductOptionModel *managedOptionModel;
@property (strong, nonatomic) TGProductOptionModel *mealFeeOptionModel;
@property (strong, nonatomic) TGProductOptionModel *coachOptionModel;
@property (strong, nonatomic) TGProductOptionModel *interestOptionModel;
@property (strong, nonatomic) TGProductOptionModel *onceCaochOptionModel;
@property (strong, nonatomic) TGProductOptionModel *onceInterestOptionModel;

@end

#define HorizontalInterval  15.0f
#define VerticalInterval    10.0f
#define PreLineCount        4

@implementation TGShopFilterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setUpSubView];
    [self setAddConstraints];
}

-(void)setUpSubView {
    
    [self.contentView addSubview:self.contentScroll];
    
    [self.contentScroll addSubview:self.managedContentView];
    [self.managedContentView addSubview:self.managedFilter];
    [self.managedContentView addSubview:self.mealFilter];
    
    [self.contentScroll addSubview:self.coachFilter];
    [self.contentScroll addSubview:self.interestFilter];
    [self.contentScroll addSubview:self.onceFilter];
    
    self.managedView.tag = 91;
    self.managedLine.tag = 101;
    [self.managedView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMeauAction:)]];
    
    self.coachView.tag = 92;
    self.coachLine.tag = 102;
    [self.coachView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMeauAction:)]];
    
    self.interestView.tag = 93;
    self.interestLine.tag = 103;
    [self.interestView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMeauAction:)]];
    
    self.onceView.tag = 94;
    self.onceLice.tag = 104;
    [self.onceView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMeauAction:)]];
    
    [self setFilterAttribute];
    
    WeakSelf();
    [self.managedFilter setSelectBlock:^(NSInteger titleIndex, NSInteger index, BOOL isChoose, TGProductOptionModel * _Nonnull productOptionModel) {
        
        weakself.managedOptionModel = productOptionModel;
        [weakself setFilterSelectFalse:3];
        [weakself setFilterSelectFalse:4];
        [weakself setFilterSelectFalse:5];
    }];
    [self.mealFilter setSelectBlock:^(NSInteger titleIndex, NSInteger index, BOOL isChoose, TGProductOptionModel * _Nonnull productOptionModel) {
        
        weakself.mealFeeOptionModel = productOptionModel;
        [weakself setFilterSelectFalse:3];
        [weakself setFilterSelectFalse:4];
        [weakself setFilterSelectFalse:5];
    }];
    [self.coachFilter setSelectBlock:^(NSInteger titleIndex, NSInteger index, BOOL isChoose, TGProductOptionModel * _Nonnull productOptionModel) {
        
        weakself.coachOptionModel = productOptionModel;
        [weakself setFilterSelectFalse:1];
        [weakself setFilterSelectFalse:2];
        [weakself setFilterSelectFalse:4];
        [weakself setFilterSelectFalse:5];
    }];
    [self.interestFilter setSelectBlock:^(NSInteger titleIndex, NSInteger index, BOOL isChoose, TGProductOptionModel * _Nonnull productOptionModel) {
        weakself.interestOptionModel = productOptionModel;
        [weakself setFilterSelectFalse:1];
        [weakself setFilterSelectFalse:2];
        [weakself setFilterSelectFalse:3];
        [weakself setFilterSelectFalse:5];
    }];
    
    [self.onceFilter setSelectBlock:^(NSInteger titleIndex, NSInteger index, BOOL isChoose, TGProductOptionModel * _Nonnull productOptionModel) {
        if (titleIndex == 0) {
            weakself.onceInterestOptionModel = productOptionModel;
            [[weakself.onceDataArray lastObject] enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.choose = NO;
            }];
        } else {
            weakself.onceCaochOptionModel    = productOptionModel;
            [[weakself.onceDataArray firstObject] enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                model.choose = NO;
            }];
        }
        [weakself setFilterSelectFalse:1];
        [weakself setFilterSelectFalse:2];
        [weakself setFilterSelectFalse:3];
        [weakself setFilterSelectFalse:4];
    }];
    
    self.selectIndex = 0;
    [RACObserve(self, selectIndex) subscribeNext:^(id x) {
        
        NSInteger lineTag = [x integerValue] + 101;
        for (NSInteger i = 101; i <= 104; i++) {
            UIView *line = [self viewWithTag:i];
            line.hidden = lineTag != i;
            if (lineTag == i) {
                [weakself.contentScroll scrollRectToVisible:CGRectMake(kScreenWidth * [x integerValue], 0, kScreenWidth, HEIGHT(self.contentView)) animated:YES];
            }
        }
    }];
}

-(void)setFilterSelectFalse:(NSInteger)index
{
    switch (index) {
        case 1: {
            self.managedOptionModel = nil;
            [self.managedDataArray removeAllObjects];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"TGShopCareType" ofType:@"plist"];
            NSMutableArray *managedData = [TGProductOptionModel mj_objectArrayWithFile:path];
            [self.managedDataArray addObjectsFromArray:@[managedData]];
            self.managedFilter.dataArray  = self.managedDataArray;
        }   break;
        case 2: {
            self.mealFeeOptionModel = nil;
            [self.mealFeeDataArray removeAllObjects];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"TGShopMeals" ofType:@"plist"];
            NSMutableArray *managedData = [TGProductOptionModel mj_objectArrayWithFile:path];
            [self.mealFeeDataArray addObjectsFromArray:@[managedData]];
            
            self.mealFilter.dataArray     = self.mealFeeDataArray;
        }   break;
        case 3: {
            self.coachOptionModel = nil;
            [self.coachDataArray removeAllObjects];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"TGShopCoach" ofType:@"plist"];
            NSMutableArray *managedData = [TGProductOptionModel mj_objectArrayWithFile:path];
            [self.coachDataArray addObjectsFromArray:@[managedData]];
            self.coachFilter.dataArray    = self.coachDataArray;
        }   break;
        case 4: {
            self.interestOptionModel = nil;
            [self.interestDataArray removeAllObjects];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"TGShopInterest" ofType:@"plist"];
            NSMutableArray *managedData = [TGProductOptionModel mj_objectArrayWithFile:path];
            [self.interestDataArray addObjectsFromArray:@[managedData]];
            self.interestFilter.dataArray = self.interestDataArray;
        }   break;
        case 5: {
            self.onceCaochOptionModel = nil;
            self.onceInterestOptionModel = nil;
            [self.onceDataArray removeAllObjects];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"TGShopInterest" ofType:@"plist"];
            NSMutableArray *managedData = [TGProductOptionModel mj_objectArrayWithFile:path];
            
            NSString *path1 = [[NSBundle mainBundle] pathForResource:@"TGShopCoach" ofType:@"plist"];
            NSMutableArray *managedData1 = [TGProductOptionModel mj_objectArrayWithFile:path1];
            
            _onceDataArray = [NSMutableArray arrayWithArray:@[managedData, managedData1]];
            self.onceFilter.dataArray = self.onceDataArray;
        }   break;
        default:
            break;
    }
}

-(void)setFilterAttribute {
    
    _managedFilter.horizontalInterval = HorizontalInterval;
    _managedFilter.verticalInterval   = VerticalInterval;
    _managedFilter.preLineCount       = PreLineCount;
    _managedFilter.preColumnCount     = 2;
    _managedFilter.isMoreChoose       = NO;
    [_managedFilter setTitle:@[@"托管类型"] dataArray:self.managedDataArray];
    
    _mealFilter.horizontalInterval = HorizontalInterval;
    _mealFilter.verticalInterval   = VerticalInterval;
    _mealFilter.preLineCount       = PreLineCount;
    _mealFilter.preColumnCount     = 1;
    _mealFilter.isMoreChoose       = NO;
    [_mealFilter setTitle:@[@"餐食"] dataArray:self.mealFeeDataArray];

    _coachFilter.horizontalInterval = HorizontalInterval;
    _coachFilter.verticalInterval   = VerticalInterval;
    _coachFilter.preLineCount       = PreLineCount;
    _coachFilter.preColumnCount     = 3;
    _coachFilter.isMoreChoose       = NO;
    [_coachFilter setTitle:@[@"课程内容"] dataArray:self.coachDataArray];

    _interestFilter.horizontalInterval = HorizontalInterval;
    _interestFilter.verticalInterval   = VerticalInterval;
    _interestFilter.preLineCount       = PreLineCount;
    _interestFilter.preColumnCount     = 3;
    _interestFilter.isMoreChoose       = NO;
    [_interestFilter setTitle:@[@"兴趣班"] dataArray:self.interestDataArray];

    _onceFilter.horizontalInterval = HorizontalInterval;
    _onceFilter.verticalInterval   = VerticalInterval;
    _onceFilter.preLineCount       = PreLineCount;
    _onceFilter.preColumnCount     = 3;
    _onceFilter.isMoreChoose       = NO;
    [_onceFilter setTitle:@[@"兴趣班", @"辅导班"] dataArray:self.onceDataArray];
}

-(void)setAddConstraints {
    
    CGFloat width  = kScreenWidth;
    CGFloat height = HEIGHT(self.contentView);
    
    [self.contentScroll setContentSize:CGSizeMake(width * 4, height)];
    
    self.managedContentView.frame = CGRectMake(0, 0, width, height);
    self.managedFilter.frame = CGRectMake(0, 0, width, 120);
    self.mealFilter.frame = CGRectMake(0, MaxY(self.managedFilter), width, 90);
    
    self.coachFilter.frame = CGRectMake(width, 0, width, height);
    
    self.interestFilter.frame = CGRectMake(width * 2, 0, width, height);
    
    self.onceFilter.frame = CGRectMake(width * 3, 0, width, height);
}

#pragma mark - Public
- (void)setSelectedManagedModel:(TGProductOptionModel *)managedModel
                     mealsModel:(TGProductOptionModel *)mealsModel
                     coachModel:(TGProductOptionModel *)coachModel
                  interestModel:(TGProductOptionModel *)interestModel
                 onceCoachModel:(TGProductOptionModel *)onceCoachModel
              onceInterestModel:(TGProductOptionModel *)onceInterestModel
{
    [self.managedDataArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
        [list enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.code isEqualToString:managedModel.code]) {
                model.choose = YES;
            } else if(model.isChoose){
                model.choose = NO;
            }
        }];
    }];
    
    self.managedOptionModel = managedModel;
    
    [self.mealFeeDataArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
        [list enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.code isEqualToString:mealsModel.code]) {
                model.choose = YES;
            } else if(model.isChoose){
                model.choose = NO;
            }
        }];
    }];
    self.mealFeeOptionModel = mealsModel;
    
    [self.coachDataArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
        [list enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.code isEqualToString:coachModel.code]) {
                model.choose = YES;
            } else if(model.isChoose){
                model.choose = NO;
            }
        }];
    }];
    self.coachOptionModel = coachModel;
    
    [self.interestDataArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
        [list enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.code isEqualToString:interestModel.code]) {
                model.choose = YES;
            } else if(model.isChoose){
                model.choose = NO;
            }
        }];
    }];
    self.interestOptionModel = interestModel;
    
    [self.onceDataArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
        [list enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.code isEqualToString:onceCoachModel.code] || [model.code isEqualToString:onceInterestModel.code]) {
                model.choose = YES;
            } else if(model.isChoose){
                model.choose = NO;
            }
        }];
    }];
    self.onceCaochOptionModel = onceCoachModel;
    self.onceInterestOptionModel = onceInterestModel;
}

-(void)tapMeauAction:(UITapGestureRecognizer *)tap {
    self.selectIndex = tap.view.tag - 91;
}

- (void) show {
    
    self.managedFilter.dataArray  = self.managedDataArray;
    self.mealFilter.dataArray     = self.mealFeeDataArray;
    self.coachFilter.dataArray    = self.coachDataArray;
    self.interestFilter.dataArray = self.interestDataArray;
    self.onceFilter.dataArray     = self.onceDataArray;

    [UIView animateWithDuration:0.25 animations:^{
        self.alpha < 1 ? self.alpha += 0.05 : 1;
    } completion:^(BOOL finished) {
        self.alpha = 1;
        self.hidden = NO;
    }];
}

- (void)hiddenFilter {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha > 0 ? self.alpha -= 0.05 : 0;
    } completion:^(BOOL finished) {
        self.alpha = 1;
        self.hidden = YES;
        _cancelBlock ? _cancelBlock() : nil;
    }];
}

- (void)setResetBlock:(TGClickBlock)resetBlock
          cancelBlock:(TGClickBlock)cancelBlock
         confirmBlock:(TGClickConfirmBlock)confirmBlock {
    _resetBlock = resetBlock;
    _cancelBlock = cancelBlock;
    _confirmBlock = confirmBlock;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //获取到当前点击的View
    UIView *view = [touch view];
    if ([view isDescendantOfView:self.titleView]) return;
    [self hiddenFilter];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.selectIndex = scrollView.contentOffset.x / WIDTH(self.contentView);
    NSLog(@"%lf, %zd", scrollView.contentOffset.x, self.selectIndex);
}

#pragma mark - EventResponse

/** 点击重置 */
- (IBAction)clickReset:(id)sender {
    
    [_managedDataArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
        [list enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.choose = NO;
        }];
    }];
    [_mealFeeDataArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
        [list enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.choose = NO;
        }];
    }];
    [_coachDataArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
        [list enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.choose = NO;
        }];
    }];
    [_interestDataArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
        [list enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.choose = NO;
        }];
    }];
    [_onceDataArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull list, NSUInteger idx, BOOL * _Nonnull stop) {
        [list enumerateObjectsUsingBlock:^(TGProductOptionModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.choose = NO;
        }];
    }];
    
    _managedFilter.dataArray  = _managedDataArray;
    _mealFilter.dataArray     = _mealFeeDataArray;
    _coachFilter.dataArray    = _mealFeeDataArray;
    _interestFilter.dataArray = _mealFeeDataArray;
    _onceFilter.dataArray     = _onceDataArray;

    self.managedOptionModel  = nil;
    self.mealFeeOptionModel  = nil;
    self.coachOptionModel    = nil;
    self.interestOptionModel = nil;
    self.onceCaochOptionModel = nil;
    self.onceInterestOptionModel = nil;

    [self hiddenFilter];
    _resetBlock ? _resetBlock() : nil;
}

/** 点击确定 */
- (IBAction)clickConfirm:(id)sender {
    
    [self hiddenFilter];
    _confirmBlock ? _confirmBlock(self.managedOptionModel, self.mealFeeOptionModel, self.coachOptionModel, self. interestOptionModel, self.onceCaochOptionModel, self.onceInterestOptionModel) : nil;
}

#pragma mark - getters
-(UIScrollView *)contentScroll {
    
    if (_contentScroll == nil) {
        _contentScroll = [[UIScrollView alloc] init];
        _contentScroll.bounces = NO;
        _contentScroll.delegate = self;
        _contentScroll.pagingEnabled = YES;
        _contentScroll.showsVerticalScrollIndicator = NO;
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.frame = CGRectMake(0, 0, kScreenWidth, HEIGHT(self.contentView));
        _contentScroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _contentScroll;
}

-(UIView *)managedContentView {
    
    if (_managedContentView == nil) {
        _managedContentView = [[UIView alloc] init];
    }
    return _managedContentView;
}

-(TGFilterContentView *)managedFilter {
    
    if (_managedFilter == nil) {
        _managedFilter = [[TGFilterContentView alloc] init];
    }
    return _managedFilter;
}

-(TGFilterContentView *)mealFilter {
    
    if (_mealFilter == nil) {
        _mealFilter = [[TGFilterContentView alloc] init];
    }
    return _mealFilter;
}


-(TGFilterContentView *)coachFilter {
    
    if (_coachFilter == nil) {
        _coachFilter = [[TGFilterContentView alloc] init];
    }
    return _coachFilter;
}

-(TGFilterContentView *)interestFilter {
    
    if (_interestFilter == nil) {
        _interestFilter = [[TGFilterContentView alloc] init];
    }
    return _interestFilter;
}

-(TGFilterContentView *)onceFilter {
    
    if (_onceFilter == nil) {
        _onceFilter = [[TGFilterContentView alloc] init];
    }
    return _onceFilter;
}

- (TGProductOptionModel *)managedOptionModel {
    if (!_managedOptionModel) {
        _managedOptionModel = [[TGProductOptionModel alloc] init];
    }
    return _managedOptionModel;
}

- (TGProductOptionModel *)mealFeeOptionModel {
    if (!_mealFeeOptionModel) {
        _mealFeeOptionModel = [[TGProductOptionModel alloc] init];
    }
    return _mealFeeOptionModel;
}

- (TGProductOptionModel *)coachOptionModel {
    if (!_coachOptionModel) {
        _coachOptionModel = [[TGProductOptionModel alloc] init];
    }
    return _coachOptionModel;
}

- (TGProductOptionModel *)interestOptionModel {
    if (!_interestOptionModel) {
        _interestOptionModel = [[TGProductOptionModel alloc] init];
    }
    return _interestOptionModel;
}

- (TGProductOptionModel *)onceCaochOptionModel {
    if (!_onceCaochOptionModel) {
        _onceCaochOptionModel = [[TGProductOptionModel alloc] init];
    }
    return _onceCaochOptionModel;
}

- (TGProductOptionModel *)onceInterestOptionModel {
    if (!_onceInterestOptionModel) {
        _onceInterestOptionModel = [[TGProductOptionModel alloc] init];
    }
    return _onceInterestOptionModel;
}

- (NSMutableArray *)managedDataArray {
    if (!_managedDataArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TGShopCareType" ofType:@"plist"];
        NSMutableArray *managedData = [TGProductOptionModel mj_objectArrayWithFile:path];
        _managedDataArray = [NSMutableArray arrayWithArray:@[managedData]];
    }
    return _managedDataArray;
}

- (NSMutableArray *)mealFeeDataArray {
    if (!_mealFeeDataArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TGShopMeals" ofType:@"plist"];
        NSMutableArray *managedData = [TGProductOptionModel mj_objectArrayWithFile:path];
        _mealFeeDataArray = [NSMutableArray arrayWithArray:@[managedData]];
    }
    return _mealFeeDataArray;
}

- (NSMutableArray *)coachDataArray {
    if (!_coachDataArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TGShopCoach" ofType:@"plist"];
        NSMutableArray *managedData = [TGProductOptionModel mj_objectArrayWithFile:path];
        _coachDataArray = [NSMutableArray arrayWithArray:@[managedData]];
    }
    return _coachDataArray;
}

- (NSMutableArray *)interestDataArray {
    if (!_interestDataArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TGShopInterest" ofType:@"plist"];
        NSMutableArray *managedData = [TGProductOptionModel mj_objectArrayWithFile:path];
        _interestDataArray = [NSMutableArray arrayWithArray:@[managedData]];
    }
    return _interestDataArray;
}


- (NSMutableArray *)onceDataArray {
    if (!_onceDataArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TGShopInterest" ofType:@"plist"];
        NSMutableArray *managedData = [TGProductOptionModel mj_objectArrayWithFile:path];
        
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"TGShopCoach" ofType:@"plist"];
        NSMutableArray *managedData1 = [TGProductOptionModel mj_objectArrayWithFile:path1];
        
        _onceDataArray = [NSMutableArray arrayWithArray:@[managedData, managedData1]];
    }
    return _onceDataArray;
}

@end
