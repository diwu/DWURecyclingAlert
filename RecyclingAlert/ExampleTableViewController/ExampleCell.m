//
//  ExampleCell.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/7/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleCell.h"

static const CGFloat ExampleCellInset = 15.0;

@interface ExampleCell ()

@property (nonatomic, strong) UIView *recycledView;

@end

@implementation ExampleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.recycledView = [UIView new];
        self.recycledView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.recycledView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutRecyledView:self.recycledView];
}

@end

@implementation ExampleCell (LayoutSubviews)

- (void)layoutRecyledView: (UIView *)view {
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame)/2.0, CGRectGetHeight(self.contentView.frame));
    rect = CGRectInset(rect, ExampleCellInset, ExampleCellInset);
    view.frame = rect;
}

- (void)layoutNonRecycledView: (UIView *)view {
    CGRect rect = CGRectMake(CGRectGetMidX(self.contentView.frame), 0, CGRectGetWidth(self.contentView.frame)/2.0, CGRectGetHeight(self.contentView.frame));
    rect = CGRectInset(rect, ExampleCellInset, ExampleCellInset);
    view.frame = rect;
}

@end
