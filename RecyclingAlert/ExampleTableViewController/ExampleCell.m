//
//  ExampleCell.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleCell.h"

static const CGFloat ExampleCellInset = 10.0;

@interface ExampleCell ()

@property (nonatomic, strong) UIView *recycledView;

@property (nonatomic, strong, readwrite) UIImageView *recycledImageViewWithNonRecycledImage;

@end

@implementation ExampleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.recycledView = [UIView new];
        self.recycledView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.recycledView];
        self.recycledImageViewWithNonRecycledImage = [UIImageView new];
        self.recycledImageViewWithNonRecycledImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.recycledImageViewWithNonRecycledImage];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutRecyledView:self.recycledView];
    [self layoutNonRecycledImage:self.recycledImageViewWithNonRecycledImage];
}

@end

@implementation ExampleCell (LayoutSubviews)

- (void)layoutRecyledView: (UIView *)view {
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame)/4.0, CGRectGetHeight(self.contentView.frame));
    rect = CGRectInset(rect, ExampleCellInset, ExampleCellInset);
    view.frame = rect;
}

- (void)layoutNonRecycledView: (UIView *)view {
    CGRect rect = CGRectMake(CGRectGetWidth(self.contentView.frame)/4.0, 0, CGRectGetWidth(self.contentView.frame)/4.0, CGRectGetHeight(self.contentView.frame));
    rect = CGRectInset(rect, ExampleCellInset, ExampleCellInset);
    view.frame = rect;
}

- (void)layoutNonRecycledImage: (UIView *)view {
    CGRect rect = CGRectMake(CGRectGetWidth(self.contentView.frame) * 2.0/4.0, 0, CGRectGetWidth(self.contentView.frame)/4.0, CGRectGetHeight(self.contentView.frame));
    rect = CGRectInset(rect, ExampleCellInset, ExampleCellInset);
    view.frame = rect;
}

@end
