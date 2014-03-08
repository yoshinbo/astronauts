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
        //CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
        //CGSize winSize = [CCDirector sharedDirector].viewSize;
        //background.position = CGPointMake(winSize.width/2, winSize.height /2);
        //[self addChild:background];

    }

    return self;
}

@end
