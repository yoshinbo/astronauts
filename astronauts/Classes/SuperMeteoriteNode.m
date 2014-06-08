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
static const float scale = 1.0;

- (SuperMeteoriteNode *) init
{
    self = [super initWithImageNamed:@"meteorite2.png"];
    if (self) {

        // init values
        winSize = [CCDirector sharedDirector].viewSize;

        self.scale = scale;

        // Define a vertical range for the monster to spawn
        int minY = self.contentSize.height / 2;
        int maxY = winSize.height - self.contentSize.height / 2;
        int rangeY = maxY - minY;
        int randomY = arc4random_uniform(rangeY) + minY;

        self.position = ccp(winSize.width + self.contentSize.width/2, randomY);
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
    
    // se
    [[OALSimpleAudio sharedInstance]playEffect:@"fire.mp3"];

}

@end
