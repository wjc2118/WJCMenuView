//
//  JCMenuScrollView.m
//  JCMenuView
//
//  Created by Mac-os on 16/3/3.
//  Copyright © 2016年 Mac-os. All rights reserved.
//

#import "WJCTitleScrollView.h"

@interface WJCTitleScrollView ()

@property (nonatomic, copy) void(^configureBlock)(UIButton *btn, NSUInteger index);
@property (nonatomic, copy) void(^clickBlock)(UIButton *btn);
@end

@implementation WJCTitleScrollView {
    CGSize _size;
}

- (instancetype)initWithFrame:(CGRect)frame oneTitleSize:(CGSize)size titles:(NSArray *)titles titleBtnClickHandler:(void (^)(UIButton *))clickBlock titleButtonConfigureHandler:(void (^)(UIButton *, NSUInteger))configureBlock {
    if (self = [super initWithFrame:frame]) {
        
        self.contentSize = CGSizeMake(titles.count * size.width, 0);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        if (clickBlock) {
            _clickBlock = [clickBlock copy];
        }
        if (configureBlock) {
            _configureBlock = [configureBlock copy];
        }
        
        _size = size;
        [self setupSubviewsWithTitles:titles];
    }
    return self;
}

- (void)setupSubviewsWithTitles:(NSArray *)titles {
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSUInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        
        !self.configureBlock ?: self.configureBlock(btn, i);
        
        [self addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
        }
        
        [tmpArr addObject:btn];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    self.titleBtns = tmpArr;
}

- (void)btnClick:(UIButton *)btn {
    !self.clickBlock ?: self.clickBlock(btn);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (NSInteger i = 0 ; i < self.titleBtns.count; i++) {
        UIButton *btn = self.titleBtns[i];
        btn.frame = CGRectMake(i * _size.width, 0, _size.width, _size.height);
    }
}

@end
