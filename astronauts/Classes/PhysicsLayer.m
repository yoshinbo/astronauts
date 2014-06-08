//
//  PhysicsNode.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/02/24.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//
#import "GameScene.h"
#import "PhysicsLayer.h"
#import "PlayerNode.h"
#import "MeteoriteNode.h"
#import "SuperMeteoriteNode.h"
#import "StartNode.h"
#import "GCCShapeCache.h"

@implementation PhysicsLayer
{
    BOOL is_start;
    BOOL is_over;

    int score;
    int frameSpentSinceLastMeteoriteAdded;
    int frameSpentSinceLastSuperMeteoriteAdded;
    int frameSpentSinceLastStarAdded;
    int frameSpentSinceLastScoreAdded;

    PlayerNode  *_player;
    CCPhysicsNode *_physicsNode;

    CCLabelBMFont *_scoreLabel;
}

static const int addMeteoriteAfterDuration = 80;
static const int addSuperMeteoriteAfterDuration = 500;
static const int addScoreAfterDuration = 100;
static const int addStarAfterDuration = 10;


- (PhysicsLayer *)initWithContentSize:(CGSize)contentSize;
{
    self = [super init];
    if (self){

        // Enable touch handling on scene node
        self.userInteractionEnabled = YES;

        is_start = FALSE;
        is_over = FALSE;

        self.contentSize = contentSize;
        frameSpentSinceLastMeteoriteAdded = 0;
        frameSpentSinceLastStarAdded = 0;

        // Load shapes
        [[GCCShapeCache sharedShapeCache] addShapesWithFile:@"ccphysics.plist"];

        // add physics node
        _physicsNode = [CCPhysicsNode node];
        _physicsNode.gravity = ccp(0,0);
        //_physicsNode.debugDraw = YES;
        _physicsNode.collisionDelegate = self;
        [self addChild:_physicsNode];

        // add player node
        _player = [[PlayerNode alloc]initWithPosition:
                   ccp(self.contentSize.width/4,self.contentSize.height/2)];
        [[GCCShapeCache sharedShapeCache] setBodyWithName:@"player" onNode:_player];
        _player.physicsBody.collisionGroup = @"playerGroup";
        _player.physicsBody.collisionType = @"playerCollision";
        [_physicsNode addChild:_player];

    }
    return self;
}

-(void) update:(CCTime)delta
{

    // for background
    frameSpentSinceLastStarAdded++;
    if (frameSpentSinceLastStarAdded == addStarAfterDuration) {
        frameSpentSinceLastStarAdded = 0;
        [self addStar];

    }

    // for game
    if (is_start) {

        [_player move:delta];

        frameSpentSinceLastMeteoriteAdded++;
        if (frameSpentSinceLastMeteoriteAdded == addMeteoriteAfterDuration) {
            frameSpentSinceLastMeteoriteAdded = 0;
            [self addMeteorite];
        }
        frameSpentSinceLastSuperMeteoriteAdded++;
        if (frameSpentSinceLastSuperMeteoriteAdded == addSuperMeteoriteAfterDuration) {
            frameSpentSinceLastSuperMeteoriteAdded = 0;
            [self addSuperMeteorite];
        }
        frameSpentSinceLastScoreAdded++;
        if (frameSpentSinceLastScoreAdded == addScoreAfterDuration) {
            frameSpentSinceLastScoreAdded = 0;
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

-(void) meteoriteCreater:(CCNode *)meteorite withType:(NSString*)type
{
    [[GCCShapeCache sharedShapeCache] setBodyWithName:type onNode:meteorite];
    meteorite.physicsBody.collisionGroup = @"meteoriteGroup";
    meteorite.physicsBody.collisionType  = @"meteoriteCollision";
    [_physicsNode addChild:meteorite];
}

-(void) addMeteorite
{
    MeteoriteNode *meteorite = [[MeteoriteNode alloc] init];
    [self meteoriteCreater:meteorite withType:@"meteorite1"];
}

-(void) addSuperMeteorite
{
    SuperMeteoriteNode *meteorite = [[SuperMeteoriteNode alloc] init];
    [self meteoriteCreater:meteorite withType:@"meteorite2"];
}

-(void) addStar
{
    StartNode *star = [[StartNode alloc] init];
    [self addChild:star z:-1];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair meteoriteCollision:(MeteoriteNode *)meteorite playerCollision:(PlayerNode *)player {

    CGPoint point = player.position;
    [player removeFromParent];

    // particle
    CCParticleExplosion *particle = [[CCParticleExplosion alloc]init];
    particle.position = point;
    particle.autoRemoveOnFinish = YES;
    [self addChild:particle];
    
    // se
    [[OALSimpleAudio sharedInstance]playEffect:@"bomb.mp3"];

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
        [[GameScene sharedInstance] gameStart];
        
        // Score
        score = 0;
        NSString *targetString = [NSString stringWithFormat:@"%d",score];
        _scoreLabel = [[CCLabelBMFont alloc] initWithString:targetString
                                                             fntFile:@"font.fnt"];
        _scoreLabel.color = [CCColor whiteColor];
        _scoreLabel.position = ccp(self.contentSize.width/2, self.contentSize.height*0.95f);
        [self addChild:_scoreLabel];
    }
}

- (void) over
{
    is_start = FALSE;
    is_over = TRUE;
    
    [_scoreLabel removeFromParent];
    [[GameScene sharedInstance] gameOver:score];

}

@end
