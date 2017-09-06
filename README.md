# 关于UICollectionView使用

## 概述

[UICollectionView](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/CollectionViewBasics/CollectionViewBasics.html#//apple_ref/doc/uid/TP40012334-CH2-SW7)是iOS开发中最常用的UI控件之一，我们可以使用它来管理一组有序的不同尺寸的视图，并以可自定制的布局来展示它们。UICollectionView还支持动画，当视图被插入，删除或重新排序时，就会触发动画，动画是支持自定义的。为了更好的使用UICollectionView，我们有必要对其进行深入了解。

## 基础知识
UICollectionView把视图要展现的数据以及数据的排列与视图的布局方式分开来管理。在开发过程中，开发者自行管理视图要展现的数据，而视图的布局呈现则由许多不同的对象来管理。表1-1列出了UIKit中的集合视图类，并根据其在集合视图中的用途进行了划分。
###### 表1-1
| 目的 | 类/协议 | 描述 |
|-----|--------|------|
| 顶层容器和管理者 | UICollectionView UICollectionViewController | UICollectionView定义了显示视图内容的空间，它继承自[UIScrollView](https://developer.apple.com/documentation/uikit/uiscrollview)，能够根据内容的高度来调整其滚动区域。通过从它的layout布局对象那里接收到的布局信息来呈现数据。UICollectionViewController对象提供了一个UICollectionView的视图控制器级管理支持。 |
| 内容管理 | UICollectionViewDataSource协议 UICollectionViewDelegate协议 | DataSource协议是最重要的且必须遵循实现，它创造并管理UICollectionView的视图内容。Delegate协议让你获取视图的信息并自定义视图的行为，这个协议是可选的。|
| 内容视图 | UICollectionReusableView UICollectionViewCell | UICollectionView展示的所有视图都必须是UICollectionReusableView类的实例，该类支持回收复用机制。回收复用视图而不是重新创建，在视图滚动时，能极大提高性能。 UICollectionViewCell对象是用来展示主要数据的可重用视图,该类继承自UICollectionReusableView。|
| 布局 | UICollectionViewLayout UICollectionViewLayoutAttributes UICollectionViewUpdateItem | UICollectionViewLayout的子类被称为布局对象，它负责定义集合视图中的单元格和可重用视图的位置，大小，视觉效果。在布局过程中，布局对象UICollectionViewLayout会创建一个布局属性对象UICollectionViewLayoutAttributes去告诉集合视图在什么位置，用什么效果去展示单元格和可重用视图。当在集合视图中插入，删除，移动数据项时，布局对象会接收到UICollectionViewUpdateItem类的实例，你不需要自行创建该类的实例。|
| 流布局  | UICollectionViewFlowLayout UICollectionViewDelegateFlowLayout协议 |  UICollectionViewFlowLayout类是用于实现网格或其他基于行的布局的具体布局对象。 你可以按照原样使用该类或者配合UICollectionViewDelegateFlowLayout协议一起使用，这样就可以动态自定义布局信息。|
