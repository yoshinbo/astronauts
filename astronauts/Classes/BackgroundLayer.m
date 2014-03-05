//
//  BackgroundLayer.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/03/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

- (BackgroundLayer *)initWithContentSize:(CGSize)contentSize
{
    self = [super init];

    if (self) {

        self.contentSize = contentSize;

        // Create a colored background (Dark Grey)
        CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor blackColor]];
        [self addChild:background];

    }

    return self;
}

@end
