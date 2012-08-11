//
//  BackboneLayoutManager.h
//  Loverly
//
//  Created by Edmond Leung on 8/10/12.
//  Copyright (c) 2012 Edmond Leung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BackboneLayout;

@interface BackboneLayoutManager : NSObject {
 @private
  NSMutableDictionary *layouts_;
}

@property (nonatomic, readonly) UIViewController<BackboneLayout> *visibleLayout;

+ (BackboneLayoutManager *)sharedLayoutManager;

- (void)setLayoutWithClass:(Class)layoutClass;

@end
