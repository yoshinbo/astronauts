//
//  BackgroundLayer.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/03/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer


- (BackgroundLayer *)initWithContentSize:(CGSize)contentSize
{
    self = [super init];

    if (self) {

        self.contentSize = contentSize;

        CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
        background.anchorPoint = ccp(0,0);

        [self addChild:background];

        // Attuch movement to Monster
        CCAction *actionMove = [CCActionMoveBy
                                actionWithDuration:60 position:CGPointMake(
                                                                            -background.contentSize.width,
                                                                            0
                                                                            )
                                ];
        CCAction *actionRemove = [CCActionRemove action];
        [self runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    }

    return self;
}


@end
