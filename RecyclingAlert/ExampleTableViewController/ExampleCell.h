//
//  ExampleCell.h
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExampleCell : UITableViewCell

@end

@interface ExampleCell (LayoutSubviews)

@property (nonatomic, strong, readonly) UIImageView *recycledImageViewWithNonRecycledImage;

- (void)layoutRecyledView: (UIView *)view;

- (void)layoutNonRecycledView: (UIView *)view;

- (void)layoutNonRecycledImage: (UIView *)view;

@end
