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
#import <UIKit/UICollectionViewFlowLayout.h>
#import "ExampleCollectionViewHeaderFooterViewCollectionReusableView.h"

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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *) kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ExampleCollectionViewHeaderFooterViewCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:ExampleCollectionViewHeaderFooterViewCollectionReusableViewHeaderIdentifier forIndexPath:indexPath];
        reusableview = headerView;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        ExampleCollectionViewHeaderFooterViewCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ExampleCollectionViewHeaderFooterViewCollectionReusableViewFooterIdentifier forIndexPath:indexPath];
        reusableview = footerview;
    }
    id item = [self itemAtIndexPath:indexPath];
    self.configureExampleCell(reusableview, item);
    [ExampleSimulatedWorkLoad doSimulatedWorkLoad];
    return reusableview;
}

@end
