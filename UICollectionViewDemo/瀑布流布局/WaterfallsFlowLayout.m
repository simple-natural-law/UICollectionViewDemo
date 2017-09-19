//
//  WaterfallsFlowLayout.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/19.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "WaterfallsFlowLayout.h"

@interface WaterfallsFlowLayout ()

@property (nonatomic, strong) NSMutableArray *attributesArray;

@property (nonatomic, assign) CGFloat contentHeight;
// 保存每个分区的所有列的当前高度
@property (nonatomic, strong) NSMutableArray *columnHeightArray;

@end


@implementation WaterfallsFlowLayout

#pragma mark- 重写父类方法 UICollectionViewLayout(UISubclassingHooks)

/**
 collectionView初次显示前或者调用invalidateLayout方法后会调用此方法
 触发此方法会重新计算布局，每次布局也是从此方法开始
 在此方法中需要做的事情是准备后续计算所需的东西，以得出后面的ContentSize和每个item的layoutAttributes
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attributesArray removeAllObjects];
    
    [self.columnHeightArray removeAllObjects];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    for (int i = 0; i < sectionCount; i++)
    {
        NSInteger column = [self columnCountForSectionAtIndex:i];
        
        NSMutableArray *heightArray = [NSMutableArray arrayWithCapacity:column];
        
        for (int c = 0; c < column; c++)
        {
            [heightArray addObject:@(0)];
        }
        
        [self.columnHeightArray addObject:heightArray];
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        
        for (int j = 0; j < itemCount; j++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            [self.attributesArray addObject:attributes];
        }
    }
}


/*
 * 返回内容的总高度
 */
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width, self.contentHeight);
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [super layoutAttributesForElementsInRect:rect];
}


#pragma mark- Methods
- (NSInteger)columnCountForSectionAtIndex:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(waterfallsCollectionView:layout:columnCountForSectionAtIndex:)])
    {
        return [(id<UICollectionViewDelegateWaterfallsFlowLayout>)self.collectionView.delegate waterfallsCollectionView:self.collectionView layout:self columnCountForSectionAtIndex:section];
    }
    
    return self.columnCount;
}

- (CGFloat)itemHeightForIndexPath:(NSIndexPath *)indexPath
{
    return [(id<UICollectionViewDelegateWaterfallsFlowLayout>)self.collectionView.delegate waterfallsCollectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
}


- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(waterfallsCollectionView:layout:insetForSectionAtIndex:)])
    {
        return [(id<UICollectionViewDelegateWaterfallsFlowLayout>)self.collectionView.delegate waterfallsCollectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    
    return self.sectionInset;
}


- (CGFloat)columnSpacingForSectionAtIndex:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(waterfallsCollectionView:layout:columnSpacingForSectionAtIndex:)])
    {
        return [(id<UICollectionViewDelegateWaterfallsFlowLayout>)self.collectionView.delegate waterfallsCollectionView:self.collectionView layout:self columnSpacingForSectionAtIndex:section];
    }
    
    return self.columnSpacing;
}

- (CGFloat)rowSpacingForSectionAtIndex:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(waterfallsCollectionView:layout:rowSpacingForSectionAtIndex:)])
    {
        return [(id<UICollectionViewDelegateWaterfallsFlowLayout>)self.collectionView.delegate waterfallsCollectionView:self.collectionView layout:self rowSpacingForSectionAtIndex:section];
    }
    
    return self.rowSpacing;
}

- (NSMutableArray *)attributesArray
{
    if (_attributesArray == nil)
    {
        _attributesArray = [[NSMutableArray alloc] init];
    }
    return _attributesArray;
}

- (NSMutableArray *)columnHeightArray
{
    if (_columnHeightArray == nil)
    {
        _columnHeightArray = [[NSMutableArray alloc] init];
    }
    return _columnHeightArray;
}

@end
