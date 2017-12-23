# react-native-navigation-fix

Some fix for wix/react-native-navigation

Wix/React-native-navigation is a good component, especially for iOS, if still want to support old device. (Such as iPod touch 5).

But it do have some issues, while interact with react native, the problem wasn't design issue, actually all because of how react native works, it's one ROOT VIEW, one brigde system.

Here all fix only worked for iOS.

### Touchable component stop working once after swipe back manually

It's common, by using several button replacement from react-native-gesture-handler, it's able to resolve it. 

https://github.com/wix/react-native-navigation/issues/2008

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

## How to use

- I am using react-native-navigation, "react-native-navigation": "^1.1.256"
- I changed the two files in react-native-navigation, by open your project in Xcode, you can see these files in Library folder
- To replace them wasn't recommended, by comparing difference and then merge the code I added would be better
- All code I have added with comment start with ```/// @@@Tom```, you can search and see them
- Those RCTRootContentView+RCTRootContentViewExtension two files, should drag and copy to Library/React/Base folder.

This fix was just a try-out, not really sure if it had some side-effects.. if you have found any, let me know, thanks in advance, I am using it now too.

