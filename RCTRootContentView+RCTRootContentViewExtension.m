//
//  RCTRootContentView+RCTRootContentViewExtension.m
//  React
//
//  Created by hello on 2017/11/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTRootContentView+RCTRootContentViewExtension.h"

@implementation RCTRootContentView (RCTRootContentViewExtension)

/// @@@Tom
#if true
- (void)didAddSubview:(UIView *)subview
{
  [[NSNotificationCenter defaultCenter]
   postNotificationName:@"DidAddReactComponent"
   object:self userInfo:@{@"view": subview}];
}
#endif

@end
