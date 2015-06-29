//
//  ExampleDelegate.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleDelegate.h"
#import "ExampleSimulatedWorkLoad.h"

static const CGFloat ExampleCellFixedHeight = 130.f;

static const CGFloat ExampleHeaderFooterViewFixedHeight = 150.f;

@interface ExampleDelegate ()

@property (nonatomic, copy) NSArray *itemsArr;

@property (nonatomic, copy) NSString *headerFooterViewIdentifier;

@property (nonatomic, copy) ConfigureExampleHeaderFooterView configureExampleHeaderFooterView;

@end

@implementation ExampleDelegate

- (instancetype)initWithItems: (NSArray *)itemsArr headerFooterViewIdentifier: (NSString *)headerFooterViewIdentifier configureHeaderFooterViewBlock: (ConfigureExampleHeaderFooterView)configureExampleHeaderFooterView {
    if ((self = [super init])) {
        self.itemsArr = itemsArr;
        self.headerFooterViewIdentifier = headerFooterViewIdentifier;
        self.configureExampleHeaderFooterView = configureExampleHeaderFooterView;
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ExampleCellFixedHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ExampleHeaderFooterViewFixedHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return ExampleHeaderFooterViewFixedHeight;
}

- (ExampleItem *)itemAtIndexPath: (NSInteger)section {
    return self.itemsArr[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.headerFooterViewIdentifier];
    id item = [self itemAtIndexPath:section];
    self.configureExampleHeaderFooterView(headerFooterView, item);
    [ExampleSimulatedWorkLoad doSimulatedWorkLoad];
    return headerFooterView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.headerFooterViewIdentifier];
    id item = [self itemAtIndexPath:section];
    self.configureExampleHeaderFooterView(headerFooterView, item);
    [ExampleSimulatedWorkLoad doSimulatedWorkLoad];
    return headerFooterView;
}

@end
