//
//  ViewController.m
//  Demo
//
//  Created by wjc2118 on 16/9/3.
//  Copyright © 2016年 wjc2118. All rights reserved.
//

#import "ViewController.h"
#import "WJCMenuView.h"

#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define kRandomColor kColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) WJCMenuView *menu;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) welf = self;
    WJCMenuView *menu = [WJCMenuView tableViewWithFrame:self.menu.frame = CGRectMake(0, 40, self.view.frame.size.width, 500) oneTitleSize:CGSizeMake(100, 30) titles:@[@"A", @"BB", @"CCC", @"DDDD", @"5", @"6", @"7", @"8", @"9", @"10", ] showBottomLine:YES titleButtonConfigureHandler:^(UIButton *titleButton, NSUInteger index) {
        titleButton.backgroundColor = kRandomColor;
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleButton.backgroundColor = [UIColor redColor];
    } tableViewConfigureHandler:^(UITableView *tableView, NSUInteger index) {
        __strong typeof(welf) self = welf;
        tableView.dataSource = self;
        tableView.delegate = self;
    }];
    
    [self.view addSubview:menu];
    self.menu = menu;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.menu.frame = CGRectMake(0, 40, self.view.frame.size.width, 500);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger index = [self.menu indexOfContentView:tableView];
    return index + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self.menu indexOfContentView:tableView];
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.text = [NSString stringWithFormat:@"%zd",index];
    }
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}


@end
