//
//  BackboneRelationalModel.m
//  Groove
//
//  Created by Edmond Leung on 8/16/12.
//  Copyright (c) 2012 Groove Networks LLC. All rights reserved.
//

#import "BackboneRelationalModel.h"

@interface BackboneRelationalModel ()

@property (nonatomic, strong) NSMutableDictionary *relatedModels;
@property (nonatomic, strong) NSMutableDictionary *relatedCollections;
@property (nonatomic, assign) BOOL relationshipsLoaded;

@end

@implementation BackboneRelationalModel

@synthesize relatedModels, relatedCollections;

- (BOOL)set:(NSDictionary *)attributes
    options:(BackboneOptions)options
errorCallback:(BackboneErrorBlock)errorCallback {
  NSMutableDictionary *mutableAttributes;
  NSDictionary *modelAttributes;
  NSArray *collectionJSON;
  BackboneModel *model;
  BackboneCollection *collection;
  
  [self loadRelationships];
  
  mutableAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
  
  // Turn related attributes to models.
  for (NSString *key in self.relatedModels)  {
    if ((modelAttributes = [attributes objectForKey:key]) &&
        [modelAttributes isKindOfClass:[NSDictionary class]]) {
      model = [[[self.relatedModels objectForKey:key] alloc] init];
      if ([model set:modelAttributes
             options:options | BackboneParseAttributes
       errorCallback:errorCallback]) {
        [mutableAttributes setObject:model forKey:key];
      } else {
        return NO;
      }
    }
  }
  
  // Turn related attributes to collections.
  for (NSString *key in self.relatedCollections)  {
    NSDictionary *info = [self.relatedCollections objectForKey:key];
    
    if ((collectionJSON = [attributes objectForKey:key]) &&
        [collectionJSON isKindOfClass:[NSArray class]]) {
      collection = [self get:key];
      if (collection) {
        [collection reset:collectionJSON];
      } else {
        collection = [[[info objectForKey:@"collection"] alloc]
                      initWithModel:[info objectForKey:@"model"]
                      models:collectionJSON
                      options:options| BackboneParseAttributes];
      }
      
      [mutableAttributes setObject:collection forKey:key];
    }
  }
  
  return
    [super set:mutableAttributes options:options errorCallback:errorCallback];
}

- (void)loadRelationships {
  if (self.relationshipsLoaded) return;
  self.relationshipsLoaded = YES;
  [self setupRelationships];
}

- (void)setupRelationships {
}

- (void)relateAttribute:(NSString *)attribute withModel:(Class)model {
  if (!self.relatedModels) {
    self.relatedModels = [NSMutableDictionary dictionary];
  }
  [self.relatedModels setObject:model forKey:attribute];
}

- (void)relateAttribute:(NSString *)attribute
         withCollection:(Class)collection
                ofModel:(Class)model {
  if (!self.relatedCollections) {
    self.relatedCollections = [NSMutableDictionary dictionary];
  }
  
  [self.relatedCollections setObject:
   @{ @"collection": collection, @"model": model }
                              forKey:attribute];
}

@end
