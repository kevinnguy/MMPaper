//
//  MMViewController.m
//  MMPaper
//
//  Created by muku on 12/10/14.
//  Copyright (c) 2014 com.muku. All rights reserved.
//

#import "MMViewController.h"
#import "MMSmallLayout.h"
#import "MMLargeLayout.h"

#import "HATransitionLayout.h"


#define CELL_ID @"CELL_ID"

@interface MMViewController ()
@property (nonatomic, assign) NSInteger slide;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIImageView *reflected;
@property (nonatomic, strong) NSArray *galleryImages;

@end

@implementation MMViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //Gallery
    _galleryImages = @[@"one.jpg", @"two.jpg", @"three.png", @"five.jpg", @"one.jpg"];
    _slide = 0;
    
    
    // Init mainView
    _mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    _mainView.clipsToBounds = YES;
    _mainView.layer.cornerRadius = 4;
    [self.view insertSubview:_mainView belowSubview:self.collectionView];
    
    // ImageView on top
    _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _topImage.image = [UIImage imageNamed:@"one.jpg"];
    _reflected = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topImage.bounds), 320, 320)];
    _reflected.image = [UIImage imageNamed:@"one.jpg"];
    [_mainView addSubview:_topImage];
    [_mainView addSubview:_reflected];
    
    _topImage.contentMode=UIViewContentModeScaleAspectFill;
    
    
    // Reflect imageView
    _reflected.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    
    // Gradient to top image
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _topImage.bounds;
    gradient.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [_topImage.layer insertSublayer:gradient atIndex:0];
    
    
    // Gradient to reflected image
    CAGradientLayer *gradientReflected = [CAGradientLayer layer];
    gradientReflected.frame = _reflected.bounds;
    gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
                                 (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [_reflected.layer insertSublayer:gradientReflected atIndex:0];
    
    
    // Content perfect pixel
    UIView *perfectPixelContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_topImage.bounds), 1)];
    perfectPixelContent.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [_topImage addSubview:perfectPixelContent];

    
}

#pragma mark collection view

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [self nextViewControllerAtPoint:CGPointZero];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewController *)nextViewControllerAtPoint:(CGPoint)point
{
    // We could have multiple section stacks and find the right one,
    MMLargeLayout *largeLayout = [[MMLargeLayout alloc] init];
    MMBaseCollection *nextCollectionViewController = [[MMBaseCollection alloc] initWithCollectionViewLayout:largeLayout];
    
    nextCollectionViewController.useLayoutToLayoutNavigationTransitions = YES;
    return nextCollectionViewController;
}


@end
