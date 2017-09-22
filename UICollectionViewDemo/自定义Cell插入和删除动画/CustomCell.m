//
//  CustomCell.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/22.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "CustomCell.h"


typedef void(^DeleteItemBlock)(CustomCell *cell);

@interface CustomCell ()

@property (nonatomic, copy) DeleteItemBlock block;

@end

@implementation CustomCell

- (IBAction)deleteItem:(id)sender
{
    if (self.block)
    {
        self.block(self);
    }
}

- (void)deleteItemWithBlock:(void (^)(CustomCell *))block
{
    self.block = block;
}

@end
