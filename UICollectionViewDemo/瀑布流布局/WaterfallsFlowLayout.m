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

@end

@implementation WaterfallsFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    
}



- (NSMutableArray *)attributesArray
{
    if (_attributesArray == nil)
    {
        _attributesArray = [[NSMutableArray alloc] init];
    }
    return _attributesArray;
}

@end
