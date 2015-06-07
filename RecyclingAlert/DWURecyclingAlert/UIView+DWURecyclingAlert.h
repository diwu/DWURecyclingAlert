//
//  UIView+DWURecyclingAlert.h
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import <UIKit/UIView.h>

#if DEBUG
@interface UIView (DWURecyclingAlert)

@property (nonatomic, strong) NSNumber *dwuRecyclingCount;

@end
#endif