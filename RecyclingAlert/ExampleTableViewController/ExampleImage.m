//
//  ExampleImage.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/13/15.
//  Copyright © 2015 Di Wu. All rights reserved.
//

#import "ExampleImage.h"

@implementation ExampleImage

+ (UIImage *)imageWithPureColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
