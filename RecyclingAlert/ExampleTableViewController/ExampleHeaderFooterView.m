//
//  ExampleHeaderFooterView.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/29/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleHeaderFooterView.h"
#import "ExampleImage.h"

static const CGFloat ExampleCellInset = 10.0;

static const CGFloat ExampleCellFontSize = 12.0;

static const CGFloat ExampleCellLabelHeight = 30;

static const CGFloat ExampleHeaderFooterViewHeight = 20;

@interface ExampleHeaderFooterView ()

@property (nonatomic, strong, readwrite) ExampleRecycledViewWithDrawRect *recycledView;

@property (nonatomic, strong, readwrite) UIImageView *recycledImageViewWithNonRecycledImage;

@property (nonatomic, strong, readwrite) UIImageView *recycledImageViewWithRecycledImage;

@property (nonatomic, strong, readwrite) UILabel *label0;

@property (nonatomic, strong, readwrite) UILabel *label1;

@property (nonatomic, strong, readwrite) UILabel *label2;

@property (nonatomic, strong, readwrite) UILabel *label3;

@property (nonatomic, strong) UILabel *headerFooterLabel;

@end

@implementation ExampleHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithReuseIdentifier:reuseIdentifier])) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        self.recycledView = [ExampleRecycledViewWithDrawRect new];
        self.recycledView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.recycledView];
        self.recycledImageViewWithNonRecycledImage = [UIImageView new];
        self.recycledImageViewWithNonRecycledImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.recycledImageViewWithNonRecycledImage];
        self.recycledImageViewWithRecycledImage = [UIImageView new];
        self.recycledImageViewWithRecycledImage.contentMode = UIViewContentModeScaleAspectFit;
        self.recycledImageViewWithRecycledImage.image = [ExampleImage recycledImage];
        [self.contentView addSubview:self.recycledImageViewWithRecycledImage];
        self.label0 = [UILabel new];
        self.label0.font = [UIFont systemFontOfSize:ExampleCellFontSize];
        self.label0.numberOfLines = 2;
        self.label0.textAlignment = NSTextAlignmentCenter;
        self.label0.text = @"Recycled View";
        [self.contentView addSubview:self.label0];
        self.label1 = [UILabel new];
        self.label1.font = [UIFont systemFontOfSize:ExampleCellFontSize];
        self.label1.numberOfLines = 2;
        self.label1.textAlignment = NSTextAlignmentCenter;
        self.label1.text = @"Non-Recycled View";
        [self.contentView addSubview:self.label1];
        self.label2 = [UILabel new];
        self.label2.font = [UIFont systemFontOfSize:ExampleCellFontSize];
        self.label2.numberOfLines = 2;
        self.label2.textAlignment = NSTextAlignmentCenter;
        self.label2.text = @"Non-Recycled Image";
        [self.contentView addSubview:self.label2];
        self.label3 = [UILabel new];
        self.label3.font = [UIFont systemFontOfSize:ExampleCellFontSize];
        self.label3.numberOfLines = 2;
        self.label3.textAlignment = NSTextAlignmentCenter;
        self.label3.text = @"Recycled Image";
        [self.contentView addSubview:self.label3];
        self.headerFooterLabel = [UILabel new];
        self.headerFooterLabel.font = [UIFont boldSystemFontOfSize:ExampleCellFontSize];
        self.headerFooterLabel.numberOfLines = 2;
        self.headerFooterLabel.textAlignment = NSTextAlignmentCenter;
        self.headerFooterLabel.text = @"This is a header/footer view.";
        [self.contentView addSubview:self.headerFooterLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutRecyledView:self.recycledView];
    [self layoutNonRecycledImage:self.recycledImageViewWithNonRecycledImage];
    [self layoutRecycledImage:self.recycledImageViewWithRecycledImage];
}

@end

@implementation ExampleHeaderFooterView (LayoutSubviews)

- (void)layoutRecyledView: (UIView *)view {
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame)/4.0, CGRectGetHeight(self.contentView.frame) - ExampleCellLabelHeight - ExampleHeaderFooterViewHeight);
    rect = CGRectInset(rect, ExampleCellInset, ExampleCellInset);
    view.frame = rect;
    self.label0.frame = CGRectMake(CGRectGetMinX(rect) - ExampleCellInset, CGRectGetMaxY(rect), CGRectGetWidth(rect) + 2 * ExampleCellInset, ExampleCellLabelHeight);
    rect = CGRectMake(0, CGRectGetMaxY(self.label0.frame), CGRectGetWidth(self.contentView.frame), ExampleHeaderFooterViewHeight);
    self.headerFooterLabel.frame = rect;
}

- (void)layoutNonRecycledView: (UIView *)view {
    CGRect rect = CGRectMake(CGRectGetWidth(self.contentView.frame)/4.0, 0, CGRectGetWidth(self.contentView.frame)/4.0, CGRectGetHeight(self.contentView.frame) - ExampleCellLabelHeight - ExampleHeaderFooterViewHeight);
    rect = CGRectInset(rect, ExampleCellInset, ExampleCellInset);
    view.frame = rect;
    self.label1.frame = CGRectMake(CGRectGetMinX(rect) - ExampleCellInset, CGRectGetMaxY(rect), CGRectGetWidth(rect) + 2 * ExampleCellInset, ExampleCellLabelHeight);
}

- (void)layoutNonRecycledImage: (UIView *)view {
    CGRect rect = CGRectMake(CGRectGetWidth(self.contentView.frame) * 2.0/4.0, 0, CGRectGetWidth(self.contentView.frame)/4.0, CGRectGetHeight(self.contentView.frame) - ExampleCellLabelHeight - ExampleHeaderFooterViewHeight);
    rect = CGRectInset(rect, ExampleCellInset, ExampleCellInset);
    view.frame = rect;
    self.label2.frame = CGRectMake(CGRectGetMinX(rect) - ExampleCellInset, CGRectGetMaxY(rect), CGRectGetWidth(rect) + 2 * ExampleCellInset, ExampleCellLabelHeight);
}

- (void)layoutRecycledImage: (UIView *)view {
    CGRect rect = CGRectMake(CGRectGetWidth(self.contentView.frame) * 3.0/4.0, 0, CGRectGetWidth(self.contentView.frame)/4.0, CGRectGetHeight(self.contentView.frame) - ExampleCellLabelHeight - ExampleHeaderFooterViewHeight);
    rect = CGRectInset(rect, ExampleCellInset, ExampleCellInset);
    view.frame = rect;
    self.label3.frame = CGRectMake(CGRectGetMinX(rect) - ExampleCellInset, CGRectGetMaxY(rect), CGRectGetWidth(rect) + 2 * ExampleCellInset, ExampleCellLabelHeight);
}

@end