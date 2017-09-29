//
//  CardSelectedLayout.m
//  UICollectionViewDemo
//
//  Created by 张诗健 on 2017/9/26.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "CardSelectedLayout.h"

@interface CardSelectedLayout ()

@property (nonatomic, assign) BOOL needPrepareLayout;

@end

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
        
        CGFloat scale = 1 - d/self.collectionView.frame.size.width;
        
        scale = scale > 0.6 ? scale : 0.6;
        
        copyAttributes.transform = CGAffineTransformMakeScale(scale, scale);
        
        [array addObject:copyAttributes];
    }
    
    return array;
}

// 重要!!!
// CollectionView滚动过程中会不断调用此方法来判断是否废弃当前布局并重新生成布局信息，这里返回YES。那么cell在滚动时就会不断更新布局信息以达到动画效果。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

// 调整CollectionView滚动结束的最终位置，让某个cell始终处于屏幕心。
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 计算停止滚动后当前屏幕上显示的CollectionView内容区域
    CGRect rect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    
    // 获取停止滚动后在屏幕上显示的cell的布局信息
    NSArray<UICollectionViewLayoutAttributes *> *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算停止滚动后，此时屏幕中心点位置到CollectionView最左侧距离
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width*0.5;
    
    CGFloat distance = self.collectionView.contentSize.height;
    
    for (UICollectionViewLayoutAttributes *attributes in array)
    {
        if (fabs(attributes.center.x - centerX) < fabs(distance))
        {
            distance = attributes.center.x - centerX;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + distance, proposedContentOffset.y);
}


@end
