//
//  ResultLayer.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/03/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "ResultLayer.h"
#import "GameScene.h"
#import "PhysicsLayer.h"
#import "AdLayer.h"

@implementation ResultLayer

- (ResultLayer *)initWithContentSize:(CGSize)contentSize :(int)score :(BOOL)isBest
{
    self = [super init];

    if (self) {

        self.contentSize = contentSize;

        // Create a back button
        CCButton *backButton = [CCButton buttonWithTitle:@"[ Go Back ]" fontName:@"Verdana-Bold" fontSize:18.0f];
        backButton.positionType = CCPositionTypeNormalized;
        backButton.position = ccp(0.50f, 0.20f);
        [backButton setTarget:self selector:@selector(onBackClicked:)];
        [self addChild:backButton];

        // Label
        CCLabelBMFont* label = [[CCLabelBMFont alloc] initWithString:@"Game Over"
                                                              fntFile:@"font.fnt"];
        label.anchorPoint = ccp(0.5f, 0.5f);
        label.position = ccp(self.contentSize.width/2, self.contentSize.height/2 + 75);
        [self addChild:label];
        
        // Score
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score : %d", score] fontName:@"Verdana-Bold" fontSize:18.0f];
        scoreLabel.positionType = CCPositionTypeNormalized;
        scoreLabel.position = ccp(0.50f, 0.50f);
        [self addChild:scoreLabel];

        // Best Score
        if (isBest) {
            CCLabelTTF *bestScoreLabel = [CCLabelTTF labelWithString:@"This is The Best Score!!!" fontName:@"Verdana-Bold" fontSize:18.0f];
            bestScoreLabel.positionType = CCPositionTypeNormalized;
            bestScoreLabel.position = ccp(0.50f, 0.45f);
            [self addChild:bestScoreLabel];
        }
        
        // Ad
        AdLayer *_ad = [AdLayer layer];
        [self addChild:_ad];
    }

    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:1.0f]];
}

// -----------------------------------------------------------------------

@end
