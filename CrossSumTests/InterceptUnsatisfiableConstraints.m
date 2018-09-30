//
//  SwizzledUnstaisfiableConstraints.m
//  CrossSumTests
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//
// thanks to Roman Ermolov, code at https://stackoverflow.com/questions/39168712/catch-uiviewalertforunsatisfiableconstraints-in-production

//#import <UIKit/Foundation.h>
@import UIKit;
#import <objc/runtime.h>
#import "InterceptUnsatisfiableConstraints.h"

void SwizzleInstanceMethod(Class classToSwizzle, SEL origSEL, Class myClass, SEL newSEL) {
    Method methodToSwizzle = class_getInstanceMethod(classToSwizzle, origSEL);
    Method myMethod = class_getInstanceMethod(myClass, newSEL);
    class_replaceMethod(classToSwizzle, newSEL, method_getImplementation(methodToSwizzle), method_getTypeEncoding(methodToSwizzle));
    class_replaceMethod(classToSwizzle, origSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
}


@implementation InterceptUnsatisfiableConstraints

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        InterceptUnsatisfiableConstraintsCallCount = 0;
        SEL willBreakConstantSel = NSSelectorFromString(@"engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:");
        SwizzleInstanceMethod([UIView class], willBreakConstantSel, [self class], @selector(pr_engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:));
    });
}

+ (NSUInteger)callCount {
    return InterceptUnsatisfiableConstraintsCallCount;
}

- (void)pr_engine:(id)engine willBreakConstraint:(NSLayoutConstraint*)constraint dueToMutuallyExclusiveConstraints:(NSArray<NSLayoutConstraint*>*)layoutConstraints {
    BOOL constrainsLoggingSuspended = [[self valueForKey:@"_isUnsatisfiableConstraintsLoggingSuspended"] boolValue];
    if (!constrainsLoggingSuspended) {
        NSLog(@"_UIViewAlertForUnsatisfiableConstraints would be called on next line, log this event");
        InterceptUnsatisfiableConstraintsCallCount++;
    }
    [self pr_engine:engine willBreakConstraint:constraint dueToMutuallyExclusiveConstraints:layoutConstraints];
}

@end
