//
//  ExampleItemGenerator.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/19/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleItemGenerator.h"
#import "ExampleItem.h"

static const NSInteger ExampleNumberOfItems = 999;

@implementation ExampleItemGenerator

+ (NSArray *)randomExampleItems {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < ExampleNumberOfItems; i++) {
        BOOL willBeDisplayingNewlyCreatedSubviews = (arc4random_uniform(2) == 0);
        ExampleItem *item = [[ExampleItem alloc] initWithIDNumber:arc4random()%4 willBeDisplayingNewlyCreatedSubviews:willBeDisplayingNewlyCreatedSubviews];
        [arr addObject:item];
    }
    return arr;
}

@end
