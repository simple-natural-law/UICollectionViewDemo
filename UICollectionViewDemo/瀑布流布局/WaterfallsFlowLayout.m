//
//  WaterfallsFlowLayout.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/19.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "WaterfallsFlowLayout.h"


static NSString *const itemLayoutInfoKey = @"itemLayoutInfoKey";

static NSString *const supplementaryViewLayoutInfoKey = @"supplementaryViewLayoutInfoKey";

static NSString *const kElementKindSectionHeader = @"kElementKindSectionHeader";

static NSString *const kElementKindSectionFooter = @"kElementKindSectionFooter";

@interface WaterfallsFlowLayout ()

@property (nonatomic, strong) NSMutableDictionary *attributesDic;

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
    
    [self.attributesDic removeAllObjects];
    
    [self.columnHeightArray removeAllObjects];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    NSMutableDictionary *itemLayoutInfo = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *supplementaryViewLayoutInfo = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < sectionCount; i++)
    {
        // 准备记录每列最大高度
        NSInteger column = [self columnCountForSectionAtIndex:i];
        NSMutableArray *heightArray = [NSMutableArray arrayWithCapacity:column];
        for (int c = 0; c < column; c++)
        {
            [heightArray addObject:@(0)];
        }
        [self.columnHeightArray addObject:heightArray];
        
        // 准备header布局信息
        NSIndexPath *supplementaryViewIndexPath = [NSIndexPath indexPathWithIndex:i];
        
        UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:kElementKindSectionHeader atIndexPath:supplementaryViewIndexPath];
        
        [supplementaryViewLayoutInfo setObject:headerAttributes forKey:kElementKindSectionHeader];
        
        // 准备item布局信息
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        
        for (int j = 0; j < itemCount; j++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            [itemLayoutInfo setObject:attributes forKey:indexPath];
        }
        
        // 准备footer布局信息
        UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:kElementKindSectionFooter atIndexPath:supplementaryViewIndexPath];
        
        [supplementaryViewLayoutInfo setObject:footerAttributes forKey:kElementKindSectionFooter];
        
    }
    
    [self.attributesDic setObject:itemLayoutInfo forKey:itemLayoutInfoKey];
    
    [self.attributesDic setObject:supplementaryViewLayoutInfo forKey:supplementaryViewLayoutInfoKey];
}


/*
 * 返回内容的总高度
 */
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width, self.contentHeight);
}



/*
 * 返回位置在传入的rect范围内的所有布局信息(当item数量较多时，如果这里忽略rect而直接返回所有的布局信息，程序的运行效率会较低)
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArr = [[NSMutableArray alloc] init];
    
    for (NSString *key in self.attributesDic.allKeys)
    {
        NSDictionary *dic = [self.attributesDic objectForKey:key];
        
        for (NSIndexPath *key in dic.allKeys)
        {
            UICollectionViewLayoutAttributes *attributes = [dic objectForKey:key];
            
            if (CGRectIntersectsRect(rect, attributes.frame))
            {
                [attributesArr addObject:attributes];
            }
        }
    }
    
    return attributesArr;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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

- (NSMutableDictionary *)attributesDic
{
    if (_attributesDic == nil)
    {
        _attributesDic = [[NSMutableDictionary alloc] init];
    }
    return _attributesDic;
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
