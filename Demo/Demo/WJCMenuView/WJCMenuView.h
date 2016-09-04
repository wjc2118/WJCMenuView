//
//  JCMenuView.h
//  JCMenuView
//
//  Created by Mac-os on 16/3/3.
//  Copyright © 2016年 Mac-os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJCMenuView : UIView

+ (instancetype)tableViewWithFrame:(CGRect)frame oneTitleSize:(CGSize)size titles:(NSArray *)titles showBottomLine:(BOOL)show titleButtonConfigureHandler:(void(^)(UIButton *titleButton, NSUInteger index))titleButtonConfigureBlock tableViewConfigureHandler:(void(^)(UITableView *tableView, NSUInteger index))tableViewConfigureBlock;

+ (instancetype)collectionViewWithFrame:(CGRect)frame oneTitleSize:(CGSize)size titles:(NSArray *)titles showBottomLine:(BOOL)show titleButtonConfigureHandler:(void(^)(UIButton *titleButton, NSUInteger index))titleButtonConfigureBlock flowLayoutConfigureHandler:(void(^)(UICollectionViewFlowLayout *Layout, NSUInteger index))flowLayoutConfigureBlock collectionViewConfigureHandler:(void(^)(UICollectionView *collectionView, NSUInteger index))collectionViewConfigureBlock;

+ (instancetype)customViewWithFrame:(CGRect)frame oneTitleSize:(CGSize)size titles:(NSArray *)titles showBottomLine:(BOOL)show titleButtonConfigureHandler:(void(^)(UIButton *titleButton, NSUInteger index))titleButtonConfigureBlock customViewConfigureHandler:(UIView *(^)(NSUInteger index, CGRect frame))customViewConfigureBlock;

- (NSInteger)indexOfContentView:(UIView *)contentView;

@end
