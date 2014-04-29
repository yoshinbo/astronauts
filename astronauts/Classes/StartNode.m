//
//  StartNode.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/03/05.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//
#import "StartNode.h"

@implementation StartNode
{
    CGSize winSize;
}

static const int minDuration = 5.0;
static const int maxDuration = 15.0;
static const int minScale = 2;
static const int maxScale = 10;


- (StartNode *) init
{
    self = [super init];
    if (self) {

        // init values
        winSize = [CCDirector sharedDirector].viewSize;

        // init sprite
        CCSprite *star = [CCSprite spriteWithImageNamed:@"star.png"];

        int rangeScale = maxScale - minScale;
        int randomScale = (arc4random() % rangeScale) + minScale;
        star.scale = (float)randomScale * 0.1;

        [self addChild:star];

        // Define a vertical range for the monster to spawn
        int minY = star.contentSize.height / 2;
        int maxY = winSize.height - star.contentSize.height / 2;
        int rangeY = maxY - minY;
        int randomY = arc4random_uniform(rangeY) + minY;

        // init node
        self.position = ccp(winSize.width + star.contentSize.width/2, randomY);
        self.contentSize = [star boundingBox].size;
        self.anchorPoint = ccp(0.5, 0.5);

        [self shot];
    }
    return self;
}

- (void) shot
{
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    // Attuch movement to Monster
    CCAction *actionMove = [CCActionMoveBy
                            actionWithDuration:randomDuration position:CGPointMake(
                                                                                   -winSize.width - self.contentSize.width,
                                                                                   0
                                                                                   )
                            ];
    CCAction *actionRemove = [CCActionRemove action];
    [self runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

@end
