//
//  GameScene.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/02/23.
//  Copyright yoshinbo 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

#import "GameScene.h"
#import "IntroScene.h"
#import "PhysicsLayer.h"
#import "ResultLayer.h"

// -----------------------------------------------------------------------
#pragma mark - GameScene
// -----------------------------------------------------------------------

@implementation GameScene
{
    CCSprite *_sprite;
}

static GameScene *_scene = nil;

+ (GameScene *)sharedInstance {
    return _scene;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (GameScene *)scene
{
    if (_scene) {
        _scene = nil;
    }
    _scene = [[GameScene alloc] init];
    return _scene;
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);

    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;

    // Create a colored background (Dark Grey)
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    //[self addChild:background];

    // Add a sprite
    //_sprite = [CCSprite spriteWithImageNamed:@"Icon-72.png"];
    //_sprite.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    //[self addChild:_sprite];

    // Animate sprite with action
    //CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    //[_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];


    PhysicsLayer *physics = [[PhysicsLayer alloc]initWithContentSize:self.contentSize];
    [self addChild:physics];

    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];

    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Pr frame update is automatically enabled, if update is overridden

}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

- (void)gameOver
{
    ResultLayer *result = [[ResultLayer alloc] initWithContentSize:self.contentSize];
    [self addChild:result];
}

@end
