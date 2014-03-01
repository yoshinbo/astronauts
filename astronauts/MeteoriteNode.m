//
//  MeteoriteNode.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/03/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "MeteoriteNode.h"

int minDuration = 3.0;
int maxDuration = 5.0;

@implementation MeteoriteNode
{
    CGSize winSize;
}

- (MeteoriteNode *) init
{
    self = [super init];
    if (self) {

        // init values
        winSize = [CCDirector sharedDirector].viewSize;

        // init sprite
        _meteoriteSprite = [CCSprite spriteWithImageNamed:@"Icon-72.png"];
        _meteoriteSprite.scale = 0.5;
        [self addChild:_meteoriteSprite];

        // Define a vertical range for the monster to spawn
        int minY = _meteoriteSprite.contentSize.height / 2;
        int maxY = winSize.height - _meteoriteSprite.contentSize.height / 2;
        int rangeY = maxY - minY;
        int randomY = (arc4random() % rangeY) + minY;

        // init node
        self.position = ccp(winSize.width + _meteoriteSprite.contentSize.width/2, randomY);
        self.contentSize = [_meteoriteSprite boundingBox].size;
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
    [_meteoriteSprite runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

@end
