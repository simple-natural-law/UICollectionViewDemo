//
//  CardSelectedLayout.m
//  UICollectionViewDemo
//
//  Created by 张诗健 on 2017/9/26.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "CardSelectedLayout.h"

@implementation CardSelectedLayout

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
}


- (void)prepareLayout
{
    [super prepareLayout];
    
    CGFloat left = (self.collectionView.frame.size.width - self.itemSize.width)*0.5;
    
    CGFloat top  = (self.collectionView.frame.size.height - self.itemSize.height)*0.5;
    
    self.sectionInset = UIEdgeInsetsMake(top, left, top, left);
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray <UICollectionViewLayoutAttributes *> *attributesArr = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat targetX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width*0.5;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:attributesArr.count];
    
    for (UICollectionViewLayoutAttributes *attributes in attributesArr) {
        
        UICollectionViewLayoutAttributes *copyAttributes = [attributes copy];
        
        CGFloat d = fabs(attributes.center.x - targetX);
        
        CGFloat scale = 1.0 - d/self.collectionView.frame.size.width;
        
        copyAttributes.transform = CGAffineTransformMakeScale(scale, scale);
        
        [array addObject:copyAttributes];
    }
    
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
