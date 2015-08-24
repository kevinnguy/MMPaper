//
//  MMRootViewController.m
//  MMPaper
//
//  Created by mukesh mandora on 04/03/15.
//  Copyright (c) 2015 com.muku. All rights reserved.
//

#import "MMRootViewController.h"
#import "MMBaseCollection.h"
#import "MMSmallLayout.h"
#import "MMLargeLayout.h"
#import "PaperBuble.h"
@interface MMRootViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>{
    BOOL toogle;
    PaperBuble *bubble;
    UIImageView *addfrd,*noti,*msg;
}
@property (nonatomic) MMBaseCollection *baseController;
@property (nonatomic, assign) NSInteger slide;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIImageView *reflected;
@property (nonatomic, strong) NSArray *galleryImages;
@end

@implementation MMRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     toogle=YES;
    
    // Init mainView
    _mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    _mainView.clipsToBounds = YES;
    _mainView.layer.cornerRadius = 4;
    [self.view addSubview:_mainView];
    
    // ImageView on top
    _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, UIAppDelegate.itemHeight-256)];
    _topImage.image = [UIImage imageNamed:@"one.jpg"];
    _reflected = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topImage.bounds), self.view.frame.size.width, self.view.frame.size.height/2)];
    _reflected.image = [UIImage imageNamed:@"one.jpg"];
    [_mainView addSubview:_topImage];
    [_mainView addSubview:_reflected];
    
    self.baseController=[[MMBaseCollection alloc] initWithCollectionViewLayout:[MMSmallLayout new]];
    [self.view addSubview:self.baseController.collectionView];

    
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


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
