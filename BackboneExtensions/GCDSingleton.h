//
//  GCDSingleton.h
//  Loverly
//
//  Created by Edmond Leung on 8/6/12.
//  Copyright (c) 2012 Edmond Leung. All rights reserved.
//

#ifndef DEFINE_SHARED_INSTANCE_USING_BLOCK
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
  static dispatch_once_t pred = 0; \
  __strong static id _sharedObject = nil; \
  dispatch_once(&pred, ^{ \
    _sharedObject = block(); \
  }); \
  return _sharedObject; \

#endif