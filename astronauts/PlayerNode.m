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
        _point = position;
        _isUp = FALSE;

        // Add a sprite
        _playerSprite = [CCSprite spriteWithImageNamed:@"Icon-72.png"];
        [self addChild:_playerSprite];

        self.position = _point;

    }
    return self;
}

@end
