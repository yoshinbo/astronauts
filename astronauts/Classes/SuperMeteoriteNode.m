//
//  SuperMeteorite.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/03/09.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "SuperMeteoriteNode.h"

@implementation SuperMeteoriteNode
{
    CGSize winSize;
}

static const int minDuration = 2.0;
static const int maxDuration = 3.0;
static const float scale = 1.5;

- (SuperMeteoriteNode *) init
{
    self = [super init];
    if (self) {

        // init values
        winSize = [CCDirector sharedDirector].viewSize;

        // init sprite
        _meteoriteSprite = [CCSprite spriteWithImageNamed:@"meteorite2.png"];
        _meteoriteSprite.scale = scale;
        _meteoriteSprite.position = ccp(_meteoriteSprite.contentSize.width*scale/2,
                                        _meteoriteSprite.contentSize.height*scale/2);
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
    [self runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

@end
