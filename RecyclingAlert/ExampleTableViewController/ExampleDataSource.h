//
//  ExampleDataSource.h
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UITableViewController.h>
#import <UIKit/UICollectionView.h>
#import "ExampleItem.h"

typedef void (^ConfigureExampleCell)(id, ExampleItem *);

@interface ExampleDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

- (instancetype)initWithItems: (NSArray *)itemsArr cellIdentifier: (NSString *)cellIdentifier configureCellBlock: (ConfigureExampleCell)configureExampleCell;

@end
