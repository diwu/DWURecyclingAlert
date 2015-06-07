//
//  UIView+DWURecyclingAlert.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "UIView+DWURecyclingAlert.h"
#import <objc/runtime.h>

#if DEBUG
@implementation UIView (DWURecyclingAlert)

@dynamic dwuRecyclingCount;

- (void)setDwuRecyclingCount:(NSNumber *)number {
    objc_setAssociatedObject(self, @selector(dwuRecyclingCount), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)dwuRecyclingCount {
    return objc_getAssociatedObject(self, @selector(dwuRecyclingCount));
}

@end
#endif
