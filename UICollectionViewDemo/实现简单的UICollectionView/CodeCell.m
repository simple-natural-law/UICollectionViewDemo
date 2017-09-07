//
//  CodeCell.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/7.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "CodeCell.h"

@implementation CodeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor redColor];
        
        self.headLabel = [[UILabel alloc] init];
        self.headLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.headLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.headLabel];
        
        NSLayoutConstraint *leading  = [NSLayoutConstraint constraintWithItem:self.headLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
        NSLayoutConstraint *top      = [NSLayoutConstraint constraintWithItem:self.headLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.headLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        NSLayoutConstraint *height   = [NSLayoutConstraint constraintWithItem:self.headLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0];
        
        [self.contentView addConstraints:@[leading,top,trailing,height]];
    }
    return self;
}

@end
