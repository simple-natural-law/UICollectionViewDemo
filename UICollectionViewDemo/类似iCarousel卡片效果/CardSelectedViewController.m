//
//  CardSelectedViewController.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/26.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "CardSelectedViewController.h"

@interface CardSelectedViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger _count;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation CardSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _count = 10;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _count = 20;
        
        [self.collectionView reloadData];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label = [cell.contentView viewWithTag:66666];
    
    label.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
