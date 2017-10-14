//
//  CustomFlowLayout.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/22.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "CustomFlowLayout.h"

@interface CustomFlowLayout ()

@property (nonatomic, strong) NSMutableArray <NSIndexPath *>* insertIndexPathArr;

@property (nonatomic, strong) NSMutableArray <NSIndexPath *>* deleteIndexPathArr;

@end


@implementation CustomFlowLayout

- (void)invalidateLayout
{
    NSLog(@"invalidateLayout");
    
    [super invalidateLayout];
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSLog(@"prepareLayout");
}

- (CGSize)collectionViewContentSize
{
    NSLog(@"collectionViewContentSize");
    
    return [super collectionViewContentSize];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"layoutAttributesForElementsInRect");
    
    return [super layoutAttributesForElementsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"layoutAttributesForItemAtIndexPath");
    
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

/// 开始更新集合视图前，会调用此方法，传入被更新的cell的更新前IndexPath和更新后IndexPath，我们可以在此记录下来，后面需要使用。
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems
{
    NSLog(@"prepareForCollectionViewUpdates");
    
    [super prepareForCollectionViewUpdates:updateItems];
    
    [self.insertIndexPathArr removeAllObjects];
    [self.deleteIndexPathArr removeAllObjects];
    
    for (UICollectionViewUpdateItem * item in updateItems)
    {
        switch (item.updateAction)
        {
            case UICollectionUpdateActionInsert:
            {
                [self.insertIndexPathArr addObject:item.indexPathAfterUpdate];
            }
                break;
            case UICollectionUpdateActionReload:
            {
                
            }
                break;
            case UICollectionUpdateActionDelete:
            {
                [self.deleteIndexPathArr addObject:item.indexPathBeforeUpdate];
            }
                break;
            case UICollectionUpdateActionMove:
            {
                
            }
                break;
            case UICollectionUpdateActionNone:
            {
                
            }
                break;
            default:
                break;
        }
    }
}

/// 设置更新布局后cell刚显示时的起始布局属性值
/// 用来执行动画: cell刚显示时的起始布局属性值 -> 更新布局后的布局属性值
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    NSLog(@"initialLayoutAttributesForAppearingItemAtIndexPath:");
    
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertIndexPathArr containsObject:itemIndexPath])
    {
        attributes.transform = CGAffineTransformMakeScale(0.2, 0.2);
        attributes.alpha     = 0.0;
        
        NSLog(@"Appearing Item that was inserted by us.");
    }

    return attributes;
}

/// 设置更新布局前cell被移除时的最终布局属性值
/// 用来执行动画: 更新布局前的布局属性值 -> cell被移除时的最终布局属性值
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    NSLog(@"finalLayoutAttributesForDisappearingItemAtIndexPath:");
    
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deleteIndexPathArr containsObject:itemIndexPath])
    {
        attributes.transform = CGAffineTransformMakeScale(0.2, 0.2);
        attributes.alpha     = 0.0;
        
        NSLog(@"Disappearing Item that was deleted by us.");
    }

    return attributes;
}


- (NSMutableArray<NSIndexPath *> *)insertIndexPathArr
{
    if (_insertIndexPathArr == nil)
    {
        _insertIndexPathArr = [[NSMutableArray alloc] init];
    }
    return _insertIndexPathArr;
}


- (NSMutableArray<NSIndexPath *> *)deleteIndexPathArr
{
    if (_deleteIndexPathArr == nil)
    {
        _deleteIndexPathArr = [[NSMutableArray alloc] init];
    }
    return _deleteIndexPathArr;
}

@end

