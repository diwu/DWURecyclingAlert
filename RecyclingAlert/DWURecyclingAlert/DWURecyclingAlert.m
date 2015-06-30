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

static char DWU_CALAYER_ASSOCIATED_OBJECT_KEY;

static char DWU_UIVIEW_TABLEVIEW_CELL_DELEGATE_ASSOCIATED_OBJECT_KEY;

static char DWU_UIVIEW_COLLECTIONVIEW_CELL_DELEGATE_ASSOCIATED_OBJECT_KEY;

typedef id(^CellForRowAtIndexPathBlock)(__unsafe_unretained UITableView *_self, __unsafe_unretained id arg1, __unsafe_unretained id arg2);

#pragma mark - Category

@interface UIView (DWURecyclingAlert)

@property (nonatomic, unsafe_unretained) UITableViewCell *dwuUiTableViewCellDelegate;

@property (nonatomic, unsafe_unretained) UICollectionViewCell *dwuUiCollectionViewCellDelegate;

@end

@implementation UIView (DWURecyclingAlert)

- (void)setDwuUiTableViewCellDelegate:(UITableViewCell *)delegate {
    objc_setAssociatedObject(self, &DWU_UIVIEW_TABLEVIEW_CELL_DELEGATE_ASSOCIATED_OBJECT_KEY, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (UITableViewCell *)dwuUiTableViewCellDelegate {
    UITableViewCell *delegate = objc_getAssociatedObject(self, &DWU_UIVIEW_TABLEVIEW_CELL_DELEGATE_ASSOCIATED_OBJECT_KEY);
    return delegate;
}

- (void)setDwuUiCollectionViewCellDelegate:(UICollectionViewCell *)delegate {
    objc_setAssociatedObject(self, &DWU_UIVIEW_COLLECTIONVIEW_CELL_DELEGATE_ASSOCIATED_OBJECT_KEY, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (UICollectionViewCell *)dwuUiCollectionViewCellDelegate {
    UICollectionViewCell *delegate = objc_getAssociatedObject(self, &DWU_UIVIEW_COLLECTIONVIEW_CELL_DELEGATE_ASSOCIATED_OBJECT_KEY);
    return delegate;
}

@end

@interface CALayer (DWURecyclingAlert)

@property (nonatomic, assign) NSInteger dwuRecyclingCount;

@end

@implementation CALayer (DWURecyclingAlert)

- (void)setDwuRecyclingCount:(NSInteger)recyclingCount {
    objc_setAssociatedObject(self, &DWU_CALAYER_ASSOCIATED_OBJECT_KEY, @(recyclingCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)dwuRecyclingCount {
    NSNumber *recyclingCountNumber = objc_getAssociatedObject(self, &DWU_CALAYER_ASSOCIATED_OBJECT_KEY);
    return [recyclingCountNumber integerValue];
}

- (void)dwu_addRedBorderEffect {
    self.borderColor = DWU_BORDER_COLOR;
    self.borderWidth = DWU_BORDER_WIDTH;
}

- (void)dwu_removeRedBorderEffect {
    self.borderColor = [[UIColor clearColor] CGColor];
    self.borderWidth = 0.0;
}

- (void)dwu_scanLayerHierarchyRecursively {
    static NSMapTable *cgImageRefDict;
    if (!cgImageRefDict) {
        cgImageRefDict = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn
                                               valueOptions:NSMapTableWeakMemory];
    }
    NSInteger recyclingCount = self.dwuRecyclingCount;
    SEL imageSelector = @selector(image);
    BOOL viewTargetFound = NO;
    BOOL imageTargetFound = NO;
    if ( self.delegate && [self.delegate respondsToSelector:imageSelector]) {
        UIImage *image = ((UIImage * ( *)(id, SEL))objc_msgSend)(self.delegate, imageSelector);
        if (image) {
            NSString *addressString = [NSString stringWithFormat:@"%p", image.CGImage];
            if (![cgImageRefDict objectForKey:addressString]) {
                [cgImageRefDict setObject:self.delegate forKey:addressString];
                imageTargetFound = YES;
            } else {
                UIView *someLastMarkedView = [cgImageRefDict objectForKey:addressString];
                [someLastMarkedView.layer dwu_removeRedBorderEffect];
            }
        }
    } else if (!recyclingCount && self.superlayer && self.superlayer.dwuRecyclingCount) {
        viewTargetFound = YES;
    }
    
    if (viewTargetFound || imageTargetFound) {
        [self dwu_addRedBorderEffect];
    } else {
        [self dwu_removeRedBorderEffect];
    }
    for (CALayer *sublayer in self.sublayers) {
        UITableViewCell *uiTableViewCellDelegate = [self dwu_findDwuUiTableViewCellDelegate];
        UICollectionViewCell *uiCollectionViewCellDelegate = [self dwu_findDwuUiCollectionViewCellDelegate];
        [self dwu_injectLayer:sublayer withUITableViewCellDelegate:uiTableViewCellDelegate withUICollectionViewCellDelegate:uiCollectionViewCellDelegate];
        [sublayer dwu_scanLayerHierarchyRecursively];
    }
    self.dwuRecyclingCount++;
}

- (UITableViewCell *)dwu_findDwuUiTableViewCellDelegate {
    UIView *containerView = self.delegate;
    if (!containerView) {
        return nil;
    }
    if (![containerView isKindOfClass:[UIView class]]) {
        return nil;
    }
    if (containerView.dwuUiTableViewCellDelegate) {
        return containerView.dwuUiTableViewCellDelegate;
    } else if ([containerView isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)containerView;
    } else {
        return nil;
    }
}

- (UICollectionViewCell *)dwu_findDwuUiCollectionViewCellDelegate {
    UIView *containerView = self.delegate;
    if (!containerView) {
        return nil;
    }
    if (![containerView isKindOfClass:[UIView class]]) {
        return nil;
    }
    if (containerView.dwuUiCollectionViewCellDelegate) {
        return containerView.dwuUiCollectionViewCellDelegate;
    } else if ([containerView isKindOfClass:[UICollectionViewCell class]]) {
        return (UICollectionViewCell *)containerView;
    } else {
        return nil;
    }
}

- (void)dwu_injectLayer: (CALayer *)layer withUITableViewCellDelegate:(UITableViewCell *)uitableViewCellDelegate withUICollectionViewCellDelegate: (UICollectionViewCell *)uiCollectionViewCellDelegate {
    if (layer.delegate && [layer.delegate isKindOfClass:[UIView class]]) {
        UIView *containerView = layer.delegate;
        if (uitableViewCellDelegate) {
            containerView.dwuUiTableViewCellDelegate = uitableViewCellDelegate;
        } else if (uiCollectionViewCellDelegate) {
            containerView.dwuUiCollectionViewCellDelegate = uiCollectionViewCellDelegate;
        }
    }
}

@end

#pragma mark - swizzling method from block

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

#pragma mark - generate for UITableViewCell / UICollectionViewCell labels

static CellForRowAtIndexPathBlock dwu_generateTimeLabel(SEL targetSelector, CGFloat labelWidth, NSString *timeStringFormat) {
    return ^(__unsafe_unretained UITableView *_self, __unsafe_unretained id arg1, __unsafe_unretained id arg2) {
        NSDate *date = [NSDate date];
        UIView *returnView = ((UIView * ( *)(id, SEL, id, id))objc_msgSend)(_self, targetSelector, arg1, arg2);
        NSTimeInterval timeInterval = ceilf(-[date timeIntervalSinceNow] * 1000);
        [[returnView layer] dwu_scanLayerHierarchyRecursively];
        NSString *timeIntervalString = [NSString stringWithFormat:timeStringFormat, (NSInteger)timeInterval];
        UILabel *timeIntervalLabel = (UILabel *)[returnView viewWithTag:DWU_TIME_INTERVAL_LABEL_TAG];
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
            [returnView addSubview:timeIntervalLabel];
        }
        [returnView bringSubviewToFront:timeIntervalLabel];
        timeIntervalLabel.text = timeIntervalString;
        return returnView;
    };
}

static void dwu_generateTimeLabelForUITableViewHeaderFooterView() {
    SEL selector = @selector(setDelegate:);
    NSString *selStr = NSStringFromSelector(selector);
    SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"dwu_uitableview_headerfooter_%@", selStr]);
    dwu_replaceMethodWithBlock(UITableView.class, selector, newSelector, ^(__unsafe_unretained UITableView *_self, __unsafe_unretained id arg) {
        SEL viewForHeaderInSectionSel = @selector(tableView:viewForHeaderInSection:);
        if ([arg respondsToSelector:viewForHeaderInSectionSel]) {
            NSString *viewForSectionSelSelStr = NSStringFromSelector(viewForHeaderInSectionSel);
            SEL newViewForSectionSel = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", viewForSectionSelSelStr]);
            dwu_replaceMethodWithBlock([arg class], viewForHeaderInSectionSel, newViewForSectionSel, dwu_generateTimeLabel(newViewForSectionSel, DWU_LABEL_WIDTH_UITABLEVIEW_CELL, DWU_LABEL_FORMAT_UITABLEVIEW_CELL));
        }
        SEL viewForFooterInSectionSel = @selector(tableView:viewForFooterInSection:);
        if ([arg respondsToSelector:viewForFooterInSectionSel]) {
            NSString *viewForSectionSelSelStr = NSStringFromSelector(viewForFooterInSectionSel);
            SEL newViewForSectionSel = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", viewForSectionSelSelStr]);
            dwu_replaceMethodWithBlock([arg class], viewForFooterInSectionSel, newViewForSectionSel, dwu_generateTimeLabel(newViewForSectionSel, DWU_LABEL_WIDTH_UITABLEVIEW_CELL, DWU_LABEL_FORMAT_UITABLEVIEW_CELL));
        }
        ((void ( *)(id, SEL, id))objc_msgSend)(_self, newSelector, arg);
    });
}

static void dwu_generateTimeLabelForUITableViewCell() {
    SEL selector = @selector(setDataSource:);
    NSString *selStr = NSStringFromSelector(selector);
    SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"dwu_uitableview_%@", selStr]);
    dwu_replaceMethodWithBlock(UITableView.class, selector, newSelector, ^(__unsafe_unretained UITableView *_self, __unsafe_unretained id arg) {
        SEL cellForRowSel = @selector(tableView:cellForRowAtIndexPath:);
        NSString *cellForRowSelStr = NSStringFromSelector(cellForRowSel);
        SEL newCellForRowSel = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", cellForRowSelStr]);
        dwu_replaceMethodWithBlock([arg class], cellForRowSel, newCellForRowSel, dwu_generateTimeLabel(newCellForRowSel, DWU_LABEL_WIDTH_UITABLEVIEW_CELL, DWU_LABEL_FORMAT_UITABLEVIEW_CELL));
        ((void ( *)(id, SEL, id))objc_msgSend)(_self, newSelector, arg);
    });
}

static void dwu_generateTimeLabelForUICollectionViewCell() {
    SEL selector = @selector(setDataSource:);
    NSString *selStr = NSStringFromSelector(selector);
    SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"dwu_uicollectionview_%@", selStr]);
    dwu_replaceMethodWithBlock(UICollectionView.class, selector, newSelector, ^(__unsafe_unretained UICollectionView *_self, __unsafe_unretained id arg) {
        SEL cellForItemSel = @selector(collectionView:cellForItemAtIndexPath:);
        NSString *cellForItemSelStr = NSStringFromSelector(cellForItemSel);
        SEL newCellForItemSel = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", cellForItemSelStr]);
        dwu_replaceMethodWithBlock([arg class], cellForItemSel, newCellForItemSel, dwu_generateTimeLabel(newCellForItemSel, DWU_LABEL_WIDTH_UICOLLECTIONVIEW_CELL, DWU_LABEL_FORMAT_UICOLLECTIONVIEW_CELL));
        ((void ( *)(id, SEL, id))objc_msgSend)(_self, newSelector, arg);
    });
}

__attribute__((constructor)) static void DWURecyclingAlert(void) {
    @autoreleasepool {
        dwu_generateTimeLabelForUITableViewCell();
        dwu_generateTimeLabelForUITableViewHeaderFooterView();
        dwu_generateTimeLabelForUICollectionViewCell();
    }
}
#endif