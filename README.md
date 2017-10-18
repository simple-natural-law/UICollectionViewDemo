# UICollectionView探究

## 概述

[UICollectionView](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/CollectionViewBasics/CollectionViewBasics.html#//apple_ref/doc/uid/TP40012334-CH2-SW7)是iOS开发中最常用的UI控件之一，可以用它来管理一组有序的不同尺寸的视图，并以可定制的布局来展示它们。UICollectionView支持动画，当视图被插入，删除或重新排序时，会触发动画，动画效果支持自定义。为了更好的使用UICollectionView，我们有必要对其进行深入了解。

## 基础
### UICollectionView是由多个对象协作实现的
集合视图将视图的数据内容与视图的布局方式分开来管理。数据内容由集合视图的dataSource对象管理，而布局方式则是由许多不同的对象协作来管理。下表列出了UIKit中与集合视图相关的类，并根据它们在集合视图中的作用进行了划分。

| 目的 | 类/协议 | 描述 |
|-----|--------|------|
| 顶层容器和管理者 | UICollectionView UICollectionViewController | UICollectionView定义了显示视图内容的空间，它继承自[UIScrollView](https://developer.apple.com/documentation/uikit/uiscrollview)，能够根据内容的高度来调整其滚动区域。它的layout布局对象会提供布局信息来呈现数据。UICollectionViewController对象提供了一个UICollectionView的视图控制器级管理支持。 |
| 内容管理 | UICollectionViewDataSource协议 UICollectionViewDelegate协议 | DataSource协议是必须实现的，它创造并管理UICollectionView的视图内容。Delegate协议能获取视图的信息并自定义视图的行为，这个协议是可选实现的。|
| 内容视图 | UICollectionReusableView UICollectionViewCell | UICollectionView展示的所有视图都必须是UICollectionReusableView类的实例，该类支持回收复用机制。在视图滚动时,回收复用视图而不是重新创建，能极大提高性能。UICollectionViewCell对象是用来展示主要数据的可重用视图,该类继承自UICollectionReusableView。|
| 布局 | UICollectionViewLayout UICollectionViewLayoutAttributes UICollectionViewUpdateItem | UICollectionViewLayout的子类被称为布局对象，它负责定义集合视图中的cell和可重用视图的位置，大小，视觉效果。在布局过程中，布局对象UICollectionViewLayout会创建一个布局属性对象UICollectionViewLayoutAttributes去告诉集合视图在什么位置，用什么样视觉外观去展示cell和可重用视图。当在集合视图中插入，删除，移动数据项时，布局对象会接收到UICollectionViewUpdateItem类的实例，我们不需要自行创建该类的实例。|
| 流水布局  | UICollectionViewFlowLayout UICollectionViewDelegateFlowLayout协议 |  UICollectionViewFlowLayout类是用于实现网格或其他基于行的布局的具体布局对象。 我们可以按照原样使用该类或者配合UICollectionViewDelegateFlowLayout协议一起使用，这样就可以动态自定义布局信息。|


集合视图从`dataSource`对象中获取要展示的cell的数据内容，通过`delegate`对象去管理cell的选中和高亮等状态。布局对象负责决定cell所在的位置，布局属性对象记录了cell的布局属性，布局对象将布局属性对象传递给集合视图，集合视图接收到布局属性信息后创建并展示cell。


![图1-1](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/Art/cv_objects_2x.png)

### 重用视图提高性能
集合视图通过复用已被回收的cell来提高效率，当cell滚动到屏幕外时，它们不会被销毁，但会被移出容器视图并放置到重用队列中。当有新的内容将要滚动到屏幕中时，如果重用队列中有可复用的cell，会首先从重用队列中取，并重置被取出来的cell的数据，然后将其添加到容器视图中展示。如果重用队列没有可复用的cell，这时才会新创建一个cell去展示。为了方便这种循环，集合视图中展示的都必须继承自`UICollectionReusableView`类。

集合视图支持三种不同类型的可重用视图，每种视图都具有特定的用途：

- cell(单元格)展示集合视图的主要内容，每个cell展示的内容由`dataSource`对象提供。每个cell都必须是`UICollectionViewCell`的实例，同时我们也可以根据需要对其子类化。cell对象支持管理其选中和高亮状态。
- supplementary view(补充视图)展示每个section(分区)的信息。和cell相同的是：supplementary view也是数据驱动的。不同的是：supplementary view是可选的而不是强制的。supplementary view的使用和布局是由布局对象管理的，系统提供的流水布局支持设置header和footer作为可选的supplementary view。
- decoration view(装饰视图)与`dataSource`对象提供的数据不相关，完全属于布局对象。布局对象可能会使用它自定义集合视图背景。

### 布局对象控制视图的视觉效果
布局对象负责确定集合视图中每个cell的位置和视觉样式。虽然`dataSource`对象提供了要展示的视图和实际内容，但布局对象确定了这些视图的位置，大小以及其他与外观相关的属性。这种责任划分使得我们能够在动态的更改布局时无需更改`dataSource`对象提供的数据。

布局对象并不拥有任何视图，它只会生成用来描述cell，supplementary view和decoration view的位置，大小，视觉样式的布局属性，并将布局属性传递给集合视图，集合视图将这些属性应用于实际的视图对象。

布局对象可以随意生成视图的位置，大小以及视觉样式属性，没有任何限制。只有布局对象能改变视图在集合视图中的位置，它能移动视图，也能随机切换横竖屏，甚至能复位某视图而不用考虑此视图周围的视图。例如，如果有需要，布局对象可以将所有视图叠加在一起。

下图显示了垂直滚动的流水布局对象如何布置cell。在垂直滚动流水布局中，内容区域的宽度保持固定，高度随着内容高度的增加而增加。布局对象一次只放置一个cell，在放置前会先计算出cell在容器视图中的frame，为cell选择最合适的位置。

![图1-2](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/Art/cv_layout_basics_2x.png)

## 使用
必须为集合视图提供一个`dataSource`对象，集合视图从`dataSource`对象中获取要显示的内容。它可以是一个数据模型对象，也可以是管理集合视图的视图控制器，`dataSource`对象的唯一要求是它必须能够提供集合视图所需的所有信息。`delegate`对象是可选的，用于管理与内容的呈现以及交互有关的方面。它的主要职责是管理cell的选中和高亮状态，可以扩展`UICollectionViewDelegate`协议以提供其他信息。流水布局对象就扩展了`UICollectionViewDelegate`协议来定制布局，例如，cell的大小和它们之间的间距。

### UICollectionViewDataSource
提供集合视图包含的section(分区)数量：
```
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return [_dataArray count];
}
```
提供每个section包含的item(单元格)数量：
```
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray* sectionArray = [_dataArray objectAtIndex:section];

    return [sectionArray count];
}
```
根据IndexPath提供对应的cell：
```
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];

    return cell;
}
```
根据IndexPath提供对应的supplementary view，流水布局的supplementary view分为Header和Footer两种类型：
```
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // UICollectionElementKindSectionHeader返回Header，UICollectionElementKindSectionFooter返回Footer
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderReuseIdentifier" forIndexPath:indexPath];

        return supplementaryView;
    }else
    {
        UICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterReuseIdentifier" forIndexPath:indexPath];

        return supplementaryView;
    }
}
```
> 注意：当集合视图展示的cell数量较少时，集合视图的`bounce`属性会默认关闭，而有时候我们的页面需要下拉刷新数据的功能，这时只需要设置`alwaysBounceVertical`属性设为`YES`即可。

### UICollectionViewDelegate
设置cell是否能被选中：
```
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
```
当集合视图的`allowsMultipleSelection`多选属性为`YES`时，设置是否可以点击取消选中已被选中的cell：
```
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
```
已选中cell后回调：
```
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
```
已取消选中cell后回调：
```
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
```
设置cell被选中时是否支持高亮：
```
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
```
选中cell时触发高亮后回调，我们可以在这里去改变cell的背景色:
```
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    cell.contentView.backgroundColor = [UIColor lightGrayColor];
}
```
cell被取消选中变为普通状态后回调，我们可以在这里还原cell的背景色：
```
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    cell.contentView.backgroundColor = [UIColor whiteColor];
}
```
> 注意：点击cell时，cell的状态变化过程为：手指接触屏幕时，cell状态变为高亮，此时cell还未被选中。当手指离开屏幕后，cell状态变回到普通状态，然后cell被集合视图选中。当快速点击选中cell时，由于状态变化很快，导致人眼看不出来cell背景色有发生变化，实际上是发生了变化的。而长按选中cell时，可以看到背景色的变化。

![图2-1](http://oaz007vqv.bkt.clouddn.com/cell_selection_semantics_2x.png?imageView/2/w/600)

### UICollectionViewDelegateFlowLayout
该协议是对`UICollectionViewDelegate`的扩展，能够动态返回cell的大小，和cell之间的最小间距等。

根据IndexPath返回对应的Cell的大小：
```
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80.0, 80.0);
}
```
返回cell到所在section的四周边界的距离：
```
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}
```
根据Section返回对应的cell之间的行最小间距：
```
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}
```
根据section返回对应的cell之间的列最小间距：
```
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}
```
根据section返回对应的Header大小
```
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 40.0);
}
```
根据section返回对应的Footer大小
```
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 40.0);
}
```

### cell和supplementary view的重用
视图的重用避免了不断生成和销毁对象的操作，提高了程序运行的效率。要想重用cell和supplementary view，首先需要注册cell和supplementary view，有种三种注册方式：

- 使用storyboard布局时，直接拖拽cell或者supplementary view到storyboard中，设置好重用标识即可。
- 使用xib布局时，设置重用标识后，使用`registerNib:forCellWithReuseIdentifier:`方法来注册cell，使用`registerNib:forSupplementaryViewOfKind:withReuseIdentifier:`方法来注册supplementary view。
- 使用代码布局时，使用`registerClass:forCellWithReuseIdentifier:`方法来注册cell，使用`registerClass:forSupplementaryViewOfKind:withReuseIdentifier:`方法来注册supplementary view。

>  注意：使用纯代码自定义cell和supplementary view时，需要重写`initWithFrame:`方法，`init`方法不会被调用。

dataSource对象为Collection View配置cell和supplementary view时，使用`dequeueReusableCellWithReuseIdentifier:forIndexPath:`方法直接从重用队列中取cell，使用`dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:`方法直接从重用队列中取supplementary view。当重用队列中没有可复用的视图时，会自动帮我们新创建一个可用的视图。

### cell的插入，删除和移动
插入，删除，移动单个cell或者某个section的所有cell时，遵循下面两个步骤：

- 更新数据源对象中的数据内容。
- 调用对应的插入，删除或者移动方法。

集合视图插入，删除和移动cell之前，必须先对应更新数据源。如果数据源没有更新，程序运行就会崩溃。

当插入，删除或者移动cell时，会自动添加动画效果来反映集合视图的更改。在执行动画时，如果还需要`同步`执行其他操作，可以使用`performBatchUpdates:completion:`方法，在`updates block`内执行所有插入，删除或移动调用，动画执行完毕后会调用`completion block`。
```
[self.collectionView performBatchUpdates:^{
    // 执行更改操作

} completion:^(BOOL finished){

    if (finished)
    {
        // 执行其他操作
    }
}];
```

### 长按cell弹出编辑菜单
长按某个cell时，可以弹出一个编辑菜单，能够用于剪切，粘贴，复制这个cell。长按弹出编辑菜单，`delegate`对象必须实现下面3个委托方法：
是否显示编辑菜单：
```
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
```
可以执行哪些操作：
```
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"]|| [NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        return YES;
    }
    return NO;
}
```
点击菜单中选项后回调：
```
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"cut:"])
    {
        // 剪切操作
    }else if ([NSStringFromSelector(action) isEqualToString:@"copy:"])
    {
        // 复制操作
    }else if ([NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        // 粘贴操作
    }
}
```
集合视图只支持`cut:`，`copy:`，`paste:`三种编辑操作。想要了解如何配合剪贴板使用这些操作，可以参看[Text Programming Guide for iOS](https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009542)。

### 切换布局时的转场动画
切换布局最简单的方式是使用`setCollectionViewLayout:animated:`方法。在`UICollectionViewController`之间跳转时，如果需要交互式转场切换布局或者控制切换过程，可以使用`UICollectionViewTransitionLayout`对象。

`UICollectionViewTransitionLayout`类是一种特殊的布局类，它继承自`UICollectionViewLayout`类,在切换到新布局的过程中，它将作为Collection View的临时布局。使用`UICollectionViewTransitionLayout`布局对象时，可以使用不同的计时算法让动画遵循非线性路径，或者根据传入的触摸事件进行移动。官方提供的`UICollectionViewTransitionLayout`类支持对新布局的线性转换，但我们可以对其进行子类化来实现任何所需的效果。

`UICollectionViewLayout`提供了几种跟踪布局之间转换进度的方法，`UICollectionViewTransitionLayout`类通过`transitionProgress`属性来跟踪转场切换的进度，当转场切换开始后，我们需要定期更新此属性值来指示完成的百分比。使用自定义`UICollectionViewTransitionLayout`对象时，`UICollectionViewTransitionLayout`类提供来2种跟踪与布局相关的值的方法：`updateValue:forAnimatedKey:`和`valueForAnimatedKey:`。

转场切换布局时，使用`UICollectionViewTransitionLayout`对象的步骤如下：

- 使用`initWithCurrentLayout:nextLayout: `方法创建一个`UICollectionViewTransitionLayout`实例对象。
- 定期修改`transitionProgress`属性值来指示转场切换的进度。在修改转场进度后，一定要调用`invalidateLayout`方法来废弃当前布局并更新布局。
- Collection View的delegate对象实现委托方法`collectionView:transitionLayoutForOldLayout:newLayout:`返回创建的`UICollectionViewTransitionLayout`实例对象。
- 可以使用`updateValue:forAnimatedKey:`方法来修改与布局相关的值。

## 进阶
### 流水布局
官方提供的`UICollectionViewFlowLayout`流水布局对象实现了基于行的断开布局，单元格被放置在线性路径上，并沿着该行放置尽可能多的单元格，当前行上的空间在使用最小间距也不足以放置下一个单元格时，会重新计算出合适的当前行上摆放的单元格之间的间距，如果该行上只有一个单元格，那么它会被置中，然后会创建新的一行并在该行重复之前的布局过程。

![图3-1](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/Art/flow_horiz_layout_uneven_2x.png)

![图3-2](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/Art/flow_section_insets_2x.png)

使用时，通过固定单元格的大小和单元格之间的最小间距来实现网格状视图，同时也可以任意设置单元格的小和单元格之间的间距来实现不规则排列的视图。当单元格的大小，单元格之间的最小间距，单元格到所在分区四周的边距以及Header和Footer的大小固定时，可以直接设置`itemSize`，`minimumLineSpacing`，`minimumInteritemSpacing`，`sectionInset`，`headerReferenceSize`，`footerReferenceSize`属性值。如果想要动态设置它们，需要集合视图的delegate对象实现`UICollectionViewDelegateFlowLayout`协议的委托方法。


### 自定义布局
子类化`UICollectionViewLayout`实现自定义布局有两个关键任务需要完成：

- 指定可滚动内容区域的大小。
- 为每个单元格和补充视图提供布局属性对象以便集合视图定位。

#### 理解布局过程
集合视图和自定义布局对象一起工作来管理整体布局过程，当集合视图需要用到布局信息时，它会请求布局对象提供这些布局信息。调用布局对象的`invalidateLayout`方法会告知集合视图显式更新其布局，此方法会废弃现有的布局属性，并强制布局对象生成新的布局属性。

不要将布局对象的`invalidateLayout`方法与集合视图的`reloadData`方法混淆，调用`invalidateLayout`方法不一定会移除当前现有的单元格和子视图，它只会强制布局对象重新计算移动、添加或删除单元格时所需的所有布局信息。如果数据源对象提供的数据发生了更改，则应该调用`reloadData`方法。使用这两种方法来更新布局时，实际的布局过程都是一样的。

在布局过程中，集合视图会始终按顺序来调用布局对象的以下三种方法：

- `- (void)prepareLayout`
- `- (CGSize)collectionViewContentSize`
- `- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect`

集合视图调用布局对象的`prepareLayout`方法，提供机会让我们提前计算确定布局属性信息时所需的数据，从计算出来的数据中要能够得知集合视图整个内容区域的大小。

集合视图调用布局对象的`collectionViewContentSize`方法获得内容大小来适当的配置其滚动视图，我们在这里根据提前计算的数据返回整个内容区域的大小。如果内容大小在垂直和水平方向上都超出当前设备屏幕的边界，则会允许滚动视图同时在这两个方向上滚动，而`UICollectionViewFlowLayout`只能在一个方向上滚动。

集合视图会基于当前的滚动位置调用`layoutAttributesForElementsInRect:`方法来查找在特定区域中的单元格和视图的布局属性，此区域和可视区域可能相同也可能不同，我们在这里遍历提前生成的所有的布局属性信息，检查每个布局信息的frame，返回所有frame和给定rect相交的布局属性，这样核心布局过程就完成了。

![图4-1](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/Art/cv_layout_process_2x.png)

我们可以在`prepareLayout`方法中生成布局属性对象后缓存起来，也可以在`layoutAttributesForElementsInRect:`方法中生成布局属性对象，但是集合视图在滚动过程中会多次调用`layoutAttributesForElementsInRect:`方法，这样就会为视图重复计算布局属性，会有性能损耗。

布局完成后，单元格和视图的布局属性会保持不变。调用布局对象的`invalidateLayout`会废弃当前所有布局信息，然后再次从调用`prepareLayout`方法开始，重复布局过程生成新的布局信息。集合视图在滚动过程中，会不断调用布局对象的`shouldInvalidateLayoutForBoundsChange:`方法来判断是否需要废弃当前布局并重新生成布局。当集合视图的`bounds`属性发生变化时，也会调用`shouldInvalidateLayoutForBoundsChange:`方法。

调用`invalidateLayout`方法后不会立即开始布局更新过程，该方法仅将布局标记为与数据不一致并需要更新。在下一个视图更新周期中，集合视图会检查其布局是否为脏，如果是，则更新布局。也就是说，当我们快速连续地调用`invalidateLayout`方法多次后，不会每次调用都立即更新布局。

#### 创建布局信息对象
官方提供了三种方法来创建`UICollectionViewLayoutAttributes`布局信息对象：

- `+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath`
- `+ (instancetype)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind withIndexPath:(NSIndexPath *)indexPath`
- `+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath`

要根据视图的类型调用对应的方法来生成布局属性对象，因为集合视图会根据布局信息对象的`representedElementCategory`属性从数据源对象中获取对应类型的视图，使用错误的方法生成布局信息对象会导致集合视图在错误的位置创建错误的视图。

生成布局属性对象后，一定要根据前面提前计算的数据设置好`frame`或者`center`和`size`属性，使集合视图能够确定对应的视图的位置和大小。同时，还可以设置`transform`，`alpha`，`hidden`等属性来控制对应视图的视觉效果。如果视图的布局是重叠的，则可以设置`zIndex`属性值来确保视图的顺序一致。如果官方提供`UICollectionViewLayoutAttributes`标准类无法满足需求，可以对其子类化并扩展，以存储和视图外观有关的信息。当对布局属性进行子类化时，需要实现用于比较自定义属性的`isEqual:`方法，因为集合视图对其某些操作使用此方法。

#### 根据需要为单个视图提供布局属性

布局对象还需要能够根据需要为单个视图提供布局属性，因为集合视图会在执行Cell的插入，删除，移动和刷新动画时请求该布局信息。需要覆写下面三种方法：

- `-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath`
- `-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath`
- `-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath`

在三种方法中，需要返回已计算好的对应视图的布局属性信息，返回属性时，不应更改布局属性。如果布局中不包含任何补充视图和装饰视图，则不需要覆写后两种方法。

#### 自定义cell的插入，删除，移动和刷新动画

集合视图调用对应的方法`插入`、`删除`、`刷新`、`移动`cell时，布局对象会调用`invalidateLayout`废弃现有的布局信息，重新执行前面提到的布局过程生成新的布局属性。在集合视图更新前调用`prepareForCollectionViewUpdates:`方法告知要更新的cell在更新前的IndexPath和更新完成后的IndexPath，以及其要执行的更新方式(插入、删除、刷新、移动)，我们需要重写此方法记录这些IndexPath。

之后，集合视图会执行两个动画：更新布局前每个cell被移除的动画和更新布局后每个cell显示的动画，我们看到的动画效果是由这两个动画组合而成的。在执行动画过程中，布局对象会调用`finalLayoutAttributesForDisappearingItemAtIndexPath:`方法获取对应IndexPath的cell被移除时的最终布局属性来执行动画：更新布局前的布局属性值-->cell被移除时的最终布局属性值，调用`initialLayoutAttributesForAppearingItemAtIndexPath:`方法获取对应IndexPath的cell显示时的起始布局属性来执行动画：cell显示时的起始布局属性值-->更新布局后的cell布局属性值。

`插入`、`删除`、`移动`cell时，会导致其周围cell的布局属性发生变化，这些cell会强制执行这个动画：cell更新布局前的frame-->cell更新布局后的frame，这是官方在内部实现的。在重写`finalLayoutAttributesForDisappearingItemAtIndexPath:`和`initialLayoutAttributesForAppearingItemAtIndexPath:`方法设置执行动画用到的布局属性时，最好检查一下传入的IndexPathh与调用`prepareForCollectionViewUpdates:`方法时记录的IndexPath是否一致。

