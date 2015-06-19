//
//  ExampleImage.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/13/15.
//  Copyright © 2015 Di Wu. All rights reserved.
//

#import "ExampleImage.h"

@implementation ExampleImage

+ (UIImage *)recycledImage {
    return [UIImage imageNamed:@"apple_logo"];
}

+ (UIImage *)nonRecycledImage {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"android@3x" ofType:@"png"];
    return [UIImage imageWithContentsOfFile:filePath];
}

@end
