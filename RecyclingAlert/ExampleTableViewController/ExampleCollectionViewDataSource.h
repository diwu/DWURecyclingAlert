//
//  ExampleCollectionViewDataSource.h
//  RecyclingAlert
//
//  Created by Di Wu on 6/20/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExampleItem.h"
#import <UIKit/UICollectionView.h>

typedef void (^ConfigureExampleCell)(id, ExampleItem *);

@interface ExampleCollectionViewDataSource : NSObject <UICollectionViewDataSource>

- (instancetype)initWithItems: (NSArray *)itemsArr cellIdentifier: (NSString *)cellIdentifier configureCellBlock: (ConfigureExampleCell)configureExampleCell;

@end
