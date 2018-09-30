//
//  InterceptUnsatisfiableConstraints.h
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//
// thanks to Roman Ermolov, code at https://stackoverflow.com/questions/39168712/catch-uiviewalertforunsatisfiableconstraints-in-production

@import Foundation;

// swizzles an internal method to create a count of every time that UIViewAlertForUnsatisfiableConstraints is triggered
@interface InterceptUnsatisfiableConstraints : NSObject

// the number of times that UIViewAlertForUnsatisfiableConstraints has been triggered
+ (NSUInteger)callCount;

@end

static NSUInteger InterceptUnsatisfiableConstraintsCallCount;
