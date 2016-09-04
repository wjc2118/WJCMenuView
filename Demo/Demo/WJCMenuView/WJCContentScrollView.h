//
//  JCDetailScrollView.h
//  123
//
//  Created by Mac-os on 16/3/7.
//  Copyright © 2016年 Mac-os. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JCContentStyle) {
    JCContentStyleTableView,
    JCContentStyleCollectionView,
    JCContentStyleCustomView,
};

@interface WJCContentScrollView : UIScrollView
@property (nonatomic, strong) NSMutableArray *contentViewsMutArr;
- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count tableViewConfigureHandler:(void(^)(UITableView *tableView, NSUInteger index))block;
- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count flowLayoutConfigureHandler:(void(^)(UICollectionViewFlowLayout *layout, NSUInteger index))flowLayoutBlock collectionViewConfigureHandler:(void(^)(UICollectionView *collectionView, NSUInteger index))collectionViewBlock;
- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count customViewConfigureHandler:(UIView *(^)(NSUInteger index, CGRect frame))block;
- (void)setupContentViewWithIndex:(NSUInteger)index;
@end
