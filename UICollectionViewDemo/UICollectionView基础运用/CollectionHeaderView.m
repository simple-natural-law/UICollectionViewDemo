//
//  CollectionHeaderView.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/7.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.text = @"Header(Code)";
        
        [self addSubview:titleLabel];
    }
    return self;
}

@end


@implementation CollectionFooterView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.text = @"Header(Code)";
        
        [self addSubview:titleLabel];
    }
    return self;
}


@end
