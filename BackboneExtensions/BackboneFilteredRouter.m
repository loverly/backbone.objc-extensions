//
//  BackboneFilteredRouter.m
//  Loverly
//
//  Created by Edmond Leung on 8/9/12.
//  Copyright (c) 2012 Edmond Leung. All rights reserved.
//

#import "BackboneFilteredRouter.h"
#import "Backbone.h"
#import "BackboneRouterSubclass.h"

#define VarRoutes(_last_) ({ \
  NSMutableArray *__args = [NSMutableArray array]; \
  if (_last_) { \
    [__args addObject:NSStringFromSelector(_last_)]; \
    SEL obj; \
    va_list ap; \
    va_start(ap, _last_); \
    while ((obj = va_arg(ap, SEL))) { \
      [__args addObject:NSStringFromSelector(obj)]; \
    } \
    va_end(ap); \
  } \
  __args; })

@implementation BackboneFilteredRouter

- (void)beforeRoutesRun:(SEL)filter {
  [self run:filter beforeRoutes:@[ @"*" ]];
}

- (void)beforeRoutesSkip:(SEL)filter {
  [self skip:filter beforeRoutes:@[ @"*" ]];
}

- (void)run:(SEL)filter beforeRoutes:(NSArray *)routes {
  if (!filters_) filters_ = [NSMutableArray array];
  [filters_ addObject:@{
    @"filter": NSStringFromSelector(filter), @"routes": routes
  }];
}

- (void)run:(SEL)filter before:(SEL)route, ... NS_REQUIRES_NIL_TERMINATION {
  [self run:filter beforeRoutes:VarRoutes(route)];
}

- (void)skip:(SEL)filter beforeRoutes:(NSArray *)routes {
  if (!skippedFilters_) skippedFilters_ = [NSMutableArray array];
  [skippedFilters_ addObject:@{
    @"filter": NSStringFromSelector(filter), @"routes": routes
  }];
}

- (void)skip:(SEL)filter before:(SEL)route, ... NS_REQUIRES_NIL_TERMINATION {
  [self skip:filter beforeRoutes:VarRoutes(route)];
}

- (void)route:(id)route to:(SEL)selector named:(NSString *)name  {
  if ([route isKindOfClass:[NSString class]]) {
    route = [self routeToRegExp:route];
  }
  
  id callback = ^(NSString *url) {
    NSDictionary *filterSet, *skippedFilterSet;
    SEL filter, skippedFilter;
    NSArray *routes, *skippedRoutes;
    
    // Run through filter chain.
    for (filterSet in filters_) {
      filter = NSSelectorFromString([filterSet objectForKey:@"filter"]);
      routes = [filterSet objectForKey:@"routes"];
      
      // Check whether we should skip the filter.
      for (skippedFilterSet in skippedFilters_) {
        skippedFilter =
          NSSelectorFromString([skippedFilterSet objectForKey:@"filter"]);
        skippedRoutes = [skippedFilterSet objectForKey:@"routes"];
        
        if (skippedFilter == filter &&
            ([skippedRoutes containsObject:@"*"] ||
             [skippedRoutes containsObject:name])) {
              routes = nil;
              break;
        }
      }
      
      if ([routes containsObject:@"*"] || [routes containsObject:name]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (!([self respondsToSelector:filter] &&
              !![self performSelector:filter withObject:url])) return;
#pragma clang diagnostic pop
      }
    }
    
    NSArray *args = [self extractParameters:route url:url];
    NSString *eventName = [NSString stringWithFormat:@"route:%@", name];
    
    if ([self respondsToSelector:selector]) {
      [self performSelector:selector withObjects:args];
    }
    
    [self trigger:eventName argumentsArray:args];
    [[Backbone history] trigger:@"route" arguments:self, name, args, nil];
  };
  
  [[Backbone history] route:route toCallback:callback];
}

@end
