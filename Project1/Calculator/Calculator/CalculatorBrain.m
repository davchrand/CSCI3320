//
//  CalculatorBrain.m
//  Calculator
//
//  Created by David Andrews on 2/1/15.
//  Copyright (c) 2015 edu.ucdenver.csci3320.davidandrews. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *) operandStack
{
    if (!_operandStack){
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (void) pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

- (double) popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}
//////////////////////////////////////////////////////////////
//performOperation handles the behind the scenes operation
//implimentations. It checks for dividing by zero and displays
//zero if divide by zero occurs.
//////////////////////////////////////////////////////////////
- (double) performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
        [self pushOperand:result];
    } else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
        [self pushOperand:result];
    } else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
        [self pushOperand:result];
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
        else if(divisor == 0) result = 0;
        [self pushOperand:result];
    }else if ([operation isEqualToString:@"sin"]){
        result = sin([self popOperand]);
        [self pushOperand:result];
    }else if ([operation isEqualToString:@"cos"]){
        result = cos([self popOperand]);
        [self pushOperand:result];
    }else if ([operation isEqualToString:@"sqrt"]){
        result = sqrt([self popOperand]);
        [self pushOperand:result];
    }else if ([operation isEqualToString:@"π"]){
        [self pushOperand:M_PI];
        result = M_PI;
    }else if ([operation isEqualToString:@"+/-"]){
        result = ([self popOperand] * -1);
        [self pushOperand:result];
    }
    
    //[self pushOperand:result];
    return result;
}
///////////////////////////////////////////////////////////////
//performClear sets the stack to 0.
//////////////////////////////////////////////////////////////
- (void) performClear
{
    _operandStack = 0;
    
}
@end
