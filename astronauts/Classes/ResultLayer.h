//
//  ResultLayer.h
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/03/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface ResultLayer : CCNode

- (ResultLayer *)initWithContentSize:(CGSize)contentSize :(int)score :(BOOL)isBest;
@end