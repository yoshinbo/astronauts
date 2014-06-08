//
//  AdLayer.h
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/06/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GADBannerView.h"
#import "NADIconLoader.h"
#import "NADIconView.h"

@interface AdLayer : CCNode  <GADBannerViewDelegate, NADIconLoaderDelegate>

+ (AdLayer *)layer;

@end
