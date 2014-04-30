//
//  PlayerNode.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/02/23.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "PlayerNode.h"

@implementation PlayerNode
{
    CGSize winSize;
    BOOL is_explosion;
}

static const float acceleration_rate = 10.0f;
static const float jump_degree = 5.0;
static const float max_velocity = 11;
static const float player_scale = 0.5;

- (PlayerNode*) initWithPosition:(CGPoint)position
{
    self = [super initWithImageNamed:@"player.png"];
    if (self) {

        // init values
        _velocity_y = -1;
        winSize = [CCDirector sharedDirector].viewSize;

        // init sprite
        self.scale = player_scale;
        self.position = position;
        self.anchorPoint = ccp(0.5, 0.5);
    }
    return self;
}

- (void)move:(CCTime)delta
{
    if (!is_explosion) {

    // set acceleration
    CGFloat acceleration = delta * acceleration_rate;
    if (fabs(_velocity_y) < max_velocity){
        _velocity_y -= acceleration;
    }

    // set position
    if (self.position.y <= -self.contentSize.height * 0.4) {
        self.position = ccp(self.position.x, winSize.height + self.contentSize.height * 0.4);
    } else if (self.position.y > winSize.height + self.contentSize.height*0.4) {
        self.position = ccp(self.position.x, 0 - self.contentSize.height * 0.4);
    } else {
        self.position = ccpAdd(self.position, ccp(0,_velocity_y));
    }

    }
}

- (void)jump
{
    _velocity_y = jump_degree;
}

@end
