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
    BOOL is_start;
    BOOL is_over;

    int score;
    int frameSpentSinceLastMeteoriteAdded;

    PlayerNode  *_player;
    CCPhysicsNode *_physicsNode;

    CCLabelTTF *_scoreLabel;
}

- (PhysicsNode *)initWithContentSize:(CGSize)contentSize;
{
    self = [super init];
    if (self){

        // Enable touch handling on scene node
        self.userInteractionEnabled = YES;

        is_start = FALSE;
        is_over = FALSE;

        self.contentSize = contentSize;
        frameSpentSinceLastMeteoriteAdded = 0;

        // Score
        score = 0;
        NSString *targetString = [NSString stringWithFormat:@"%d",score];
        _scoreLabel = [CCLabelTTF labelWithString:targetString fontName:@"Marker Felt" fontSize:30];
        _scoreLabel.color = [CCColor whiteColor];
        _scoreLabel.position = ccp(self.contentSize.width/2, self.contentSize.height*0.95f);
        [self addChild:_scoreLabel];

        // add physics node
        _physicsNode = [CCPhysicsNode node];
        _physicsNode.gravity = ccp(0,0);
        _physicsNode.debugDraw = YES;
        _physicsNode.collisionDelegate = self;
        [self addChild:_physicsNode];

        // add player node
        _player = [[PlayerNode alloc]initWithPosition:
                   ccp(self.contentSize.width/3,self.contentSize.height/2)];
        _player.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(
                                                                     -_player.contentSize.width/2,
                                                                     -_player.contentSize.height/2,
                                                                     _player.contentSize.width,
                                                                     _player.contentSize.height) cornerRadius:0];
        _player.physicsBody.collisionGroup = @"playerGroup";
        _player.physicsBody.collisionType = @"playerCollision";
        [_physicsNode addChild:_player];

    }
    return self;
}

-(void) update:(CCTime)delta
{

    if (is_start) {

        [_player move:delta];

        frameSpentSinceLastMeteoriteAdded++;
        if (frameSpentSinceLastMeteoriteAdded == addMeteoriteAfterDuration) {
            frameSpentSinceLastMeteoriteAdded = 0;
            [self addMeteorite];
            [self addScore];
        }

    }

}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    if (is_start) {
        [_player jump];
    } else {
        [self start];
    }

}

-(void) addMeteorite
{
    MeteoriteNode *meteorite = [[MeteoriteNode alloc] init];
    meteorite.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(
                                                                   -meteorite.contentSize.width/2,
                                                                   -meteorite.contentSize.height/2,
                                                                   meteorite.contentSize.width,
                                                                   meteorite.contentSize.height) cornerRadius:0];
    meteorite.physicsBody.collisionGroup = @"meteoriteGroup";
    meteorite.physicsBody.collisionType  = @"meteoriteCollision";
    [_physicsNode addChild:meteorite];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair meteoriteCollision:(CCNode *)meteorite playerCollision:(CCNode *)player {

    CGPoint point = player.position;
    [player removeFromParent];

    CCParticleExplosion *particle = [[CCParticleExplosion alloc]init];
    particle.position = point;
    particle.autoRemoveOnFinish = YES;
    [self addChild:particle];

    [self over];

    return YES;
}

- (void) addScore
{
    score++;
    NSString *scoreStr = [[NSString alloc] initWithFormat:@"%d", score];
    [_scoreLabel setString: [NSString stringWithFormat:@"%@",scoreStr]];
}

- (void) start
{
    if (!is_over) {
        is_start = TRUE;
    }
}

- (void) over
{
    is_start = FALSE;
    is_over = TRUE;
}

@end
