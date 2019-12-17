//
//  TGShopDetailDiscount.m
//  YPProject
//
//  Created by Jtg_yao on 2019/12/9.
//  Copyright © 2019 jzg. All rights reserved.
//

#import "TGShopDetailDiscount.h"
#import "TGSHOPDetailDiscountCell.h"

#define Cell_Identifierv @"TGSHOPDetailDiscountCell"


@interface TGShopDetailDiscount ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,assign) ShopDDisShowType showType;

@end

@implementation TGShopDetailDiscount

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    
    [self addSubview:self.tableView];   
    
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
    self.sources = @[@"", @"", @""];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat height = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue].height + self.tableView.tableFooterView.mj_h;
        NSLog(@"height == %.2f", height);
        
        if (_sources.count <= 0) {
            height = 0;
        } 
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
}

- (void)setSources:(NSArray *)sources {
    
    _sources = sources;
    
    if (_sources.count > 1) {
        self.showType = ShopDDisShowTypeClose;
    } else if (_sources.count == 1) {
        self.showType = ShopDDisShowTypeOnece;
    }
    
    if (_sources.count) {
        self.tableView.tableFooterView = self.footerView;
    } else {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    }
    
    [self.tableView reloadData];
}

#pragma mark -- TableView Init
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.showType == ShopDDisShowTypeOnece) {
        return 1;
    } else if (self.showType == ShopDDisShowTypeClose) {
        return 1;
    }
    return self.sources.count;
}

#pragma mark -- TableView Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TGSHOPDetailDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_Identifierv forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *tip = @"";
    for (NSInteger i = 0; i <= indexPath.row; i++) {
        tip = [tip stringByAppendingString:@"满100元减50元，满100元减50元，满100元减50元。"];
    }
    
    ShopDDisShowType show = ShopDDisShowTypeOnece;
    if (self.showType == ShopDDisShowTypeClose) {
        show = ShopDDisShowTypeClose;
    } else if (self.showType == ShopDDisShowTypeOpen) {
        if (indexPath.row == self.sources.count - 1) {
            show = ShopDDisShowTypeOpen;
        } else {
            show = ShopDDisShowTypeOnece;
        }
    }
    
    [cell setTitle:@"新生专享" content:tip showType:show];
    
    WeakSelf();
    [cell setTapOpenClick:^(ShopDDisShowType showType) {
        [weakself tableView:tableView didSelectRowAtIndexPath:indexPath];
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //点击cell 操作
    if (self.showType == ShopDDisShowTypeClose && indexPath.row == 0) {
        self.showType = ShopDDisShowTypeOpen;
        [self.tableView reloadData];
    } else if (self.showType == ShopDDisShowTypeOpen && indexPath.row == self.sources.count - 1) {
        self.showType = ShopDDisShowTypeClose;
        [self.tableView reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

//约束 这边table再自定义view中
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

//移除监听
-(void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark -- Getter
-(UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight          = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.separatorColor     = HEXColor(0xFFFFFF);
        _tableView.scrollEnabled      = NO;
        [_tableView registerNib:[UINib nibWithNibName:Cell_Identifierv bundle:nil] forCellReuseIdentifier:Cell_Identifierv];
    }
    return _tableView;
}

- (UIView *)footerView {
    
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mj_w, 25)];
        
        [_footerView addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-5);
        }];
        
        _footerView.mj_h = self.tipLabel.mj_h + 10;
    }
    return _footerView;
}

- (UILabel *)tipLabel {
    
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"下单时自动计算出最大补贴进行结算，享此补贴时将不会获赠今币";
        _tipLabel.textColor = HEXColor(0x999999);
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:10];
        [_tipLabel sizeToFit];
    }
    return _tipLabel;
}

@end
