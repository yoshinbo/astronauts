//
//  AdLayer.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/04/30.
//  Copyright 2014年 yoshinbo. All rights reserved.
//

#import "AdLayer.h"

@implementation AdLayer
{
    GADBannerView* _gadView;
    BOOL _bannerIsVisible;
}

+ (id)layer
{
    return [[self alloc] initLayer];
}

- (id)initLayer
{
    if ((self = [super init])) {
        _bannerIsVisible = NO;
        
        // AdMob設定
        //CGSize winSize = [CCDirector sharedDirector].winSize;
        CGSize winSize = [[CCDirector sharedDirector] viewSize];
        _gadView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
//        _gadView.adUnitID = @"XXXXXXXXXXXXXXXXXXXX"; //ここにはAdMobサイトに表示されるメディエーションIDを入れる
//        _gadView.rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//        [[[CCDirector sharedDirector] view] addSubview:_gadView];
//        _gadView.frame = CGRectOffset(_gadView.frame, 0, winSize.height);
//        _gadView.delegate = self;
//        [_gadView loadRequest:[GADRequest request]];
    }
    return self;
}

- (void)dealloc
{
//    [_gadView removeFromSuperview];
//    _gadView = nil;
}

//AdMob取得成功
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
//    if (!_bannerIsVisible) {
//        [UIView animateWithDuration:0.3 animations:^{
//            _gadView.frame = CGRectOffset(view.frame, 0, -view.frame.size.height);
//        }];
//        _bannerIsVisible = YES;
//    }
}

//AdMob取得失敗
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
//    [_gadView removeFromSuperview];
//    _gadView = nil;
}

@end
