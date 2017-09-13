//
//  SelectCell.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/13.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "SelectCell.h"

@interface SelectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SelectCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.imageView.image = selected ? [UIImage imageNamed:@"selected"] : [UIImage imageNamed:@"deselected"];
}

@end
