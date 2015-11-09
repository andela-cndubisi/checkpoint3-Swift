//
//  Calculator.swift
//  CurrencyCalculator
//
//  Created by Chijioke Ndubisi on 05/11/2015.
//  Copyright © 2015 andela-cj. All rights reserved.
//

struct Brain {
    var opStack = [Op]()
    var isTyping:Bool = false
    var knownOps = [String:Op]()
    var currentOperation:Op?{
        willSet{
            if (currentOperation != nil) {
                if opStack.count > 2{
                    result = evaluate()
                }
            }
        }
        didSet{
            opStack.append(currentOperation!)
        }
    }
    var result:Double?{
        didSet{
            opStack.removeAll()
            opStack.append(.operand(result!))
            
        }
    }

    
    mutating func addDigit(digit:Double){
        opStack.append(.operand(digit))
        isTyping = false
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

    enum Op{
        case binaryOperation(String, (Double, Double)-> Double)
        case operand(Double)
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
