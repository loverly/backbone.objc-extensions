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

@interface BackboneLayoutManager ()

@end

@implementation BackboneLayoutManager

@synthesize visibleLayout = visibleLayout_;
@synthesize viewController = viewController_;

+ (BackboneLayoutManager *)sharedLayoutManager {
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (id)init {
  self = [super init];
  if (self) {
    [UIApplication sharedApplication].keyWindow.rootViewController =
      viewController_ = [[UINavigationController alloc] init];
    viewController_.navigationBarHidden = YES;
  }
  return self;
}

- (void)setLayoutWithClass:(Class)layoutClass {
  UIViewController<BackboneLayout> *layout;
  UIWindow *window;
  
  if (!layouts_) layouts_ = [NSMutableDictionary dictionary];
  
  // If layout doesn't exist yet, create it.
  if (!(layout = [layouts_ objectForKey:layoutClass])) {
    [layouts_ setObject:layout = [[layoutClass alloc] init]
                 forKey:layoutClass];
  }
  
  window = [UIApplication sharedApplication].keyWindow;
  
  // Ignore setting of layout if the layout hasn't changed.
  if (self.visibleLayout == layout) return;

  if (self.visibleLayout) {
    CATransition* transition = [CATransition animation];
    
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionFade;
    
    [self.viewController.view.layer removeAllAnimations];
    [self.viewController.view.layer addAnimation:transition forKey:kCATransition];
  }
  
  layout.view.frame = self.viewController.view.bounds;
  self.viewController.viewControllers = @[ layout ];
  
  visibleLayout_ = layout;
}

- (void)resetLayoutWithClass:(Class)layoutClass {
  [layouts_ removeObjectForKey:layoutClass];
}

@end
