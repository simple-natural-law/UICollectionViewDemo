//
//  InsertCell.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/13.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "InsertCell.h"

@interface InsertCell ()

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (assign, nonatomic) BOOL isEditing;

@property (copy, nonatomic) DidClickDeleteButtonBlock block;

@end

@implementation InsertCell


- (IBAction)delete:(id)sender
{
    if (self.block)
    {
        self.block(self);
    }
}


- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    
    self.deleteButton.hidden = !isEditing;
}

- (void)didClickDeleteButtonBlock:(DidClickDeleteButtonBlock)block
{
    self.block = block;
}


@end
