//
//  MMBaseCollection.m
//  MMPaper
//
//  Created by mukesh mandora on 26/12/14.
//  Copyright (c) 2014 com.muku. All rights reserved.
//

#import "MMBaseCollection.h"
#define CELL_ID @"CELL_ID"
#import "HATransitionLayout.h"
#import "MMCollectionViewCell.h"
#import "POP.h"

#import <UIColor+Chameleon.h>

@implementation MMBaseCollection


- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        [self.collectionView registerClass:[MMCollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        toBeExpandedFlag=true;
        transitioningFlag=false;
        changedFlag=false;
        _smallLayout=(MMSmallLayout*)layout;
        _largeLayout=[[MMLargeLayout alloc] init];
        [self gestureInit];
        
        // Color array
        self.colorArray = [NSMutableArray new];
        for (NSInteger i = 0; i < 20; i++) {
            [self.colorArray addObject:[UIColor randomFlatColor]];
        }
    }
    return self;
}

-(void)gestureInit{
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.collectionView addGestureRecognizer:panGestureRecognizer];
}


-(void)handlePan:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:sender.view];
    CGPoint velocity = [sender velocityInView:sender.view];
    // limit the range of velocity so that animation will not stop when verlocity is 0
    
    
    CGFloat progress = ABS(point.y - initialPanPoint.y)/ABS(targetY - initialPanPoint.y);
    if(sender.state==UIGestureRecognizerStateBegan){
        changedFlag = false;     //clear flag here
        if ([self getTransitionLayout ] ) {
            [self updatePositionData:point withProgess:[self getTransitionLayout ].transitionProgress];
            
            return;
        }
        if ((velocity.y > 0 && toBeExpandedFlag) || (velocity.y < 0 && !toBeExpandedFlag)) {
            //only respond to one direction of swipe
            return;
        }
        
        initialPanPoint = point;    // record the point where gesture began
        
        CGFloat tallHeight = _largeLayout.itemSize.height;
        CGFloat shortHeight = _smallLayout.itemSize.height;
        
        CGFloat hRatio = (tallHeight - initialPanPoint.y) / (toBeExpandedFlag ? shortHeight : tallHeight);
        
        // when the touch point.y reached targetY, that meanas progress = 1.0
        // update targetY value
        
        targetY = tallHeight - hRatio * (toBeExpandedFlag ? tallHeight : shortHeight);
        

        
        [self.collectionView startInteractiveTransitionToCollectionViewLayout:(toBeExpandedFlag?_largeLayout:_smallLayout) completion:nil];
        transitioningFlag = true;

    }
    else if (sender.state==UIGestureRecognizerStateCancelled || sender.state==UIGestureRecognizerStateEnded){
        if (!changedFlag) {//without this guard, collectionview behaves strangely
            
            return;
        }
        
        if ([self getTransitionLayout]){
            BOOL success = [self getTransitionLayout].transitionProgress > 0.5;
            CGFloat yToReach;
            if (success) {
                [self.collectionView finishInteractiveTransition];
                toBeExpandedFlag = !toBeExpandedFlag;

                yToReach = targetY;
            } else {
                [self.collectionView cancelInteractiveTransition];
                yToReach = initialPanPoint.y;
                
               
            }
        }
    }
    else if (sender.state==UIGestureRecognizerStateChanged){
        if (!transitioningFlag) {//if not transitoning, return
            return;
        }

        changedFlag = true ; // set flag here
        
        if(progress <= 1.1){
            [self updateWithProgress:progress];
        }
    }
}

-(void)finishInteractiveTransition:(CGFloat)progress inDuration:(CGFloat)duration withSucess:(BOOL)success{
    if ((success && (progress >= 1.0)) || (!success && (progress <= 0.0))) {
        // no need to animate
        if (!transitioningFlag) {
            return;
        }
        
        if (success) {
            [self updateWithProgress:1.0];
            [self.collectionView finishInteractiveTransition];
            transitioningFlag = false;
            toBeExpandedFlag = !toBeExpandedFlag;
        }
        else{
            [self updateWithProgress:0.0];
            
            [self.collectionView cancelInteractiveTransition];
            transitioningFlag = false;
        }
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer == panGestureRecognizer) {
        
        
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        pan=(UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint direction = [pan velocityInView:pan.view];
        CGPoint pos = [pan locationInView:pan.view];
        
        //if touch point of out of range of cell, return false
        if (toBeExpandedFlag) {
            if(CGRectGetHeight(self.collectionView.frame) - _smallLayout.itemSize.height > pos.y) {
                return false;
            }
        }
        
        // if swipe for vertical direction, returns true
        
        if(abs(direction.y) >  abs(direction.x)) {
            return true;
        }
        else{
            return false;
        }
    }

    return true;
}



-(void)updatePositionData:(CGPoint)point withProgess:(CGFloat)progress{
    CGFloat tallHeight = _largeLayout.itemSize.height;
    CGFloat shortHeight = _smallLayout.itemSize.height;
    
    CGFloat itemHeight = (1-progress) * (toBeExpandedFlag ? shortHeight : tallHeight)
    + progress * (toBeExpandedFlag ? tallHeight : shortHeight);
    CGFloat hRatio = (_largeLayout.itemSize.height - point.y) / itemHeight;
    
    initialPanPoint.y = tallHeight - hRatio * (toBeExpandedFlag ? _smallLayout.itemSize.height:_largeLayout.itemSize.height);
    targetY = tallHeight - hRatio * (toBeExpandedFlag ? _largeLayout.itemSize.height:_smallLayout.itemSize.height);

}

-(UICollectionViewTransitionLayout *)getTransitionLayout{
    if ([self.collectionView.collectionViewLayout isKindOfClass:[UICollectionViewTransitionLayout class]]) {
        return (UICollectionViewTransitionLayout *)self.collectionView.collectionViewLayout ;
    }

    return nil;
}

-(void)updateWithProgress:(CGFloat)progress{
    ((UICollectionViewTransitionLayout *)self.collectionView.collectionViewLayout).transitionProgress = progress;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return false;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMCollectionViewCell *cell = (MMCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.backgroundColor = self.colorArray[indexPath.item];
    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorArray.count;
}


- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView
                        transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    HATransitionLayout *transitionLayout = [[HATransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return transitionLayout;
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    UIColor *color = self.colorArray[fromIndexPath.item];
    [self.colorArray removeObjectAtIndex:fromIndexPath.item];
    [self.colorArray insertObject:color atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    return YES;
}
@end
