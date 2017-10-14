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

/// 某个cell的插入，删除，移动，刷新动画开始执行时，设置起始属性值
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    NSLog(@"initialLayoutAttributesForAppearingItemAtIndexPath:");
    
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertIndexPathArr containsObject:itemIndexPath])
    {
        attributes.transform = CGAffineTransformMakeScale(0.2, 0.2);
        attributes.alpha     = 0.0;
        
        NSLog(@"Appearing Item that was inserted.");
    }

    return attributes;
}

/// 某个cell的插入，删除，移动，刷新动画执行结束时，设置结束属性值
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    NSLog(@"finalLayoutAttributesForDisappearingItemAtIndexPath:");
    
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deleteIndexPathArr containsObject:itemIndexPath])
    {
        attributes.transform = CGAffineTransformMakeScale(0.2, 0.2);
        attributes.alpha     = 0.0;
        
        NSLog(@"Disappearing Item that was deleted.");
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

