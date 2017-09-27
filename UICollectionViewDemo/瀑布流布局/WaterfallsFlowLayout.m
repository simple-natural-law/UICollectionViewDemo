//
//  WaterfallsFlowLayout.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/19.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "WaterfallsFlowLayout.h"


static NSString *const itemLayoutInfoKey = @"itemLayoutInfoKey";

static NSString *const headerLayoutInfoKey = @"headerLayoutInfoKey";

static NSString *const footerLayoutInfoKey = @"footerLayoutInfoKey";

@interface WaterfallsFlowLayout ()

@property (nonatomic, strong) NSMutableDictionary *attributesDic;

@property (nonatomic, assign) CGFloat contentHeight;
// 保存每个分区的所有列的当前高度
@property (nonatomic, strong) NSMutableArray *columnHeightArray;

@end


@implementation WaterfallsFlowLayout

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self config];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self config];
    }
    return self;
}

#pragma mark- 重写父类方法 UICollectionViewLayout(UISubclassingHooks)
/**
 collectionView初次显示前或者调用invalidateLayout方法后会调用此方法
 触发此方法会重新计算布局，每次布局也是从此方法开始
 在此方法中需要做的事情是准备后续计算所需的东西，以得出后面的ContentSize和每个item的layoutAttributes
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    NSLog(@"prepareLayout");
    
    [self.attributesDic removeAllObjects];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    NSMutableDictionary *itemLayoutInfo = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *headerLayoutInfo = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *footerLayoutInfo = [[NSMutableDictionary alloc] init];
    
    CGFloat originY = 0.0;
    
    for (int i = 0; i < sectionCount; i++)
    {
        NSInteger      column = [self columnCountForSectionAtIndex:i];
        UIEdgeInsets    inset = [self insetForSectionAtIndex:i];
        CGFloat columnSpacing = [self columnSpacingForSectionAtIndex:i];
        CGFloat    rowSpacing = [self rowSpacingForSectionAtIndex:i];
        CGFloat     itemWidth = floorf((self.collectionView.frame.size.width - inset.left - inset.right - columnSpacing*(column-1))/column);
        
        // 准备header布局信息
        NSIndexPath *supplementaryViewIndexPath = [NSIndexPath indexPathWithIndex:i];
        
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:supplementaryViewIndexPath];
        
        CGSize headerSize = [self headerSizeInSection:i];
        
        headerAttributes.frame = CGRectMake(0.0, originY, self.collectionView.frame.size.width, headerSize.height);
        
        [headerLayoutInfo setObject:headerAttributes forKey:supplementaryViewIndexPath];
        
        originY += headerSize.height + inset.top;
        
        // 记录该分区的每列总高度
        [self.columnHeightArray removeAllObjects];
        
        for (int c = 0; c < column; c++)
        {
            [self.columnHeightArray addObject:@(0)];
        }
        
        // 准备item布局信息
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        
        CGFloat originX = 0.0;
        
        for (int j = 0; j < itemCount; j++)
        {
            NSInteger index = [self getMinimumHeightColumnIndexFromAllColumns];
            
            CGFloat minimumHeight = [self.columnHeightArray[index] floatValue];
            
            if (minimumHeight > 0.0)
            {
                originY = minimumHeight + rowSpacing;
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            originX = inset.left + index * (itemWidth + columnSpacing);
            
            CGFloat itemHeight = [self itemHeightForIndexPath:indexPath];
            
            attributes.frame = CGRectMake(originX, originY, itemWidth, itemHeight);
            
            [itemLayoutInfo setObject:attributes forKey:indexPath];
            
            self.columnHeightArray[index] = @(originY + itemHeight);
        }
        
        originY = [self getMaximumHeightFormAllColumnHeights]+inset.bottom;
        
        // 准备footer布局信息
        UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:supplementaryViewIndexPath];
        
        CGSize footerSize = [self footerSizeInSection:i];
        
        footerAttributes.frame = CGRectMake(0, originY, self.collectionView.frame.size.width, footerSize.height);
        
        [footerLayoutInfo setObject:footerAttributes forKey:supplementaryViewIndexPath];
        
        originY += footerSize.height;
    }
    
    self.contentHeight = originY;
    
    [self.attributesDic setObject:itemLayoutInfo forKey:itemLayoutInfoKey];
    
    [self.attributesDic setObject:headerLayoutInfo forKey:headerLayoutInfoKey];
    
    [self.attributesDic setObject:footerLayoutInfo forKey:footerLayoutInfoKey];
}


/*
 * 返回内容的总高度
 */
- (CGSize)collectionViewContentSize
{
    NSLog(@"collectionViewContentSize");
    return CGSizeMake(self.collectionView.bounds.size.width, self.contentHeight);
}



/*
 * 返回位置在传入的rect范围内的所有布局信息(当item数量较多时，如果这里忽略rect而直接返回所有的布局信息，程序的运行效率会较低)
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"layoutAttributesForElementsInRect:");
    
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
    NSLog(@"layoutAttributesForItemAtIndexPath:");
    
    UICollectionViewLayoutAttributes *attributes = self.attributesDic[itemLayoutInfoKey][indexPath];
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"layoutAttributesForSupplementaryViewOfKind:");
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionViewLayoutAttributes *attributes = self.attributesDic[headerLayoutInfoKey][indexPath];
        
        return attributes;
    }else
    {
        UICollectionViewLayoutAttributes *attributes = self.attributesDic[footerLayoutInfoKey][indexPath];
        
        return attributes;
    }
}


/// Collection View 在滚动过程中会不断调用布局对象的`shouldInvalidateLayoutForBoundsChange`方法来判断是否需要废弃当前布局信息并重复之前的布局过程重新生成布局。所以这里需要增加一下条件限制，只有当collection view的bounds属性发生变化时，我们需要废弃当前布局信息并重新生成布局。否则会在滚动过程中不断重新生成布局信息，会大大降低程序的运行效率。(设备方向变化通常会导致 collection view 的 bounds 变化。如果通过 shouldInvalidateLayoutForBoundsChange: 判定为布局需要被无效化并重新计算的时候，布局对象会被询问以提供新的布局。UICollectionViewFlowLayout 的默认实现正确地处理了这个情况，但是如果你子类化 UICollectionViewLayout 的话，你需要在bounds变化时返回 YES。)
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    
    return CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds);
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

- (CGSize)headerSizeInSection:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(waterfallsCollectionView:layout:referenceSizeForHeaderInSection:)])
    {
        return [(id<UICollectionViewDelegateWaterfallsFlowLayout>)self.collectionView.delegate waterfallsCollectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    }
    
    return CGSizeMake(0.0, 0.0);
}

- (CGSize)footerSizeInSection:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(waterfallsCollectionView:layout:referenceSizeForFooterInSection:)])
    {
        return [(id<UICollectionViewDelegateWaterfallsFlowLayout>)self.collectionView.delegate waterfallsCollectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
    }
    
    return CGSizeMake(0.0, 0.0);
}

/// 返回高度最小列的下标
- (NSInteger)getMinimumHeightColumnIndexFromAllColumns
{
    __block NSInteger index = 0;
    
    [self.columnHeightArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj floatValue] < [self.columnHeightArray[index] floatValue])
        {
            index = idx;
        }
    }];
    
    return index;
}

/// 返回高度最大值
- (CGFloat)getMaximumHeightFormAllColumnHeights
{
    __block CGFloat height = 0.0;
    
    [self.columnHeightArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat h = [obj floatValue];
        
        if (h > height)
        {
            height = h;
        }
    }];
    
    return height;
}


- (void)config
{
    self.columnCount   = 3;
    self.sectionInset  = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    self.columnSpacing = 10.0;
    self.rowSpacing    = 10.0;
}


#pragma mark- 懒加载
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
