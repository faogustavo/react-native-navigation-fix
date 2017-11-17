# react-native-navigation-fix

Some fix for wix/react-native-navigation

Wix/React-native-navigation is a good component, especially for iOS, if still want to support old device. (Such as iPod touch 5).

But it do have some issues, while interact with react native, the problem wasn't design issue, actually all because of how react native works, it's one ROOT VIEW, one brigde system.

Here all fix only worked for iOS.

### Switch Tab - showing blink page

When RNN is running, the style 'flex:1', will bring this issue, try make container size by 'width:height' instead.

### Navigation - Push showing blink page

As RNN used native iOS component, it doesn't wait for the JS based react native view to be added, as the JS engine is slow and running in another thread, so it will showing a blink page before the content loaded.

To fix this, one way is to do real 'push' after the JS based view added, so :

- In React/Base, will added a category to extend the method of RCTRootContentView

```objc
//
//  RCTRootContentView+RCTRootContentViewExtension.h
//  React
//
//  Created by hello on 2017/11/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTRootContentView.h"

@interface RCTRootContentView (RCTRootContentViewExtension)

@end
```

```objc
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
```

- In RNN/RCCNavigationController/performAction - observe this notification, and then do the true 'push'

### Open Modal - showing blink page

The same as above, but this time: 

- In RCCManagerModule.m/showController - observe the notification, then do the true 'presentController'


