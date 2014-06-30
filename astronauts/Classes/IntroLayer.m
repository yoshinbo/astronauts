//
//  IntroLayer.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/03/08.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "IntroLayer.h"
#import "GameScene.h"
#import "AdLayer.h"

@implementation IntroLayer
{
    UIViewController* _viewController;
}

- (IntroLayer *)initWithContentSize:(CGSize)contentSize
{
    self = [super init];

    if (self) {

        self.contentSize = contentSize;

        // Title Label
        CCLabelBMFont* label1 = [[CCLabelBMFont alloc] initWithString:@"Space"
                                                             fntFile:@"Main.fnt"];
        label1.anchorPoint = ccp(0.5f, 0.5f);
        label1.position = ccp(self.contentSize.width/2,
                             self.contentSize.height/4*3);
        CCLabelBMFont* label2 = [[CCLabelBMFont alloc] initWithString:@"Ranger"
                                                             fntFile:@"Main.fnt"];
        label2.anchorPoint = ccp(0.5f, 0.5f);
        label2.position = ccp(self.contentSize.width/2,
                             self.contentSize.height/4*3-45);
        [self addChild:label1];
        [self addChild:label2];

        // Best Score
        int bestScore = [GameScene getBestScore];
        CCLabelBMFont *bestScoreLabel = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"Best Score %d", bestScore] fntFile:@"Normal.fnt"];
        bestScoreLabel.scale = 0.5f;
        bestScoreLabel.anchorPoint = ccp(0.5f, 0.5f);
        bestScoreLabel.position = ccp(self.contentSize.width/2,
                              self.contentSize.height/8*3-30);
        [self addChild:bestScoreLabel];

        // Start Rect
        self.userInteractionEnabled = YES;

        // Create ranking button
        CCButton *rankingButton = [CCButton buttonWithTitle:@"Ranking" fontName:@"RegencieLightAlt" fontSize:25.0f];
        rankingButton.positionType = CCPositionTypeNormalized;
        rankingButton.position = ccp(0.50f, 0.20f);
        [rankingButton setColor:[CCColor colorWithCcColor3b:ccc3(255, 255, 153)]];
        [rankingButton setTarget:self selector:@selector(onRankingClicked:)];
        [self addChild:rankingButton];

        // AdLayer
        AdLayer *_ad = [AdLayer layer];
        [self addChild:_ad];

    }

    return self;
}

- (void)onEnter
{
    [super onEnter];
    _viewController = [[UIViewController alloc] init];
    [[[CCDirector sharedDirector] view] addSubview:_viewController.view];
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [[GameScene sharedInstance] gameStart];
}

- (void)onRankingClicked:(id)sender
{
    GKLeaderboardViewController* leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil){
        leaderboardController.leaderboardDelegate = self;
        leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime; //全期間のハイスコアを表示
        leaderboardController.category = @"SpaceRanger.ranking";
        [_viewController presentViewController: leaderboardController animated: YES completion:nil];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [_viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
