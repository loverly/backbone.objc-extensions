//
//  BackboneRelationalModel.h
//  Groove
//
//  Created by Edmond Leung on 8/16/12.
//  Copyright (c) 2012 Groove Networks LLC. All rights reserved.
//

#import "BackboneModel.h"

@interface BackboneRelationalModel : BackboneModel

- (void)setupRelationships;

- (void)relateAttribute:(NSString *)attribute withModel:(Class)model;
- (void)relateAttribute:(NSString *)attribute withCollection:(Class)collection;

@end
