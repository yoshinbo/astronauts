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

@implementation ResultLayer

- (ResultLayer *)initWithContentSize:(CGSize)contentSize
{
    self = [super init];

    if (self) {

        self.contentSize = contentSize;

        // Create a back button
        CCButton *backButton = [CCButton buttonWithTitle:@"[ Go Back ]" fontName:@"Verdana-Bold" fontSize:18.0f];
        backButton.positionType = CCPositionTypeNormalized;
        backButton.position = ccp(0.50f, 0.40f); // Top Right of screen
        [backButton setTarget:self selector:@selector(onBackClicked:)];
        [self addChild:backButton];

        // Label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:30];
        label.color = [CCColor whiteColor];
        label.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:label];

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
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------

@end
