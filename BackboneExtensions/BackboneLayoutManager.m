//
//  BackboneLayoutManager.m
//  Loverly
//
//  Created by Edmond Leung on 8/10/12.
//  Copyright (c) 2012 Edmond Leung. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BackboneLayoutManager.h"
#import "GCDSingleton.h"
#import "BackboneLayout.h"

@implementation BackboneLayoutManager

+ (BackboneLayoutManager *)sharedLayoutManager {
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (UIViewController<BackboneLayout> *)visibleLayout {
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  
  if ([window.rootViewController conformsToProtocol:@protocol(BackboneLayout)]) {
    return (UIViewController<BackboneLayout> *)window.rootViewController;
  }
  
  return nil;
}

- (void)setLayoutWithClass:(Class)layoutClass {
  UIViewController *layout;
  UIWindow *window;
  
  if (!layouts_) layouts_ = [NSMutableDictionary dictionary];
  
  // If layout doesn't exist yet, create it.
  if (!(layout = [layouts_ objectForKey:layoutClass])) {
    [layouts_ setObject:layout = [[layoutClass alloc] init]
                 forKey:layoutClass];
  }
  
  window = [UIApplication sharedApplication].keyWindow;
  
  // Ignore setting of layout if the layout hasn't changed.
  if (window.rootViewController == layout) return;
  
  // If a previous rootViewController exists, then animate the new layout.
  if (window.rootViewController) {
    CATransition* transition = [CATransition animation];
    
    transition.timingFunction =
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionFade;
    
    [window.layer removeAllAnimations];
    [window.layer addAnimation:transition forKey:kCATransition];
  }
  
  window.rootViewController = layout;
}

@end
