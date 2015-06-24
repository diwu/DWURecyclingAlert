//DWURecyclingAlert.m
//Copyright (c) 2015 Di Wu
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

// Comment out if you want to disable this entire runtime hack
#define DWURecyclingAlertEnabled

#if defined (DEBUG) && defined (DWURecyclingAlertEnabled)

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UITableViewCell.h>
#import <UIKit/UIImage.h>
#import <UIKit/UITableView.h>
#import <UIKit/UILabel.h>
#import <QuartzCore/CALayer.h>
#import <UIKit/UINibLoading.h>
#import <UIKit/UICollectionViewCell.h>
#import <UIKit/UICollectionView.h>

// ------------ UI Configuration ------------
static const CGFloat DWU_BORDER_WIDTH = 5.0;

static const CGFloat DWU_LABEL_HEIGHT = 16.0;

static const CGFloat DWU_LABEL_WIDTH_UITABLEVIEW_CELL = 150.0;

static const CGFloat DWU_LABEL_WIDTH_UICOLLECTIONVIEW_CELL = 50.0;

static const CGFloat DWU_LABEL_FONT_SIZE = 12.0;

static NSString *DWU_LABEL_FORMAT_UITABLEVIEW_CELL = @" Rendering takes %zd ms";

static NSString *DWU_LABEL_FORMAT_UICOLLECTIONVIEW_CELL = @" %zd ms";

#define DWU_BORDER_COLOR [[UIColor redColor] CGColor]

#define DWU_TEXT_LABEL_BACKGROUND_COLOR [UIColor blackColor]

#define DWU_TEXT_LABEL_FONT_COLOR [UIColor whiteColor]
// ------------------------------------------

static const NSInteger DWU_TIME_INTERVAL_LABEL_TAG = NSIntegerMax - 123;

typedef id(^CellForRowAtIndexPathBlock)(__unsafe_unretained UITableView *_self, __unsafe_unretained id arg1, __unsafe_unretained id arg2);

@interface CALayer (DWURecyclingAlert)

@property (nonatomic, assign) NSInteger dwuRecyclingCount;

@end

@implementation CALayer (DWURecyclingAlert)

@dynamic dwuRecyclingCount;

- (void)setDwuRecyclingCount:(NSInteger)dwuRecyclingCount {
    objc_setAssociatedObject(self, @selector(dwuRecyclingCount), @(dwuRecyclingCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)dwuRecyclingCount {
    NSNumber *dwuRecyclingCount = objc_getAssociatedObject(self, _cmd);
    return [dwuRecyclingCount integerValue];
}

@end

// http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
static BOOL dwu_replaceMethodWithBlock(Class c, SEL origSEL, SEL newSEL, id block) {
    if ([c instancesRespondToSelector:newSEL]) {
        return YES;
    }
    Method origMethod = class_getInstanceMethod(c, origSEL);
    IMP impl = imp_implementationWithBlock(block);
    if (!class_addMethod(c, newSEL, impl, method_getTypeEncoding(origMethod))) {
        return NO;
    }else {
        Method newMethod = class_getInstanceMethod(c, newSEL);
        if (class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(origMethod))) {
            class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(newMethod));
        }else {
            method_exchangeImplementations(origMethod, newMethod);
        }
    }
    return YES;
}

static void addRedBorderEffect(CALayer *layer) {
    layer.borderColor = DWU_BORDER_COLOR;
    layer.borderWidth = DWU_BORDER_WIDTH;
}

static void removeRedBorderEffect(CALayer *layer) {
    layer.borderColor = [[UIColor clearColor] CGColor];
    layer.borderWidth = 0.0;
}

static void dwu_recursionHelper2(CALayer *layer) {
    static NSMapTable *cgImageRefDict;
    if (!cgImageRefDict) {
        cgImageRefDict = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn
                                               valueOptions:NSMapTableWeakMemory];
    }
    NSInteger recyclingCount = layer.dwuRecyclingCount;
    SEL imageSelector = NSSelectorFromString(@"image");
    BOOL viewTargetFound = NO;
    BOOL imageTargetFound = NO;
    if ( layer.delegate && [layer.delegate respondsToSelector:imageSelector]) {
        UIImage *image = ((UIImage * ( *)(id, SEL))objc_msgSend)(layer.delegate, imageSelector);
        if (image) {
            NSString *addressString = [NSString stringWithFormat:@"%p", image.CGImage];
            if (![cgImageRefDict objectForKey:addressString]) {
                [cgImageRefDict setObject:layer.delegate forKey:addressString];
                imageTargetFound = YES;
            } else {
                UIView *someLastMarkedView = [cgImageRefDict objectForKey:addressString];
                removeRedBorderEffect(someLastMarkedView.layer);
            }
        }
    } else if (!recyclingCount && layer.superlayer && layer.superlayer.dwuRecyclingCount) {
        viewTargetFound = YES;
    }
    
    if (viewTargetFound || imageTargetFound) {
        addRedBorderEffect(layer);
    } else {
        removeRedBorderEffect(layer);
    }
    for (CALayer *subview in layer.sublayers) {
        dwu_recursionHelper2(subview);
    }
    layer.dwuRecyclingCount++;
}

static CellForRowAtIndexPathBlock generateTimeLabel(SEL targetSelector, CGFloat labelWidth, NSString *timeStringFormat) {
    return ^(__unsafe_unretained UITableView *_self, __unsafe_unretained id arg1, __unsafe_unretained id arg2) {
        NSDate *date = [NSDate date];
        id returnValue = ((id ( *)(id, SEL, id, id))objc_msgSend)(_self, targetSelector, arg1, arg2);
        dwu_recursionHelper2([returnValue layer]);
        NSTimeInterval timeInterval = ceilf(-[date timeIntervalSinceNow] * 1000);
        NSString *timeIntervalString = [NSString stringWithFormat:timeStringFormat, (NSInteger)timeInterval];
        UITableViewCell *cell = (UITableViewCell *)returnValue;
        UILabel *timeIntervalLabel = (UILabel *)[cell viewWithTag:DWU_TIME_INTERVAL_LABEL_TAG];
        if (!timeIntervalLabel) {
            timeIntervalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, DWU_LABEL_HEIGHT)];
            timeIntervalLabel.userInteractionEnabled = NO;
            timeIntervalLabel.backgroundColor = DWU_TEXT_LABEL_BACKGROUND_COLOR;
            timeIntervalLabel.textColor = DWU_TEXT_LABEL_FONT_COLOR;
            timeIntervalLabel.font = [UIFont boldSystemFontOfSize:DWU_LABEL_FONT_SIZE];
            timeIntervalLabel.textAlignment = NSTextAlignmentCenter;
            timeIntervalLabel.adjustsFontSizeToFitWidth = YES;
            timeIntervalLabel.tag = DWU_TIME_INTERVAL_LABEL_TAG;
            timeIntervalLabel.layer.dwuRecyclingCount++;
            [cell addSubview:timeIntervalLabel];
        }
        [cell bringSubviewToFront:timeIntervalLabel];
        timeIntervalLabel.text = timeIntervalString;
        return returnValue;
    };
}

static void generateTimeLabelForUITableViewCell() {
    SEL selector = @selector(setDataSource:);
    NSString *selStr = NSStringFromSelector(selector);
    SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"dwu_uitableview_%@", selStr]);
    dwu_replaceMethodWithBlock(UITableView.class, selector, newSelector, ^(__unsafe_unretained UITableViewCell *_self, __unsafe_unretained id arg) {
        SEL cellForRowSel = @selector(tableView:cellForRowAtIndexPath:);
        NSString *cellForRowSelStr = NSStringFromSelector(cellForRowSel);
        SEL newCellForRowSel = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", cellForRowSelStr]);
        dwu_replaceMethodWithBlock([arg class], cellForRowSel, newCellForRowSel, generateTimeLabel(newCellForRowSel, DWU_LABEL_WIDTH_UITABLEVIEW_CELL, DWU_LABEL_FORMAT_UITABLEVIEW_CELL));
        ((void ( *)(id, SEL, id))objc_msgSend)(_self, newSelector, arg);
    });
}

static void generateTimeLabelForUICollectionViewCell() {
    SEL selector = @selector(setDataSource:);
    NSString *selStr = NSStringFromSelector(selector);
    SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"dwu_uicollectionview_%@", selStr]);
    dwu_replaceMethodWithBlock(UICollectionView.class, selector, newSelector, ^(__unsafe_unretained UICollectionView *_self, __unsafe_unretained id arg) {
        SEL cellForItemSel = @selector(collectionView:cellForItemAtIndexPath:);
        NSString *cellForItemSelStr = NSStringFromSelector(cellForItemSel);
        SEL newCellForItemSel = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", cellForItemSelStr]);
        dwu_replaceMethodWithBlock([arg class], cellForItemSel, newCellForItemSel, generateTimeLabel(newCellForItemSel, DWU_LABEL_WIDTH_UICOLLECTIONVIEW_CELL, DWU_LABEL_FORMAT_UICOLLECTIONVIEW_CELL));
        ((void ( *)(id, SEL, id))objc_msgSend)(_self, newSelector, arg);
    });
}

__attribute__((constructor)) static void DWURecyclingAlert(void) {
    @autoreleasepool {
        generateTimeLabelForUITableViewCell();
        generateTimeLabelForUICollectionViewCell();
    }
}
#endif