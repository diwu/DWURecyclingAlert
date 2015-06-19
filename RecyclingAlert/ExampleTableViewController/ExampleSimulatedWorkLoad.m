//
//  ExampleSimulatedWorkLoad.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/20/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleSimulatedWorkLoad.h"

@implementation ExampleSimulatedWorkLoad

+ (void)doSimulatedWorkLoad {
    float sleepTime = (float)(arc4random() % 20);
    sleepTime = sleepTime / 1000.0;
    [NSThread sleepForTimeInterval:sleepTime];
}

@end
