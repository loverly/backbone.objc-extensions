//
//  BackboneFilteredRouter.h
//  Loverly
//
//  Created by Edmond Leung on 8/9/12.
//  Copyright (c) 2012 Edmond Leung. All rights reserved.
//

#import "BackboneRouter.h"

@interface BackboneFilteredRouter : BackboneRouter {
 @private
  NSMutableArray *filters_;
  NSMutableArray *skippedFilters_;
}

- (void)beforeRoutesRun:(SEL)filter;
- (void)beforeRoutesSkip:(SEL)filter ;

- (void)run:(SEL)filter before:(SEL)route, ... NS_REQUIRES_NIL_TERMINATION;
- (void)skip:(SEL)filter before:(SEL)route, ... NS_REQUIRES_NIL_TERMINATION;

@end
