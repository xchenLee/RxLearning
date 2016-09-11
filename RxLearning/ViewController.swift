//
//  ViewController.swift
//  RxLearning
//
//  Created by dreamer on 2016/9/10.
//  Copyright © 2016年 jasonleecom.lxc.rx. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyDemo()
        neverDemo()
        justDemo()
        sequenceDemo()
        fromDemo()
        createDemo()
        errorDemo()
        deferDemo()
        
        justWeakDemo()
        deferStrongDemo()
        
        publicSubjectDemo()
        replaySubjectDemo()
        behaviorSubjectDemo()
        
        variableDemo()
        
        testInfos()
    }
    
    
    func emptyDemo() {
        
        example("empty") {
            let emptySequence: Observable<Int> = Observable<Int>.empty()
            emptySequence.subscribe({ (event) in
                print(event)
            }).addDisposableTo(self.bag)
        }
    }
    
    func neverDemo() {
        
        example("never") { 
            let neverSequence = Observable<String>.never()
            neverSequence.subscribe({ (event) in
                print("never called")
            }).addDisposableTo(self.bag)
        }
    }
    
    func justDemo() {
        
        example("just") {
            let justSequence = Observable<String>.just("Just once")
            justSequence.subscribe({ (event) in
                print(event)
            }).addDisposableTo(self.bag)
        }
    }
    
    func sequenceDemo() {
        
        example("sequence") {
            let sequence = Observable<Int>.of(0,1,2,3,4)
            sequence.subscribe({ (event) in
                print(event)
            }).addDisposableTo(self.bag)
        }
    }
    
    func fromDemo() {
        
        example("from to observable") {
            let sequence = [0,1,2,3,4].toObservable()
            sequence.subscribe({ (event) in
                print(event)
            }).addDisposableTo(self.bag)
        }
    }
    
    func createDemo() {
        
        example("create") { 
            let myJust = { (element: Int) -> Observable<Int> in
            
                return Observable<Int>.create({ (observer) -> Disposable in
                    observer.on(.Next(element))
                    observer.on(.Completed)
                    
                    return NopDisposable.instance
                })
            }
            
            myJust(9).subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
        }
    }

    func errorDemo() {
        example("error") {
            
            let error = NSError(domain: "Test", code: -1, userInfo: nil)
            let erroredSequence = Observable<Int>.error(error)
            erroredSequence.subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
            
        }
    }
    
    func deferDemo() {
        example("deffer") { 
            
            let deferedSequence: Observable<Int> = Observable<Int>.deferred({ () -> Observable<Int> in
                
                print("deffered creating")
                
                return Observable<Int>.create({ (observer) -> Disposable in
                    print("emmiting")
                    observer.on(.Next(0))
                    observer.on(.Next(1))
                    return NopDisposable.instance
                })
            })
            
            print("go")
            
            deferedSequence.subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
            
            deferedSequence.subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
        }
    }
    
    func justWeakDemo() {
        
        example("justWeakDemo") { 
            
            var value: String? = nil
            let sequence = Observable<String?>.just(value)
            
            value = "hello just"
            
            sequence.subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
        }
        
    }
    
    func deferStrongDemo() {
        
        example("deferStrongDemo") { 
            
            var value: String? = nil
            let sequence = Observable<String?>.deferred({ () -> Observable<String?> in
                return Observable<String?>.just(value)
            })
            
            value = "hello defer"
            
            sequence.subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
            
        }
    }
    
    func publicSubjectDemo() {
        
        example("PublishSubject") {
            let subject = PublishSubject<String>()
            
            self.writeSequenceToConsole("1", sequence: subject)
            subject.on(.Next("a"))
            subject.on(.Next("b"))
            self.writeSequenceToConsole("2", sequence: subject)
            subject.on(.Next("c"))
            subject.on(.Next("d"))
        }
        
    }
    
    func replaySubjectDemo() {
        
        example("ReplaySubject") {
            let subject = ReplaySubject<String>.create(bufferSize: 2)
            
            subject.subscribe({ (event) in
                print("subject1 \(event)")
            })
            .addDisposableTo(self.bag)
            subject.on(.Next("a"))
            subject.on(.Next("b"))
            subject.subscribe({ (event) in
                print("subject2 \(event)")
            })
            .addDisposableTo(self.bag)
            subject.on(.Next("c"))
            subject.on(.Next("d"))
        }
        
    }
    
    func behaviorSubjectDemo() {
        
        example("BehaviorSubject") {
            let subject = BehaviorSubject<String>(value:"zz")
            
            subject.subscribe({ (event) in
                print("subject1 \(event)")
            })
                .addDisposableTo(self.bag)
            subject.on(.Next("a"))
            subject.on(.Next("b"))
            subject.subscribe({ (event) in
                print("subject2 \(event)")
            })
                .addDisposableTo(self.bag)
            subject.on(.Next("c"))
            subject.on(.Next("d"))
        }
        
    }
    
    func variableDemo() {
        
        example("variableDemo") {
            let variable = Variable("zz")
            
            
            variable.asObservable().subscribe({ (event) in
                print("subject1 \(event)")
            })
            .addDisposableTo(self.bag)
            variable.value = "a"
            variable.value = "b"
            variable.asObservable().subscribe({ (event) in
                print("subject2 \(event)")
            })
            .addDisposableTo(self.bag)
            variable.value = "c"
        }
        
    }
    
    func testInfos() {
        
        example("map") { 
            
            let sequence = Observable<Int>.of(0,1,2,3)
            sequence.map({ (num) -> Int in
                return num * 2
            })
            .subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
        }
        
        example("flatmap") { 
            let sequenceInt = Observable<Int>.of(0,1,2,3)
            let sequenceString = Observable<String>.of("A","B","C","D")
            
            sequenceInt.flatMap({ (int) -> Observable<String> in
                return sequenceString
            })
            .subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
        }
        
        
    }

    
    
    // MARK: - print example
    func example(description: String, action:()->()) {
        print("\n --- \(description) example ---")
        action()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func writeSequenceToConsole<O: ObservableType>(name: String, sequence: O) {
        sequence
            .subscribe { e in
                print("Subscription: \(name), event: \(e)")
        }
        .addDisposableTo(self.bag)
    }


}

