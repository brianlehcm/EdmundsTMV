//
//  UIView+Reponder.m
//  EdmundsTMV
//
//  Created by le brian on 4/7/16.
//  Copyright © 2016 brianle. All rights reserved.
//

#import "UIView+Reponder.h"

@implementation UIView (Reponder)

- (id)firstResponder {
    if (self.isFirstResponder) return self;
    for (UIView __weak *subView in self.subviews) {
        if ([subView firstResponder]) return subView;
    }
    return nil;
}

- (BOOL)findAndResignFirstResponder {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView __weak *subView in self.subviews) {
        if ([subView findAndResignFirstResponder]) return YES;
    }
    return NO;
}

@end
