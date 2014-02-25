//
//  PlayerNode.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/02/23.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "PlayerNode.h"

@implementation PlayerNode

- (PlayerNode*) initWithPosition:(CGPoint)position
{
    self = [super init];
    if (self) {

        // init values
        _velocity_y = -1;

        // init sprite
        _playerSprite = [CCSprite spriteWithImageNamed:@"Icon-72.png"];
        _playerSprite.scale = 0.5;
        [self addChild:_playerSprite];

        self.position = position;
        self.contentSize = [_playerSprite boundingBox].size;

    }
    return self;
}

- (void)move:(CCTime)delta
{
    if (self.position.y > 23) {
        CGFloat speed = delta * 10.0f;
        _velocity_y -= speed;
        NSLog(@"%f:%f",self.position.y, self.contentSize.height);
        self.position = ccpAdd(self.position, ccp(0,_velocity_y));
    }
}

- (void)jump
{
    _velocity_y = 5;
}

@end
