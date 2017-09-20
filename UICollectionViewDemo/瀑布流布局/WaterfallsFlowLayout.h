//
//  WaterfallsFlowLayout.h
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/19.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICollectionViewDelegateWaterfallsFlowLayout <UICollectionViewDelegate>

@required
// 返回item的高度
- (CGFloat)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
// 返回每个section的列数
- (NSInteger)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout columnCountForSectionAtIndex:(NSInteger)section;
// 返回item到section四周的边距
- (UIEdgeInsets)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
// 返回行间距
- (CGFloat)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout rowSpacingForSectionAtIndex:(NSInteger)section;
// 返回列间距
- (CGFloat)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout columnSpacingForSectionAtIndex:(NSInteger)section;
// 返回Header size
- (CGSize)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
// 返回Footer size
- (CGSize)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end



@interface WaterfallsFlowLayout : UICollectionViewLayout

// 列数
@property (nonatomic, assign) NSInteger columnCount;

// 列间距
@property (nonatomic, assign) CGFloat columnSpacing;

// 行间距
@property (nonatomic, assign) CGFloat rowSpacing;

// item到section四周的边距
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@end
