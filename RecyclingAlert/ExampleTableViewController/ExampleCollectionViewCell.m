//
//  ExampleCollectionViewCell.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/19/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleCollectionViewCell.h"

static const CGFloat ExampleCollectionViewCellFontSize = 12.0;

@interface ExampleCollectionViewCell ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@property (nonatomic, strong, readwrite) UILabel *label;

@end

@implementation ExampleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor greenColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        _label = [UILabel new];
        _label.numberOfLines = 2;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:ExampleCollectionViewCellFontSize];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    _imageView.frame = CGRectMake(5, 5, CGRectGetWidth(frame) - 10, CGRectGetWidth(frame));
    _label.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame), CGRectGetWidth(frame), 30);
    [self layoutNonRecycledView:self.nonRecycledLayer];
}

- (void)layoutNonRecycledView: (UIView *)view {
    view.frame = self.imageView.bounds;
}

@end
