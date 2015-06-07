//
//  ExampleItems.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleItem.h"

@interface ExampleItem ()

@property (nonatomic, assign, readwrite) NSInteger idNumber;

@property (nonatomic, assign, readwrite) BOOL willBeDisplayingNewlyCreatedSubviews;

@end

@implementation ExampleItem

- (instancetype)initWithIDNumber: (NSInteger)idNumber willBeDisplayingNewlyCreatedSubviews: (BOOL)willBeDisplayingNewlyCreatedSubviews {
    if ((self = [super init])) {
        self.idNumber = idNumber;
        self.willBeDisplayingNewlyCreatedSubviews = willBeDisplayingNewlyCreatedSubviews;
    }
    return self;
}

@end
