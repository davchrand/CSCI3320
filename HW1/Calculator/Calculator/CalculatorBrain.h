//
//  CalculatorBrain.h
//  Calculator
//
//  Created by David Andrews on 2/1/15.
//  Copyright (c) 2015 edu.ucdenver.csci3320.davidandrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double)operand;
- (double) performOperation:(NSString *)operation;

@end
