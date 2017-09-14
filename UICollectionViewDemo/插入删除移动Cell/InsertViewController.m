//
//  InsertViewController.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/13.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "InsertViewController.h"
#import "InsertCell.h"

@interface InsertViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *dataArray;
// 是否处于编辑状态
@property (assign, nonatomic) BOOL isEditing;

@property (strong, nonatomic) UIView *snapshotView;

@property (strong, nonatomic) NSIndexPath *formIndexPath;

@end


@implementation InsertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.isEditing = NO;
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    editButton.frame = CGRectMake(0, 0, 60, 30);
    
    [editButton addTarget:self action:@selector(startEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:longPress];
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InsertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InsertCell" forIndexPath:indexPath];
    
    [cell setIsEditing:self.isEditing];
    
    cell.titleLabel.text = self.dataArray[indexPath.row];
    
    [cell didClickDeleteButtonBlock:^(InsertCell *cell) {
        
        
    }];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        return reusableView;
    }
    
    return nil;
}


#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath: %ld-%ld, text:%@",indexPath.row,indexPath.section,self.dataArray[indexPath.row]);
}

#pragma mark- target action
- (void)startEdit:(UIButton *)button
{
    if (self.isEditing)
    {
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        self.isEditing = NO;
    }else
    {
        [button setTitle:@"完成" forState:UIControlStateNormal];
        self.isEditing = YES;
    }
    
    [self.collectionView reloadData];
}


- (void)longPressAction:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (!self.isEditing)
    {
        self.isEditing = YES;
        
        UIButton *button = self.navigationItem.rightBarButtonItem.customView;
        [button setTitle:@"完成" forState:UIControlStateNormal];
        
        for (InsertCell *cell in self.collectionView.visibleCells)
        {
            [cell setIsEditing:YES];
        }
    }
    
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:    //手势开始
        {
            // 获取手势触摸点坐标
            CGPoint location = [gestureRecognizer locationInView:self.collectionView];
            // 获取被长按的cell的indexPath
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
            
            if (indexPath == nil) return;
            
            self.formIndexPath = indexPath;
            
            UICollectionViewCell *targetCell = [self.collectionView cellForItemAtIndexPath:indexPath];
            // 得到当前cell的截图
            self.snapshotView = [targetCell snapshotViewAfterScreenUpdates:YES];
            
            self.snapshotView.center = targetCell.center;
            
            [self.collectionView addSubview:self.snapshotView];
            
            // 隐藏被点击的cell
            targetCell.hidden = YES;
            
            [UIView animateWithDuration:0.15 animations:^{
                self.snapshotView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            }];
        }
            break;
        case UIGestureRecognizerStateChanged:  //手势发生变化
        {
            CGPoint point = [gestureRecognizer locationInView:self.collectionView];
            
            self.snapshotView.center = point;
            
            NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:point];
            
            if (toIndexPath == nil)  return;
            
            // 先改变数据源
            NSString *string = self.dataArray[self.formIndexPath.row];
            [self.dataArray removeObject:string];
            [self.dataArray insertObject:string atIndex:toIndexPath.row];
            
            // 再移动cell
            [self.collectionView moveItemAtIndexPath:self.formIndexPath toIndexPath:toIndexPath];
            self.formIndexPath = toIndexPath;
        }
            break;
        case UIGestureRecognizerStateEnded:    //手势结束
        {
            UICollectionViewCell *targetCell = [self.collectionView cellForItemAtIndexPath:self.formIndexPath];
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.snapshotView.center = targetCell.center;
                self.snapshotView.transform = CGAffineTransformIdentity;
                
            }completion:^(BOOL finished) {
                
                targetCell.hidden = NO;
                
                [self.snapshotView removeFromSuperview];
                
                self.formIndexPath = nil;
                self.snapshotView  = nil;
                
                // 不在可视范围内的cell，滑动到可视范围内的时候,可能不会调用cellForItemAtIndexPath:方法，这些cell的编辑状态不会刷新。
                [self.collectionView reloadData];
            }];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark- setter and getter
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 20; i++)
        {
            [_dataArray addObject:[NSString stringWithFormat:@"id: %d",i]];
        }
    }
    return _dataArray;
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
