//
//  ExampleDataSource.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleDataSource.h"

static const NSInteger ExampleNumberOfSections = 1;

@interface ExampleDataSource ()

@property (nonatomic, copy) NSArray *itemsArr;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) ConfigureExampleCell configureExampleCell;

@end

@implementation ExampleDataSource

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsArr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ExampleNumberOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                              forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    id item = [self itemAtIndexPath:indexPath];
    self.configureExampleCell(cell, item);
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureExampleCell(cell, item);
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 99;
}


@end
