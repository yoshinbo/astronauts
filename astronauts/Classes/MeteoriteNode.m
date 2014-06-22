//
//  MeteoriteNode.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/03/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "MeteoriteNode.h"

@implementation MeteoriteNode
{
    CGSize winSize;
}

static const int minDuration = 3.0;
static const int maxDuration = 6.0;
static const float scale = 1.0;
static const int homing_frequency = 3;

- (MeteoriteNode *) initWithPosition:(CGPoint)position
{
    self = [super initWithImageNamed:@"meteorite1.png"];
    if (self) {

        // init values
        winSize = [CCDirector sharedDirector].viewSize;
        self.scale = scale;

        // Define a vertical range for the monster to spawn
        int minY = self.contentSize.height / 2;
        int maxY = winSize.height - self.contentSize.height / 2;
        int rangeY = maxY - minY;
        int randomY = arc4random_uniform(rangeY) + minY;

        CGPoint r_position;
        if ([MeteoriteNode is_homing]){
            // homing meteorite
            if (position.y > maxY) {
                r_position = ccp(winSize.width + self.contentSize.width/2, maxY);
            } else if (position.y < minY) {
                r_position = ccp(winSize.width + self.contentSize.width/2, minY);
            } else {
                r_position = ccp(winSize.width + self.contentSize.width/2, position.y);
            }
        } else {
            // randam meteorite
            r_position = ccp(winSize.width + self.contentSize.width/2, randomY);
        }

        self.position = r_position;
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

+ (BOOL) is_homing
{
    int rand = arc4random_uniform(homing_frequency);
    return rand == 0 ? YES : NO;
}

@end
