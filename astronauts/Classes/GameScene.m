//
//  GameScene.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/02/23.
//  Copyright yoshinbo 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

#import "GameScene.h"
#import "IntroLayer.h"
#import "PhysicsLayer.h"
#import "ResultLayer.h"
#import "BackgroundLayer.h"
#import "AdLayer.h"
#import "OALSimpleAudio.h"
#import <GameKit/GameKit.h>

// -----------------------------------------------------------------------
#pragma mark - GameScene
// -----------------------------------------------------------------------

@implementation GameScene
{
    CCSprite *_sprite;
    BOOL _isGameOver;
    PhysicsLayer* _physics;
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

    // Sprites
    CCSpriteBatchNode *spritesBgNode;
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:@"sprites.pvr.ccz"];
    [self addChild:spritesBgNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];

    BackgroundLayer *background = [[BackgroundLayer alloc]initWithContentSize:self.contentSize];
    [self addChild:background];

    _physics = [[PhysicsLayer alloc]initWithContentSize:self.contentSize];
    [self addChild:_physics];

    IntroLayer *intro = [[IntroLayer alloc] initWithContentSize:self.contentSize];
    [self addChild:intro z:0 name:@"intro"];

    [[OALSimpleAudio sharedInstance]preloadEffect:@"jump.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"bomb.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"fire.mp3"];
    [[OALSimpleAudio sharedInstance]playBg:@"bgm.mp3" loop:YES];

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

    // Game Center
    [GameScene updateGameCenter];

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

- (void)gameStart
{
    CCNode *intro = [self getChildByName:@"intro" recursively:FALSE];
    if (intro) {
        [self removeChild:intro];
    }
    [_physics Start];
}

- (void)gameOver:(int)score
{
    if (!_isGameOver) {
        bool isBest = [GameScene updateBestScore:score];
        ResultLayer *result = [[ResultLayer alloc] initWithContentSize:self.contentSize :score :isBest];
        [self addChild:result];
        _isGameOver = YES;
    }
}

// plistのデータを取得する
+ (NSString *)getDataPlistPass
{
    return [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
}

+ (NSDictionary*)getDataPlist
{
    NSString *path = [self getDataPlistPass];
    return [NSMutableDictionary dictionaryWithContentsOfFile:path];
}

+ (int)getBestScore
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"bestScore"];
}

+ (bool)updateBestScore:(int)newScore
{
    bool isBest = false;
    int score = [GameScene getBestScore];
    if (newScore > score) {
        [[NSUserDefaults standardUserDefaults] setInteger:newScore forKey:@"bestScore"];
        score = newScore;
        isBest = true;
    }
    return isBest;
}

+ (void)updateGameCenter
{
    // GameCenter
    int bestScore = [GameScene getBestScore];
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error){
        if (localPlayer.isAuthenticated)
        {
            //認証
            NSArray* playerID = [[NSArray alloc] initWithObjects:localPlayer.playerID, nil]; //自分のプレイヤーIDのみのArrayを用意
            GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] initWithPlayerIDs:playerID];
            if (leaderboardRequest != nil) {
                leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
                leaderboardRequest.category = @"SpaceRanger.ranking";
                leaderboardRequest.range = NSMakeRange(1,1); //一番良いスコアを読み出す
                // ベストスコアをGame Centerから読み出す
                [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
                    if (error != nil) {
                    }
                    int highScore;
                    if (scores != nil) {
                        highScore = ((GKScore *)[scores objectAtIndex:0]).value;
                    } else {
                        // 初回プレイ時はscoresがnilなので0ハイスコアを0とする。
                        highScore = 0;
                    }
                    if (highScore > bestScore) { // Game Centerのスコアが高い場合NSUserDefaultsをそれに合わせる
                        [GameScene updateBestScore:highScore];
                    } else { //NSUserDefaultsのスコアが高い場合GameCenterをそれに合わせる
                        GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"SpaceRanger.ranking"];
                        scoreReporter.value = bestScore;
                        scoreReporter.context = 0;
                        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
                        }];
                    }
                }];
            }
        }
        else {
            //認証されず
        }
    }];
}

@end
