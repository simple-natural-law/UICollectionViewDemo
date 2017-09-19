//
//  WaterfallsFlowLayout.h
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/19.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterfallsFlowLayout : UICollectionViewLayout

// 列数
@property (nonatomic, assign) NSInteger columnCount;

// 列间距
@property (nonatomic, assign) NSInteger columnSpacing;

// 行间距
@property (nonatomic, assign) NSInteger rowSpacing;

// section到collection view四周的边距
@property (nonatomic, assign) UIEdgeInsets sectionInset;



@end
