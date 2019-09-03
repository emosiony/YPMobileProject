//
//  TGGradeSelectView.m
//  TGVendor
//
//  Created by lwc on 2018/11/16.
//  Copyright © 2018年 jzg. All rights reserved.
//

#import "TGGradeSelectView.h"

#import "TGCourseChooseTypeCell.h"

static NSString * TGSelectViewCellID = @"TGCourseChooseTypeCell";

@interface TGGradeSelectView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) CGFloat itemW;

@end

@implementation TGGradeSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self SetUpSubView];
    }
    return self;
}

-(instancetype)init {
    if (self = [super init]) {
        [self SetUpSubView];
    }
    return self;
}

-(void)SetUpSubView {
    
    [self addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - public
- (void)setDataArray:(NSMutableArray *)dataArray{

    _dataArray = dataArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TGCourseChooseTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TGSelectViewCellID forIndexPath:indexPath];
    cell.titleLabel.font = [UIFont systemFontOfSize:13];
    cell.productOptionModel = self.dataArray[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TGProductOptionModel *model = self.dataArray[indexPath.item];
    
    if (_isMoreChoose) {
        
        if (!model.isClick) return;
        
        model.choose = !model.isChoose;
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        _didSelectItemBlock ? _didSelectItemBlock(indexPath.row, model.isChoose, model) : nil;
        
    } else {
        
        if (!model.isClick) return;
        
        model.choose = !model.isChoose;
        
        NSMutableArray *indexs = [NSMutableArray array];
        [self.dataArray enumerateObjectsUsingBlock:^(TGProductOptionModel * _Nonnull optionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != indexPath.row && optionModel.isChoose) {
                optionModel.choose = NO;
                NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:idx inSection:indexPath.section];
                [indexs addObject:oldIndexPath];
            }
        }];
        
        [indexs addObject:indexPath];
        [self.collectionView reloadItemsAtIndexPaths:indexs];
        _didSelectItemBlock ? _didSelectItemBlock(indexPath.row, model.isChoose, model) : nil;
    }
}

#pragma mark -- UICollectionView Delegte
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _itemW = (self.mj_w - (_preLineCount +1) * _horizontalInterval) / _preLineCount;
//    CGFloat height  = (self.height - (_preColumnCount + 1) * _verticalInterval) / _preColumnCount;
    CGFloat height = 26;
    return CGSizeMake(_itemW, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(_verticalInterval, _horizontalInterval, _verticalInterval, _horizontalInterval);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return _verticalInterval;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _horizontalInterval;
}

#pragma mark - getters
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:TGSelectViewCellID bundle:nil] forCellWithReuseIdentifier:TGSelectViewCellID];
    }
    return _collectionView;
}

-(NSArray *)muSelectList {
    
    __block NSMutableArray *muList = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(TGProductOptionModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.isChoose) {
            [muList addObject:model];
        }
    }];
    return muList;
}

@end
