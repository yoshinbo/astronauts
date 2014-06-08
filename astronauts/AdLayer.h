//
//  AdLayer.h
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/04/30.
//  Copyright 2014年 yoshinbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GADBannerView.h"

@interface AdLayer : CCNode <GADBannerViewDelegate>
{
    
}

+ (id)layer;

@end
