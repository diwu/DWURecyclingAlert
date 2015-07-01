//
//  ExampleRecycledViewWithDrawRect.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/30/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleRecycledViewWithDrawRect.h"
#import "ExampleImage.h"

@implementation ExampleRecycledViewWithDrawRect

- (void)drawRect:(CGRect)rect {
    for (int i = 0; i < 1000; i++) {
        UIFont* font = [UIFont fontWithName:@"Arial" size:15];
        UIColor* textColor = [UIColor blackColor];
        NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : textColor };
        NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:@"calling" attributes:stringAttrs];
        [attrStr drawAtPoint:CGPointMake(3.f, 10.f)];
        attrStr = [[NSAttributedString alloc] initWithString:@"drawRect:" attributes:stringAttrs];
        [attrStr drawAtPoint:CGPointMake(3.f, 35.f)];
    }
}

@end
