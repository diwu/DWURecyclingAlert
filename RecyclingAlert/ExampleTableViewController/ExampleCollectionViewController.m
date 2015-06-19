//
//  ExampleCollectionViewController.m
//  RecyclingAlert
//
//  Created by Di Wu on 6/19/15.
//  Copyright (c) 2015 Di Wu. All rights reserved.
//

#import "ExampleCollectionViewController.h"
#import "ExampleDelegate.h"
#import "ExampleDataSource.h"
#import "ExampleItemGenerator.h"
#import "ExampleImage.h"
#import "ExampleCollectionViewCell.h"

static NSString *ExampleCellIdentifier = @"ExampleCellIdentifier";
static const NSInteger ExampleCellNonRecycledViewTag = NSIntegerMax;

@interface ExampleCollectionViewController ()

@property (nonatomic, strong) ExampleDelegate *exampleDelegate;

@property (nonatomic, strong) ExampleDataSource *exampleDataSource;

@end

@implementation ExampleCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[ExampleCollectionViewCell class] forCellWithReuseIdentifier:ExampleCellIdentifier];
    
    // Do any additional setup after loading the view.
//    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.exampleDelegate = [ExampleDelegate new];
    self.exampleDataSource = [[ExampleDataSource alloc] initWithItems:[ExampleItemGenerator randomExampleItems] cellIdentifier:ExampleCellIdentifier configureCellBlock:^(ExampleCollectionViewCell *cell, ExampleItem *item) {
        NSInteger type = item.idNumber;
        if (cell.nonRecycledView) {
            [cell.nonRecycledView removeFromSuperview];
            cell.nonRecycledView = nil;
        }
        cell.imageView.image = nil;
        cell.imageView.backgroundColor = [UIColor clearColor];
        switch (type) {
            case 0: {
                cell.imageView.backgroundColor = [UIColor greenColor];
                cell.label.text = @"Recycled View";
                break;
            }
            case 1: {
                cell.label.text = @"Non-Recycled View";
                cell.nonRecycledView = [UIView new];
                cell.nonRecycledView.backgroundColor = [UIColor blueColor];
                [cell.imageView addSubview:cell.nonRecycledView];
                [cell setNeedsLayout];
                break;
            }
            case 2: {
                cell.label.text = @"Non-Recycled Image";
                cell.imageView.image = [ExampleImage nonRecycledImage];
                break;
            }
            case 3: {
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
