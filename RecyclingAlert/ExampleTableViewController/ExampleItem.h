//
//  ExampleItems.h
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExampleItem : NSObject

@property (nonatomic, assign, readonly) BOOL willBeDisplayingNewlyCreatedSubviews;

- (instancetype)initWithIDNumber: (NSInteger)idNumber willBeDisplayingNewlyCreatedSubviews: (BOOL)willBeUsingRecycledSubviews;

@end
