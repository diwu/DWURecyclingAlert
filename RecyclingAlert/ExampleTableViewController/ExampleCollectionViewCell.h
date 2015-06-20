//
//  ExampleCollectionViewCell.h
//  RecyclingAlert
//
//  Created by Di Wu on 6/19/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExampleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *label;

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong) CALayer *nonRecycledView;

- (void)layoutNonRecycledView: (UIView *)view;

@end
