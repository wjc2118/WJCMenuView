//
//  JCMenuView.m
//  JCMenuView
//
//  Created by Mac-os on 16/3/3.
//  Copyright © 2016年 Mac-os. All rights reserved.
//

#import "WJCMenuView.h"
#import "WJCTitleScrollView.h"
#import "WJCContentScrollView.h"

static const CGFloat Bottom_Line_Height = 2;

@interface WJCMenuView () <UIScrollViewDelegate>
@property (nonatomic, weak) WJCTitleScrollView *titleScrollView;
@property (nonatomic, weak) WJCContentScrollView *contentScrollView;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, weak) UIView *bottomLine;

@property (nonatomic, copy) void(^titleButtonBlock)(UIButton *titleButton, NSUInteger index);

@property (nonatomic, copy) void(^tableViewBlock)(UITableView *tableView, NSUInteger index) ;

@property (nonatomic, copy) void(^flowLayoutBlock)(UICollectionViewFlowLayout *Layout, NSUInteger index) ;
@property (nonatomic, copy) void(^collectionViewBlock)(UICollectionView *collectionView, NSUInteger index) ;

@property (nonatomic, copy) UIView *(^customViewBlock)(NSUInteger index, CGRect frame) ;

@property (nonatomic, assign) JCContentStyle contentStyle;

///保存所有tableView / collectionView的数组
@property (nonatomic, strong) NSArray<__kindof UIView *> *contentViewsArr;
///存放标题栏按钮的数组
@property (nonatomic, strong) NSArray<UIButton *> *titleBtnsArr;

//@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign, getter=isCurrentIndex) BOOL currentIndex;
@property (nonatomic, assign) CGFloat detlaWidth;
@property (nonatomic, assign) CGFloat currentWidth;

@end

@implementation WJCMenuView {
    CGSize _titleSize;
    NSInteger _contentCount;
    
}

#pragma mark - lazy

- (NSArray<UIButton *> *)titleBtnsArr {
    if (!_titleBtnsArr) {
        _titleBtnsArr = [NSArray array];
    }
    return _titleBtnsArr;
}

- (NSArray<UIView *> *)contentViewsArr {
    if (!_contentViewsArr) {
        _contentViewsArr = [NSArray array];
    }
    return _contentViewsArr;
}

#pragma mark - Table View

+ (instancetype)tableViewWithFrame:(CGRect)frame oneTitleSize:(CGSize)size titles:(NSArray *)titles showBottomLine:(BOOL)show titleButtonConfigureHandler:(void (^)(UIButton *, NSUInteger))titleButtonConfigureBlock tableViewConfigureHandler:(void (^)(UITableView *, NSUInteger))tableViewConfigureBlock {
    return [[self alloc] initWithFrame:frame oneTitleSize:size titles:titles showBottomLine:show titleButtonConfigure:titleButtonConfigureBlock tableViewConfigure:tableViewConfigureBlock];
}

- (instancetype)initWithFrame:(CGRect)frame oneTitleSize:(CGSize)size titles:(NSArray *)titles showBottomLine:(BOOL)show titleButtonConfigure:(void(^)(UIButton *titleButton, NSUInteger index))titleButtonBlock tableViewConfigure:(void(^)(UITableView *tableView, NSUInteger index))tableViewBlock {
    if (self = [super initWithFrame:frame]) {
//        if (size.width * titles.count < self.width) {
//            size.width = self.width / titles.count;
        //        }
        _titleSize = size;
        _contentCount = titles.count;
        _contentStyle = JCContentStyleTableView;
        
        if (titleButtonBlock) {
            _titleButtonBlock = titleButtonBlock;
        }
        if (tableViewBlock) {
            _tableViewBlock = tableViewBlock;
        }
        [self setupTitleScrollViewWithTitles:titles];
        [self setupContentScrollView];
        
        if (show) {
            [self setupBottomLine];
        }
        
    }
    return self;
}

#pragma mark - Collection View

+ (instancetype)collectionViewWithFrame:(CGRect)frame oneTitleSize:(CGSize)size titles:(NSArray *)titles showBottomLine:(BOOL)show titleButtonConfigureHandler:(void (^)(UIButton *, NSUInteger))titleButtonConfigureBlock flowLayoutConfigureHandler:(void (^)(UICollectionViewFlowLayout *, NSUInteger))flowLayoutConfigureBlock collectionViewConfigureHandler:(void (^)(UICollectionView *, NSUInteger))collectionViewConfigureBlock {
    return [[self alloc] initWithFrame:frame oneTitleSize:size titles:titles showBottomLine:show titleButtonConfigure:titleButtonConfigureBlock flowLayoutConfigure:flowLayoutConfigureBlock collectionViewConfigure:collectionViewConfigureBlock];
}

- (instancetype)initWithFrame:(CGRect)frame oneTitleSize:(CGSize)size titles:(NSArray *)titles showBottomLine:(BOOL)show titleButtonConfigure:(void(^)(UIButton *titleButton, NSUInteger index))titleButtonBlock flowLayoutConfigure:(void(^)(UICollectionViewFlowLayout *Layout, NSUInteger index))flowLayoutBlock collectionViewConfigure:(void(^)(UICollectionView *collectionView, NSUInteger index))collectionViewBlock {
    if (self = [super initWithFrame:frame]) {
        _titleSize = size;
        _contentCount = titles.count;
        _contentStyle = JCContentStyleCollectionView;
        
        if (titleButtonBlock) {
            _titleButtonBlock = titleButtonBlock;
        }
        if (flowLayoutBlock) {
            _flowLayoutBlock = flowLayoutBlock;
        }
        if (collectionViewBlock) {
            _collectionViewBlock = collectionViewBlock;
        }
        [self setupTitleScrollViewWithTitles:titles];
        [self setupContentScrollView];
        
        if (show) {
            [self setupBottomLine];
        }
        
    }
    return self;
}

#pragma mark - Custom View

+ (instancetype)customViewWithFrame:(CGRect)frame oneTitleSize:(CGSize)size titles:(NSArray *)titles showBottomLine:(BOOL)show titleButtonConfigureHandler:(void (^)(UIButton *, NSUInteger))titleButtonConfigureBlock customViewConfigureHandler:(UIView *(^)(NSUInteger, CGRect))customViewConfigureBlock {
    return [[self alloc] initWithFrame:frame oneTitleSize:size titles:titles showBottomLine:show titleButtonConfigure:titleButtonConfigureBlock customViewConfigure:customViewConfigureBlock];
}

- (instancetype)initWithFrame:(CGRect)frame oneTitleSize:(CGSize)size titles:(NSArray *)titles showBottomLine:(BOOL)show titleButtonConfigure:(void(^)(UIButton *titleButton, NSUInteger index))titleButtonBlock customViewConfigure:(UIView *(^)(NSUInteger index, CGRect frame))customViewBlock {
    if (self = [super initWithFrame:frame]) {
        _titleSize = size;
        _contentCount = titles.count;
        _contentStyle = JCContentStyleCustomView;
        
        if (titleButtonBlock) {
            _titleButtonBlock = titleButtonBlock;
        }
        if (customViewBlock) {
            _customViewBlock = customViewBlock;
        }
        [self setupTitleScrollViewWithTitles:titles];
        [self setupContentScrollView];
        
        if (show) {
            [self setupBottomLine];
        }
        
    }
    return self;
}

#pragma mark - public method

- (NSInteger)indexOfContentView:(UIView *)contentView {
    return [self.contentViewsArr indexOfObject:contentView];
}

#pragma mark - Title Scroll View

- (void)setupTitleScrollViewWithTitles:(NSArray *)titles {
    
    __weak __typeof__ (self) welf = self;
    WJCTitleScrollView *titleScrollView = [[WJCTitleScrollView alloc] initWithFrame:CGRectZero oneTitleSize:_titleSize titles:titles titleBtnClickHandler:^(UIButton *btn) {
        __strong __typeof__ (welf) self = welf;
        CGFloat offsetX = (btn.frame.origin.x / btn.frame.size.width) * self.contentScrollView.frame.size.width;
        [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0.0) animated:YES];
    } titleButtonConfigureHandler:^(UIButton *btn, NSUInteger index) {
        __strong __typeof__ (welf) self = welf;
        !self.titleButtonBlock ?: self.titleButtonBlock(btn, index);
    }];
    
    
    [self addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
    self.titleBtnsArr = titleScrollView.titleBtns;
    self.selectedBtn = titleScrollView.selectedBtn;
}

- (void)adjustTitleScrollView {
    
    if (self.selectedBtn.center.x < self.titleScrollView.center.x) {//left
        self.titleScrollView.contentOffset = CGPointZero;
    } else if (self.titleScrollView.contentSize.width - self.selectedBtn.center.x < self.titleScrollView.frame.size.width/2) {//right
        self.titleScrollView.contentOffset = CGPointMake(self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width, 0.f);
    } else {//middle
        self.titleScrollView.contentOffset = CGPointMake(self.selectedBtn.center.x - self.titleScrollView.center.x, 0.f);
    }
}

#pragma mark - Content Scroll View

- (void)setupContentScrollView {
    
    WJCContentScrollView *contentScrollView;
    __weak __typeof__ (self) welf = self;
    
    if (self.contentStyle == JCContentStyleTableView) {
        contentScrollView = [[WJCContentScrollView alloc] initWithFrame:CGRectZero count:_contentCount tableViewConfigureHandler:^(UITableView *tableView, NSUInteger index) {
            __strong __typeof__ (welf) self = welf;
            !self.tableViewBlock ?: self.tableViewBlock(tableView, index);
        }];
    } else if (self.contentStyle == JCContentStyleCollectionView) {
        contentScrollView = [[WJCContentScrollView alloc] initWithFrame:CGRectZero count:_contentCount flowLayoutConfigureHandler:^(UICollectionViewFlowLayout *layout, NSUInteger index) {
            __strong __typeof__ (welf) self = welf;
            !self.flowLayoutBlock ?: self.flowLayoutBlock(layout, index);
        } collectionViewConfigureHandler:^(UICollectionView *collectionView, NSUInteger index) {
            __strong __typeof__ (welf) self = welf;
            !self.collectionViewBlock ?: self.collectionViewBlock(collectionView, index);
        }];
    } else if (self.contentStyle == JCContentStyleCustomView) {
        contentScrollView = [[WJCContentScrollView alloc] initWithFrame:CGRectZero count:_contentCount customViewConfigureHandler:^UIView *(NSUInteger index, CGRect frame) {
            __strong __typeof__ (welf) self = welf;
//            if (self.customViewBlock) {
//                return self.customViewBlock(index, frame);
//            } else {
//                return nil;
//            }
            return self.customViewBlock ? self.customViewBlock(index, frame) : nil;
        }];
    }
    
    self.contentViewsArr = contentScrollView.contentViewsMutArr;
    contentScrollView.delegate = self;
    [self addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;

}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.selectedBtn.selected = NO;
    self.selectedBtn = self.titleBtnsArr[index];
    self.selectedBtn.selected = YES;
    
    [self adjustTitleScrollView];
    
    if (self.contentScrollView.subviews.count < _contentCount) {
        [self.contentScrollView setupContentViewWithIndex:index];
    }
    
    [self adjustBottomLine];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint center = self.bottomLine.center;
    center.x = _titleSize.width / 2 + scrollView.contentOffset.x / scrollView.frame.size.width * _titleSize.width;
    self.bottomLine.center = center;
    
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if (self.isCurrentIndex) {
        
        UIButton *currentBtn = self.titleBtnsArr[index];
        NSString *currentTitle = [currentBtn titleForState:UIControlStateSelected];
        CGSize currentSize = [currentTitle sizeWithAttributes:@{NSFontAttributeName:currentBtn.titleLabel.font}];
        self.currentWidth = currentSize.width;
        
        UIButton *nextBtn = self.titleBtnsArr[index + 1 == self.titleBtnsArr.count ? index : index + 1];
        NSString *nextTitle = [nextBtn titleForState:UIControlStateSelected];
        CGSize nextSize = [nextTitle sizeWithAttributes:@{NSFontAttributeName:nextBtn.titleLabel.font}];
        self.detlaWidth = nextSize.width - currentSize.width;
        
        self.currentIndex = NO;
    }
    
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width - index;//0-1
    if (scale != 0) {
        CGRect frame = self.bottomLine.frame;
        frame.size.width = self.currentWidth + self.detlaWidth * scale;
        self.bottomLine.frame = frame;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.currentIndex = YES;
}

#pragma mark - Bottom Line

- (void)setupBottomLine {
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [self.selectedBtn titleColorForState:UIControlStateSelected];
    [self.titleScrollView addSubview:bottomLine];
    self.bottomLine = bottomLine;
}

- (void)adjustBottomLine {
    NSString *title = [self.selectedBtn titleForState:UIControlStateSelected];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:self.selectedBtn.titleLabel.font}];
    self.bottomLine.backgroundColor = [self.selectedBtn titleColorForState:UIControlStateSelected];
    
    self.bottomLine.frame = CGRectMake(CGRectGetMinX(self.selectedBtn.frame) + (CGRectGetWidth(self.selectedBtn.frame) - size.width) / 2, CGRectGetHeight(self.titleScrollView.frame) - Bottom_Line_Height, size.width, Bottom_Line_Height);
}

#pragma mark - protected method

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    CGFloat titleScrollWidth = _titleSize.width * _contentCount > self.frame.size.width ? self.frame.size.width : _titleSize.width * _contentCount;
    self.titleScrollView.frame = CGRectMake((self.frame.size.width - titleScrollWidth) / 2, 0, titleScrollWidth, _titleSize.height);
    
    self.contentScrollView.frame = CGRectMake(0, _titleSize.height, self.frame.size.width, self.frame.size.height - _titleSize.height);
    
    NSInteger index = [self.titleBtnsArr indexOfObject:self.selectedBtn];
    self.contentScrollView.contentOffset = CGPointMake(self.contentScrollView.frame.size.width * index, 0);
    
    [self adjustBottomLine];
    
    [self adjustTitleScrollView];
}

@end








