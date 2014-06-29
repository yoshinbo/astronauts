//
//  IntroLayer.h
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/03/08.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import <GameKit/GameKit.h>

@interface IntroLayer : CCNode <GKLeaderboardViewControllerDelegate>

- (IntroLayer *)initWithContentSize:(CGSize)contentSize;

@end
