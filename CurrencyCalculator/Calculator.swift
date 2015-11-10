//
//  Calculator.swift
//  CurrencyCalculator
//
//  Created by Chijioke Ndubisi on 05/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//


enum Op:Equatable{
    case binaryOperation(String, (Double, Double)-> Double)
    case operand(Double)
}

func ==(lhs: Op, rhs: Op) -> Bool {
    
    var mlhs:String?
    var mrhs:String?
    let isDouble = false
    
    switch lhs{
    case .binaryOperation(let text, _):
        mlhs = text
        break
        
    case .operand(_):
        return isDouble
        
    }
    
    switch rhs{
    case .binaryOperation(let text, _):
        mrhs = text
        break
        
    case .operand(_):
        return isDouble
        
    }
    
    return mlhs == mrhs
}

struct Brain {
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    private var isTyping:Bool = false

    var ready:Bool {get{return isTyping}}
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
    
    var result:Double?{
        didSet{
            opStack.removeAll()
            opStack.append(.operand(result!))
            
        }
    }
    
    mutating func switchState(){
        isTyping = !isTyping
    }

    mutating func addDigit(digit:Double){
        opStack.append(.operand(digit))
        isTyping = false
    }
    
    
    private func isOperation(operation: Op) -> Bool{
        switch operation{
        case .binaryOperation(_, _):
            return true
        case .operand(_):
            return false
        }
    }
    
    init(){
        knownOps["×"] = Op.binaryOperation("×",*)
        knownOps["+"] = Op.binaryOperation("+",+)
        knownOps["÷"] = Op.binaryOperation("÷",{$1/$0})
        knownOps["−"] = Op.binaryOperation("−",{$1-$0})
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
    
    func evaluate()->Double?{
        let (result, _) = evaluate(opStack, nil)
        return result
    }

 

    mutating func pushOperand(digit:Double){
        opStack.append(.operand(digit))
    }
    
    mutating func performOperation(symbol:String){
        if let operation = knownOps[symbol]{
            currentOperation = operation
            isTyping = false
        }
    }

}

