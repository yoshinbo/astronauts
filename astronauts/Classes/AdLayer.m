//
//  AdLayer.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/06/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "AdLayer.h"

static const int icon_num = 4;
static const int icon_width = 75;
static const int icon_height = 75;

@implementation AdLayer
{
    BOOL _bannerIsVisible;
    GADBannerView* _gadView;
    NSMutableArray* nadIconViewArray;
    NADIconLoader* iconLoader;
}

+ (AdLayer *)layer
{
    return [[self alloc]init];
}

- (AdLayer *)init
{
    self = [super init];
    
    if (self) {
        
        _bannerIsVisible = NO;
        
        // AdMob設定
        _gadView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        //_gadView.adUnitID = @"a15179168f4c6bf";
        _gadView.adUnitID = @"ca-app-pub-4352710131585096/8247605563";
        _gadView.rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [[[CCDirector sharedDirector] view] addSubview:_gadView];
        _gadView.frame = CGRectOffset(_gadView.frame, 0, -_gadView.frame.size.height);
        _gadView.delegate = self;
        [_gadView loadRequest:[GADRequest request]];
        
        // Nend設定
        nadIconViewArray = [[NSMutableArray alloc] init];
        CGSize winSize = [CCDirector sharedDirector].viewSize;
        int offset = ((winSize.width/icon_num) - icon_width)/2;
        int margin = ((winSize.width/icon_num) - icon_width);
        
        iconLoader = [[NADIconLoader alloc] init];
        [iconLoader setIsOutputLog:YES];
        
        for (int i = 0; i < icon_num; i++) {
            CGRect iconFrame;
            iconFrame.origin = CGPointMake(
                                           offset + (icon_width + margin ) * i,
                                           winSize.height - (icon_height + margin)
                                           );
            iconFrame.size = CGSizeMake(icon_width, icon_height);
            NADIconView *_iconView = [[NADIconView alloc] initWithFrame:iconFrame];
            [[[CCDirector sharedDirector] view] addSubview:_iconView];
            [iconLoader addIconView:_iconView];
            [nadIconViewArray addObject:_iconView];
        }
        
        //[iconLoader setNendID:@"2349edefe7c2742dfb9f434de23bc3c7ca55ad22" spotID:@"101281"];
        [iconLoader setNendID:@"7fda435b212e36b8dc38a444931778420eecc230" spotID:@"182273"];
        [iconLoader setDelegate:self];
        [iconLoader load];
    }
    
    return self;
}

//AdMob取得成功
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if (!_bannerIsVisible) {
        [UIView animateWithDuration:0.3 animations:^{
            _gadView.frame = CGRectOffset(view.frame, 0, view.frame.size.height);
        }];
        _bannerIsVisible = YES;
    }
}

//AdMob取得失敗
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    [_gadView removeFromSuperview];
    _gadView = nil;
}

// Nend取得成功
- (void)nadIconLoaderDidFinishLoad:(NADIconLoader *)iconLoader{
    NSLog(@"nend success");
}

// Nend取得失敗
- (void)nadIconLoaderDidFailToReceiveAd:(NADIconLoader *)iconLoader
{
    NSLog(@"nend fail");
}

- (void) dealloc {
    [_gadView removeFromSuperview];
    _gadView.delegate = nil;
    _gadView = nil;
    
    if (nadIconViewArray!=nil) {
        int itemsize = [nadIconViewArray count];
        for (int i=0; i < itemsize; i++) {
            NADIconView* _iconView = (NADIconView*)[nadIconViewArray objectAtIndex:i];
            [iconLoader removeIconView:_iconView];
            [_iconView removeFromSuperview];
        }
    }
    [nadIconViewArray removeAllObjects];
    [iconLoader setDelegate:nil]; // delegate に nil をセット
    iconLoader = nil; // プロパティ経由で release、nil をセット
    
}

@end
