//
//  JCMenuScrollView.h
//  JCMenuView
//
//  Created by Mac-os on 16/3/3.
//  Copyright © 2016年 Mac-os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJCTitleScrollView : UIScrollView
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, weak) UIView *bottomLine;
@property (nonatomic, strong) NSArray<UIButton *> *titleBtns;
- (instancetype)initWithFrame:(CGRect)frame oneTitleSize:(CGSize)size titles:(NSArray *)titles titleBtnClickHandler:(void(^)(UIButton *btn))clickBlock titleButtonConfigureHandler:(void(^)(UIButton *btn, NSUInteger index))configureBlock;
@end
