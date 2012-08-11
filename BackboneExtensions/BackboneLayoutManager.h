//
//  BackboneLayoutManager.h
//  Loverly
//
//  Created by Edmond Leung on 8/10/12.
//  Copyright (c) 2012 Edmond Leung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackboneLayoutManager : NSObject {
 @private
  NSMutableDictionary *layouts_;
}

+ (id)sharedLayoutManager;

- (void)setLayout:(Class)layoutClass;

@end
