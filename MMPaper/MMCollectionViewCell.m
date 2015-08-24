//
//  MMCollectionViewCell.m
//  MMPaper
//
//  Created by mukesh mandora on 04/03/15.
//  Copyright (c) 2015 com.muku. All rights reserved.
//

#import "MMCollectionViewCell.h"

#import <UIColor+Chameleon.h>

@implementation MMCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    indexData = -1;
    if(self){
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setIndex:(NSUInteger )index withSize:(CGSize)size{
    indexData=index;
    cellSize=size;
}

@end
