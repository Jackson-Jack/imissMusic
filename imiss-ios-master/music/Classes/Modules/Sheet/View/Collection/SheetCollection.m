//
//  SheetCollection.m
//  music
//
//  Created by zhongke on 2018/9/27.
//  Copyright © 2018年 kk. All rights reserved.
//

#import "SheetCollection.h"
#import "SheetCollectionCell.h"
#import "SheetCollectionLayout.h"

#define CELLW 80
#define INSERT countcoordinatesX(10)

#pragma mark - 声明
@interface SheetCollection()<UICollectionViewDelegate, UICollectionViewDataSource, SheetCollectionLayoutDelegate> {
    SheetCollectionCell *_selectCell;
}

@end

#pragma mark - 实现
@implementation SheetCollection

+ (instancetype)initWithFrame:(CGRect)frame {
    SheetCollectionLayout *flow = ({
        SheetCollectionLayout *flow = [[SheetCollectionLayout alloc] init];
        flow.itemSize = CGSizeMake(80, 80);
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow;
    });
    
    SheetCollection *collection = [[SheetCollection alloc] initWithFrame:frame collectionViewLayout:flow];
    [flow setDelegate:collection];
    [flow setCollection:collection];
    [collection setShowsHorizontalScrollIndicator:NO];
    [collection setBackgroundColor:[UIColor clearColor]];
    [collection setDelegate:collection];
    [collection setDataSource:collection];
    [collection registerNib:[UINib nibWithNibName:@"SheetCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"SheetCollectionCell"];
    [collection setContentOffset:CGPointMake(0, 0)];
    return collection;
}

#pragma mark - set
- (void)setModels:(NSMutableArray<SheetModel *> *)models {
    _models = models;
    [self reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SheetCollectionCell *cell = [SheetCollectionCell loadItem:collectionView index:indexPath];
    [cell setIndexPath:indexPath];
    [cell setModel:self.models[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
// 点击了某个Cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectCell.indexPath.row == indexPath.row) {
        return;
    }
    
    // 滚动
    CGFloat offsetX = indexPath.row * (INSERT + CELLW);
    [collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    
    // 回调
    if (self.sheetDelegate && [self.sheetDelegate respondsToSelector:@selector(sheetCollection:didSelectOrSwipeItemAtIndex:click:)]) {
        [self.sheetDelegate sheetCollection:self didSelectOrSwipeItemAtIndex:indexPath.row click:YES];
    }
    // 赋值
    _selectCell = (SheetCollectionCell *)[self cellForItemAtIndexPath:indexPath];
}

#pragma mark - SheetCollectionLayoutDelegate
// 滑动到某个Cell
- (void)collectionLayout:(SheetCollectionLayout *)layout didSelectItemWithIndex:(NSInteger)index {
    if (_selectCell.indexPath.row == index) {
        return;
    }
    // 回调
    if (self.sheetDelegate && [self.sheetDelegate respondsToSelector:@selector(sheetCollection:didSelectOrSwipeItemAtIndex:click:)]) {
        [self.sheetDelegate sheetCollection:self didSelectOrSwipeItemAtIndex:index click:NO];
    }
    // 赋值
    _selectCell = (SheetCollectionCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%.2f", scrollView.contentOffset.x);
}


@end
