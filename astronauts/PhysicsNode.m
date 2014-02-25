//
//  PhysicsNode.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/02/24.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "PhysicsNode.h"
#import "PlayerNode.h"

@implementation PhysicsNode
{
    PlayerNode  *_player;
    CCPhysicsNode *_physicsNode;
}

- (PhysicsNode *)initWithContentSize:(CGSize)contentSize;
{
    self = [super init];
    if (self){

        // Enable touch handling on scene node
        self.userInteractionEnabled = YES;

        self.contentSize = contentSize;

        // add physics node
        _physicsNode = [CCPhysicsNode node];
        _physicsNode.gravity = ccp(0,0);
        _physicsNode.debugDraw = YES;
        _physicsNode.collisionDelegate = self;
        [self addChild:_physicsNode];

        // add player node
        _player = [[PlayerNode alloc]initWithPosition:
                   ccp(self.contentSize.width/2,self.contentSize.height/2)];
        _player.scale = 0.5;
        [_physicsNode addChild:_player];

    }
    return self;
}

-(void) update:(CCTime)delta
{

    CGFloat speed = delta * 10.0f;
    if (_player.isUp) {
        _player.velocity_y += speed;
    } else {
        _player.velocity_y -= speed;
    }
    _player.position = ccpAdd(_player.position, ccp(0,_player.velocity_y));
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];

    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));

    // Move our sprite to touch location
    //CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
    //[_player runAction:actionMove];

    if (_player.isUp) {
        _player.isUp = FALSE;
        _player.velocity_y = -1; // move down
    } else {
        _player.isUp = YES;
        _player.velocity_y = 1; // move up
    }

}

@end
