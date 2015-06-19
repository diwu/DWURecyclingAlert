//
//  ExampleCollectionViewDataSource.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/20/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleCollectionViewDataSource.h"
#import <UIKit/UITableView.h>
#import "ExampleSimulatedWorkLoad.h"

@interface ExampleCollectionViewDataSource ()

@property (nonatomic, copy) NSArray *itemsArr;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) ConfigureExampleCell configureExampleCell;

@end

@implementation ExampleCollectionViewDataSource

- (instancetype)initWithItems: (NSArray *)itemsArr cellIdentifier: (NSString *)cellIdentifier configureCellBlock: (ConfigureExampleCell)configureExampleCell {
    if ((self = [super init])) {
        self.itemsArr = itemsArr;
        self.cellIdentifier = cellIdentifier;
        self.configureExampleCell = configureExampleCell;
    }
    return self;
}

- (ExampleItem *)itemAtIndexPath: (NSIndexPath *)indexPath {
    return self.itemsArr[[indexPath row] + [indexPath section] * 4];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureExampleCell(cell, item);
    [ExampleSimulatedWorkLoad doSimulatedWorkLoad];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 99;
}

@end
