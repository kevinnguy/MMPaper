//
//  MMBaseCollection.h
//  MMPaper
//
//  Created by mukesh mandora on 26/12/14.
//  Copyright (c) 2014 com.muku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMSmallLayout.h"
#import "MMLargeLayout.h"
@interface MMBaseCollection : UICollectionViewController<UIGestureRecognizerDelegate>{
    UIPanGestureRecognizer *panGestureRecognizer;
    BOOL toBeExpandedFlag,transitioningFlag,changedFlag,hasActiveInteraction;
    CGPoint initialPanPoint;
    CGFloat targetY;
    
}

@property (nonatomic)MMSmallLayout *smallLayout;
@property (nonatomic) MMLargeLayout *largeLayout;

@property (nonatomic, strong) NSMutableArray *colorArray;

@end
