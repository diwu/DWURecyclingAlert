//
//  DWURecyclingAlert.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UITableViewCell.h>

#define DWU_PROPERTY(propName) NSStringFromSelector(@selector(propName))

// http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
static BOOL duw_replaceMethodWithBlock(Class c, SEL origSEL, SEL newSEL, id block) {
    if ([c instancesRespondToSelector:newSEL]) return YES; // Selector already implemented, skip silently.
    
    Method origMethod = class_getInstanceMethod(c, origSEL);
    
    // Add the new method.
    IMP impl = imp_implementationWithBlock(block);
    if (!class_addMethod(c, newSEL, impl, method_getTypeEncoding(origMethod))) {
        return NO;
    }else {
        Method newMethod = class_getInstanceMethod(c, newSEL);
        
        // If original doesn't implement the method we want to swizzle, create it.
        if (class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(origMethod))) {
            class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(newMethod));
        }else {
            method_exchangeImplementations(origMethod, newMethod);
        }
    }
    return YES;
}

static void dwu_recyclingAlert(UITableViewCell *_self) {
    NSLog(@"Swizzled: %@", _self);
}

#if DEBUG
__attribute__((constructor)) static void DWURecyclingAlert(void) {
    @autoreleasepool {
        for (NSString *selStr in @[DWU_PROPERTY(setNeedsLayout), DWU_PROPERTY(setNeedsDisplay), DWU_PROPERTY(setNeedsDisplayInRect:)]) {
            SEL selector = NSSelectorFromString(selStr);
            SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", selStr]);
            if ([selStr hasSuffix:@":"]) {
                duw_replaceMethodWithBlock(UITableViewCell.class, selector, newSelector, ^(__unsafe_unretained UITableViewCell *_self, CGRect r) {
                    dwu_recyclingAlert(_self);
                    ((void ( *)(id, SEL, CGRect))objc_msgSend)(_self, newSelector, r);
                });
            }else {
                duw_replaceMethodWithBlock(UITableViewCell.class, selector, newSelector, ^(__unsafe_unretained UITableViewCell *_self) {
                    dwu_recyclingAlert(_self);
                    ((void ( *)(id, SEL))objc_msgSend)(_self, newSelector);
                });
            }
        }
    }
}
#endif