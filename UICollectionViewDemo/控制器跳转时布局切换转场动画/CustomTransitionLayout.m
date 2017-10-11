//
//  CustomTransitionLayout.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/10/11.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "CustomTransitionLayout.h"

@implementation CustomTransitionLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    return attributes;
}

@end
