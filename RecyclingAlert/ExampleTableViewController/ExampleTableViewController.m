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
#import "ExampleItemGenerator.h"
#import "ExampleCell.h"
#import "ExampleItem.h"
#import "ExampleHeaderFooterView.h"

static NSString *ExampleCellIdentifier = @"ExampleCellIdentifier";
static NSString *ExampleHeaderFooterViewIdentifier = @"ExampleHeaderFooterViewIdentifier";
static const NSInteger ExampleCellNonRecycledViewTag = NSIntegerMax;

@interface ExampleTableViewController ()

@property (nonatomic, strong) ExampleDelegate *exampleDelegate;

@property (nonatomic, strong) ExampleDataSource *exampleDataSource;

@end

@implementation ExampleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[ExampleCell class] forCellReuseIdentifier:ExampleCellIdentifier];
    [self.tableView registerClass:[ExampleHeaderFooterView class] forHeaderFooterViewReuseIdentifier:ExampleHeaderFooterViewIdentifier];
    self.tableView.showsVerticalScrollIndicator = NO;
    ConfigureExampleCell block = ^(ExampleCell *cell, ExampleItem *item) {
        UIView *view = [cell viewWithTag:ExampleCellNonRecycledViewTag];
        if (view) {
            [view removeFromSuperview];
        }
        if (item.willBeDisplayingNewlyCreatedSubviews) {
            view = [UIView new];
            view.tag = ExampleCellNonRecycledViewTag;
            view.backgroundColor = [UIColor blueColor];
            cell.nonRecycledView = view;
            [cell.contentView addSubview:view];
            cell.recycledImageViewWithNonRecycledImage.image = [ExampleImage nonRecycledImage];
            cell.label1.hidden = NO;
            cell.label2.hidden = NO;
            [cell setNeedsLayout];
        } else {
            cell.recycledImageViewWithNonRecycledImage.image = nil;
            cell.label1.hidden = YES;
            cell.label2.hidden = YES;
        }
        [cell.recycledView setNeedsDisplay];
    };
    self.exampleDelegate = [[ExampleDelegate alloc] initWithItems:[ExampleItemGenerator randomExampleItems] headerFooterViewIdentifier:ExampleHeaderFooterViewIdentifier configureHeaderFooterViewBlock:block];
    self.exampleDataSource = [[ExampleDataSource alloc] initWithItems:[ExampleItemGenerator randomExampleItems] cellIdentifier:ExampleCellIdentifier configureCellBlock:block];
    self.tableView.delegate = self.exampleDelegate;
    self.tableView.dataSource = self.exampleDataSource;
}

@end
