//
//  JCDetailScrollView.m
//  123
//
//  Created by Mac-os on 16/3/7.
//  Copyright © 2016年 Mac-os. All rights reserved.
//

#import "WJCContentScrollView.h"

@interface WJCContentScrollView ()
@property (nonatomic, copy) void(^tableViewConfigureBlock)(UITableView *tableView, NSUInteger index);
@property (nonatomic, copy) void(^flowLayoutConfigureBlock)(UICollectionViewFlowLayout *layout, NSUInteger index);
@property (nonatomic, copy) void(^collectionViewConfigureBlock)(UICollectionView *collectionView, NSUInteger index);
@property (nonatomic, copy) UIView *(^customViewConfigureBlock)(NSUInteger index, CGRect frame);
@property (nonatomic, assign) JCContentStyle contentStyle;
@end

@implementation WJCContentScrollView {
    NSInteger _count;
}

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count tableViewConfigureHandler:(void (^)(UITableView *, NSUInteger))block {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor lightGrayColor];
        _count = count;
        _contentStyle = JCContentStyleTableView;
        if (block) {
            _tableViewConfigureBlock = block;
        }
        
        [self setupContentViewWithIndex:0];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count flowLayoutConfigureHandler:(void (^)(UICollectionViewFlowLayout *, NSUInteger))flowLayoutBlock collectionViewConfigureHandler:(void (^)(UICollectionView *, NSUInteger))collectionViewBlock {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor lightGrayColor];
        _count = count;
        _contentStyle = JCContentStyleCollectionView;
        if (flowLayoutBlock) {
            _flowLayoutConfigureBlock = flowLayoutBlock;
        }
        if (collectionViewBlock) {
            _collectionViewConfigureBlock = collectionViewBlock;
        }
        
        [self setupContentViewWithIndex:0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count customViewConfigureHandler:(UIView *(^)(NSUInteger, CGRect))block {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor lightGrayColor];
        _count = count;
        _contentStyle = JCContentStyleCustomView;
        if (block) {
            _customViewConfigureBlock = block;
        }
        
        [self setupContentViewWithIndex:0];
        
    }
    return self;
}

- (NSMutableArray *)contentViewsMutArr {
    if (!_contentViewsMutArr) {
        _contentViewsMutArr = [NSMutableArray arrayWithCapacity:_count];
        for (NSInteger i = 0; i < _count; i++) {
            [_contentViewsMutArr addObject:[NSNull null]];
        }
    }
    return _contentViewsMutArr;
}

- (void)setupContentViewWithIndex:(NSUInteger)index {
    if ([self.contentViewsMutArr[index] isEqual:[NSNull null]]) {
        
        CGRect frame = CGRectZero;
        
        if (self.contentStyle == JCContentStyleTableView) {
            UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
            if (self.tableViewConfigureBlock) {
                self.tableViewConfigureBlock(tableView, index);
            }
            [self addSubview:tableView];
            [self.contentViewsMutArr setObject:tableView atIndexedSubscript:index];
        } else if (self.contentStyle == JCContentStyleCollectionView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            if (self.flowLayoutConfigureBlock) {
                self.flowLayoutConfigureBlock(layout, index);
            }
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
            if (self.collectionViewConfigureBlock) {
                self.collectionViewConfigureBlock(collectionView, index);
            }
            [self addSubview:collectionView];
            [self.contentViewsMutArr setObject:collectionView atIndexedSubscript:index];
        } else if (self.contentStyle == JCContentStyleCustomView) {
            if (self.customViewConfigureBlock) {
                UIView *customView = self.customViewConfigureBlock(index, frame);
                [self addSubview:customView];
                [self.contentViewsMutArr setObject:customView atIndexedSubscript:index];
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentSize = CGSizeMake(_count * self.frame.size.width, 0);
    
    for (NSInteger i = 0; i < self.contentViewsMutArr.count; i++) {
        if ([self.contentViewsMutArr[i] isKindOfClass:[UIView class]]) {
            UIView *contentView = self.contentViewsMutArr[i];
            contentView.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
    }
}

@end
