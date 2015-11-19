//
//  Calculator.swift
//  CurrencyCalculator
//
//  Created by Chijioke Ndubisi on 05/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

import Darwin

enum Op:Equatable{
    case binaryOperation(String, (Double, Double)-> Double)
    case operand(Double)
}

func ==(lhs: Op, rhs: Op) -> Bool {
    
    var mlhs:String?
    var mrhs:String?
    var dlhs: Double?
    var drhs:Double?
    
    switch lhs{
    case .binaryOperation(let text, _):
        mlhs = text
        break
        
    case .operand(let dl):
        dlhs = dl
        break
    }
    
    switch rhs{
    case .binaryOperation(let text, _):
        if (mlhs == nil){ return false }
        mrhs = text
        break
        
    case .operand(let dr):
        if (dlhs == nil){ return false }
        drhs = dr
    }
    
    return  (mrhs != nil) ? mlhs == mrhs : drhs == dlhs
}

extension Brain:Operations {
    
    mutating func pushOperand(digit:Double){
        opStack.append(.operand(Currencies().convert(digit)))
    }
    
    mutating func performOperation(symbol:String){
        if !self {
            if let operation = knownOps[symbol]{
                currentOperation = operation
                isTyping = false
            }
        }
    }
}

protocol Operations{
    mutating func pushOperand(digit:Double)
    mutating func performOperation(symbol:String)
}


struct Brain: BooleanType{
    private var knownOps = [String:Op]()
    private var isTyping:Bool = false
    var boolValue:Bool { get{return opStack.isEmpty } }
    var opStack = [Op]()
    var last:Double?{ get{ return result } }
    var ready:Bool { get{ return isTyping} }
    var currentOperation:Op?{
        willSet{
            if (currentOperation != nil) {
                if opStack.count > 2{
                    result = evaluate()
                }
            }
        }
        didSet{
            if (isOperation(opStack.last!) && opStack.last != currentOperation){
                opStack.removeAtIndex(opStack.count-1)
            }
            opStack.append(currentOperation!)
        }
    }
    
    private var result:Double?{
        didSet{
            opStack.removeAll()
            opStack.append(.operand(result!))
        }
    }
    
    mutating func update(value:Double){
        result = value
    }
    
    init(){
        knownOps["×"] = Op.binaryOperation("×",*)
        knownOps["+"] = Op.binaryOperation("+",+)
        knownOps["÷"] = Op.binaryOperation("÷",{$1/$0})
        knownOps["−"] = Op.binaryOperation("−",{$1-$0})
    }

    private func isOperation(operation: Op) -> Bool{
        switch operation{
        case .binaryOperation(_, _):
            return true
        case .operand(_):
            return false
        }
    }

    func evaluate (ops:[Op], _ firstOperand:Double?)-> (result: Double?, remainingOps:[Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .operand(let operand):
               return remainingOps.isEmpty ?   (operand, remainingOps): evaluate(remainingOps,operand)
            case .binaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps,firstOperand)
                if let operand2 = op1Evaluation.result {
                    return (operation(firstOperand!,operand2), op1Evaluation.remainingOps)
                }
            }
        }
        return (nil, ops)
    }
    
    mutating func evaluate()->Double?{
        let (result, _) = evaluate(opStack, nil)
        self.result = result
        return result
    }

    mutating func switchState(){
        isTyping = !isTyping
    }
}

