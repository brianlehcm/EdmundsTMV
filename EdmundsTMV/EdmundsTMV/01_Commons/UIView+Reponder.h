//
//  UIView+Reponder.h
//  EdmundsTMV
//
//  Created by le brian on 4/7/16.
//  Copyright © 2016 brianle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Reponder)

- (id)firstResponder;

- (BOOL)findAndResignFirstResponder;

@end
