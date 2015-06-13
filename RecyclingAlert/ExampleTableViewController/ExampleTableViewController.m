//
//  ExampleTableViewController.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleTableViewController.h"
#import "ExampleDataSource.h"
#import "ExampleDelegate.h"
#import "ExampleImage.h"

static const NSInteger ExampleNumberOfItems = 999;
static NSString *ExampleCellIdentifier = @"ExampleCellIdentifier";
static const NSInteger ExampleCellNonRecycledViewTag = NSIntegerMax;

@interface ExampleTableViewController ()

@property (nonatomic, strong) ExampleDelegate *exampleDelegate;

@property (nonatomic, strong) ExampleDataSource *exampleDataSource;

@end

@implementation ExampleTableViewController

- (NSArray *)generateExampleItems {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < ExampleNumberOfItems; i++) {
        BOOL willBeDisplayingNewlyCreatedSubviews = (arc4random_uniform(2) == 0);
        ExampleItem *item = [[ExampleItem alloc] initWithIDNumber:i willBeDisplayingNewlyCreatedSubviews:willBeDisplayingNewlyCreatedSubviews];
        [arr addObject:item];
    }
    return arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[ExampleCell class] forCellReuseIdentifier:ExampleCellIdentifier];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.exampleDelegate = [ExampleDelegate new];
    self.exampleDataSource = [[ExampleDataSource alloc] initWithItems:[self generateExampleItems] cellIdentifier:ExampleCellIdentifier configureCellBlock:^(ExampleCell *cell, ExampleItem *item) {
        UIView *view = [cell viewWithTag:ExampleCellNonRecycledViewTag];
        if (view) {
            [view removeFromSuperview];
        }
        if (item.willBeDisplayingNewlyCreatedSubviews) {
            view = [UIView new];
            view.tag = ExampleCellNonRecycledViewTag;
            view.backgroundColor = [UIColor blueColor];
            [cell.contentView addSubview:view];
            [cell layoutNonRecycledView:view];
            cell.recycledImageViewWithNonRecycledImage.image = [ExampleImage nonRecycledImage];
            cell.label1.hidden = NO;
            cell.label2.hidden = NO;
        } else {
            cell.recycledImageViewWithNonRecycledImage.image = nil;
            cell.label1.hidden = YES;
            cell.label2.hidden = YES;
        }
    }];
    self.tableView.delegate = self.exampleDelegate;
    self.tableView.dataSource = self.exampleDataSource;
}

@end
