//
//  ExampleCell.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleCell.h"
#import "ExampleImage.h"

static const CGFloat ExampleCellInset = 10.0;

@interface ExampleCell ()

@property (nonatomic, strong) UIView *recycledView;

@property (nonatomic, strong, readwrite) UIImageView *recycledImageViewWithNonRecycledImage;

@property (nonatomic, strong, readwrite) UIImageView *recycledImageViewWithRecycledImage;

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
        self.recycledImageViewWithRecycledImage = [UIImageView new];
        self.recycledImageViewWithRecycledImage.contentMode = UIViewContentModeScaleAspectFit;
        self.recycledImageViewWithRecycledImage.image = [ExampleImage recycledImage];
        [self.contentView addSubview:self.recycledImageViewWithRecycledImage];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutRecyledView:self.recycledView];
    [self layoutNonRecycledImage:self.recycledImageViewWithNonRecycledImage];
    [self layoutNonRecycledImage:self.recycledImageViewWithNonRecycledImage];
    [self layoutRecycledImage:self.recycledImageViewWithRecycledImage];
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

- (void)layoutRecycledImage: (UIView *)view {
    CGRect rect = CGRectMake(CGRectGetWidth(self.contentView.frame) * 3.0/4.0, 0, CGRectGetWidth(self.contentView.frame)/4.0, CGRectGetHeight(self.contentView.frame));
    rect = CGRectInset(rect, ExampleCellInset, ExampleCellInset);
    view.frame = rect;
}

@end
