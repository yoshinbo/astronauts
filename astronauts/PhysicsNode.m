//
//  PhysicsNode.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/02/24.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "PhysicsNode.h"
#import "PlayerNode.h"
#import "MeteoriteNode.h"

int addMeteoriteAfterDuration = 100;

@implementation PhysicsNode
{
    PlayerNode  *_player;
    CCPhysicsNode *_physicsNode;
    int frameSpentSinceLastMeteoriteAdded;
}

- (PhysicsNode *)initWithContentSize:(CGSize)contentSize;
{
    self = [super init];
    if (self){

        // Enable touch handling on scene node
        self.userInteractionEnabled = YES;

        self.contentSize = contentSize;
        frameSpentSinceLastMeteoriteAdded = 0;

        // add physics node
        _physicsNode = [CCPhysicsNode node];
        _physicsNode.gravity = ccp(0,0);
        _physicsNode.debugDraw = YES;
        _physicsNode.collisionDelegate = self;
        [self addChild:_physicsNode];

        // add player node
        _player = [[PlayerNode alloc]initWithPosition:
                   ccp(self.contentSize.width/3,self.contentSize.height/2)];
        _player.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _player.contentSize} cornerRadius:0];
        _player.physicsBody.collisionGroup = @"playerGroup";
        _player.physicsBody.collisionType = @"playerCollision";
        [_physicsNode addChild:_player];

    }
    return self;
}

-(void) update:(CCTime)delta
{

    [_player move:delta];

    frameSpentSinceLastMeteoriteAdded++;
    if (frameSpentSinceLastMeteoriteAdded == addMeteoriteAfterDuration) {
        frameSpentSinceLastMeteoriteAdded = 0;
        [self addMeteorite];
    }

}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    [_player jump];

}

-(void) addMeteorite
{
    NSLog(@"add meteorite");
    MeteoriteNode *meteorite = [[MeteoriteNode alloc] init];
    NSLog(@"%f",meteorite.contentSize.width);
    meteorite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, meteorite.contentSize} cornerRadius:0];
    meteorite.physicsBody.collisionGroup = @"meteoriteGroup";
    meteorite.physicsBody.collisionType  = @"meteoriteCollision";
    [_physicsNode addChild:meteorite];
}



@end
