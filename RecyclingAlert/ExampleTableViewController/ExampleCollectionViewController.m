//
//  ExampleCollectionViewController.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/19/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleCollectionViewController.h"
#import "ExampleDelegate.h"
#import "ExampleItemGenerator.h"
#import "ExampleImage.h"
#import "ExampleCollectionViewCell.h"
#import "ExampleCollectionViewDataSource.h"
#import "ExampleCollectionViewHeaderFooterViewCollectionReusableView.h"

static NSString *ExampleCellIdentifier = @"ExampleCellIdentifier";

@interface ExampleCollectionViewController ()

@property (nonatomic, strong) ExampleDelegate *exampleDelegate;

@property (nonatomic, strong) ExampleCollectionViewDataSource *exampleDataSource;

@end

@implementation ExampleCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[ExampleCollectionViewCell class] forCellWithReuseIdentifier:ExampleCellIdentifier];
    [self.collectionView registerClass:[ExampleCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ExampleCollectionViewHeaderFooterViewCollectionReusableViewHeaderIdentifier];
    [self.collectionView registerClass:[ExampleCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ExampleCollectionViewHeaderFooterViewCollectionReusableViewFooterIdentifier];

    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.exampleDelegate = [ExampleDelegate new];
    self.exampleDataSource = [[ExampleCollectionViewDataSource alloc] initWithItems:[ExampleItemGenerator randomExampleItems] cellIdentifier:ExampleCellIdentifier configureCellBlock:^(ExampleCollectionViewCell *cell, ExampleItem *item) {
        NSInteger type = item.idNumber;
        if (cell.nonRecycledLayer) {
            [cell.nonRecycledLayer removeFromSuperlayer];
            cell.nonRecycledLayer = nil;
        }
        cell.imageView.image = nil;
        cell.imageView.backgroundColor = [UIColor clearColor];
        switch (type) {
            case 0: {
                cell.imageView.backgroundColor = [UIColor clearColor];
                cell.label.text = @"Recycled View";
                cell.recyledViewWithDrawRect.hidden = NO;
                [cell.recyledViewWithDrawRect setNeedsDisplay];
                break;
            }
            case 1: {
                cell.recyledViewWithDrawRect.hidden = YES;
                cell.label.text = @"Non-Recycled Layer";
                cell.nonRecycledLayer = [CALayer new];
                cell.nonRecycledLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
                [cell.imageView.layer addSublayer:cell.nonRecycledLayer];
                [cell setNeedsLayout];
                break;
            }
            case 2: {
                cell.recyledViewWithDrawRect.hidden = YES;
                cell.label.text = @"Non-Recycled Image";
                cell.imageView.image = [ExampleImage nonRecycledImage];
                break;
            }
            case 3: {
                cell.recyledViewWithDrawRect.hidden = YES;
                cell.label.text = @"Recycled Image";
                cell.imageView.image = [ExampleImage recycledImage];
                break;
            }
            default:
                break;
        }
    }];
    self.collectionView.delegate = self.exampleDelegate;
    self.collectionView.dataSource = self.exampleDataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
