//
//  ExampleDelegate.h
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UITableViewController.h>
#import <UIKit/UICollectionView.h>

@class ExampleItem;

typedef void (^ConfigureExampleHeaderFooterView)(id, ExampleItem *);

@interface ExampleDelegate : NSObject <UITableViewDelegate, UICollectionViewDelegate>

- (instancetype)initWithItems: (NSArray *)itemsArr headerFooterViewIdentifier: (NSString *)cellIdentifier configureHeaderFooterViewBlock: (ConfigureExampleHeaderFooterView)configureExampleCell;

@end
