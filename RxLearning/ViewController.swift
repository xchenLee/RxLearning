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
        
        example("scan") { 
            
            let scanResource = Observable<Int>.of(0,1,2,3)
            scanResource.scan(0, accumulator: { (sum, ele) -> Int in
                sum + ele
            })
            .subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
            
        }
        
        example("Filtering") { 
            
            let subscription = Observable<Int>.of(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18)
            subscription.filter({ (num) -> Bool in
                num % 2 == 0
            })
            .subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
        }
        
        example("distinctUntilChanged") { 
            //去掉相邻相同元素
            let subscription = Observable<Int>.of(1,2,2,3,3,4,4,4,5,1)
            subscription.distinctUntilChanged()
            .subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
        }
        
        example("take") { 
            //只取前两个
            let sequence = Observable<Int>.of(1,2,3,4,5,6)
            sequence.take(2)
            .subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
        }
        
        example("startWith") { 
            //在开始插入一个事件
            let sequence = Observable<Int>.of(4,5,6)
            sequence
            .startWith(4)
            .subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
        }
        
        example("combinelatest") { 
            
            //每当一个队列发生新的事件的时候，跟另外的队列取最好一条合并，如果为空不合并，
            let initObj1 = PublishSubject<String>()
            let initObj2 = PublishSubject<Int>()
            
            Observable<String>.combineLatest(initObj1, initObj2, resultSelector: { (a, b) -> String in
                "\(a) \(b)"
            })
            .subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
            
            initObj1.onNext("a")
            initObj2.onNext(1)
            initObj1.onNext("b")
        
        }
        
        
        example("zip") { 
            
            //就像拉链一样，两个源的数据必须数量是一致的的，才能合并
            let sub1 = PublishSubject<String>()
            let sub2 = PublishSubject<Int>()
            Observable<String>.zip(sub1, sub2, resultSelector: { (a, b) -> String in
                "\(a) \(b)"
            })
            .subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
            
            sub1.onNext("A")
            sub2.onNext(1)
            sub1.onNext("B")
            sub2.onNext(2)

        }
        
        example("merge") { 
            
            //两个队列合并在一起
            let sub1 = PublishSubject<Int>()
            let sub2 = PublishSubject<Int>()
            Observable<PublishSubject<Int>>
                .of(sub1, sub2)
                .merge()
                .subscribe({ (event) in
                    print(event)
                })
                .addDisposableTo(self.bag)
            
            sub1.onNext(1)
            sub2.onNext(2)
        }
        
        example("switch") { 
            
            let var1 = Variable(1)
            let var2 = Variable(2)
            
            let var3 = Variable(var1.asObservable())
            
            var3.asObservable().switchLatest()
            .subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
            
            var1.value = 3
            var3.value = var2.asObservable()
            
            var2.value = 100
        }
        
        example("catchError") { 
            let seq = PublishSubject<Int>()
            let seq2 = Observable<Int>.of(100,200)
            
            seq.catchError({ (error) -> Observable<Int> in
                
                return seq2
            })
            .subscribeNext({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
            
            seq.onNext(1)
            seq.onNext(2)
            seq.onError(NSError(domain: "error", code: -11, userInfo: nil))
            
        }
        
        example("retry") { 
            
            var count = 1
            let seq = Observable<Int>.create({ (observer) -> Disposable in
                
                let error = NSError(domain: "error", code: 111, userInfo: nil)
                observer.on(.Next(0))
                observer.on(.Next(1))
                if count < 2 {
                    observer.on(.Error(error))
                    count = 2
                }
                observer.on(.Next(2))
                
                return NopDisposable.instance
            })
            
            seq.retry().subscribe({ (event) in
                print(event)
            })
            .addDisposableTo(self.bag)
        }
        
        example("subscribe") {
            let sequenceOfInts = PublishSubject<Int>()
            sequenceOfInts
                .subscribe {
                    print($0)
            }
            .addDisposableTo(self.bag)
            sequenceOfInts.on(.Next(1))
            sequenceOfInts.on(.Completed)
        }
        
        example("subscribeNext") {
            let sequenceOfInts = PublishSubject<Int>()
            sequenceOfInts
                .subscribeNext {
                    print($0)
            }
            .addDisposableTo(self.bag)
            
            sequenceOfInts.on(.Next(1))
            sequenceOfInts.onCompleted()
        }

        example("subscribeCompleted") {
            let sequenceOfInts = PublishSubject<Int>()
            sequenceOfInts
                .subscribeCompleted {
                    print("It's completed")
            }
            .addDisposableTo(self.bag)
            
            sequenceOfInts.on(.Next(1))
            sequenceOfInts.onCompleted()
        }
        
        example("subscribeError") {
            let sequenceOfInts = PublishSubject<Int>()
            sequenceOfInts
                .subscribeError { error in
                    print(error)
            }
            .addDisposableTo(self.bag)
            
            sequenceOfInts.on(.Next(1))
            sequenceOfInts.on(.Error(NSError(domain: "Examples", code: -1, userInfo: nil)))
        }
        
        //doOn 可以监听事件，并且在事件发生之前调用
        example("doOn") {
            let sequenceOfInts = PublishSubject<Int>()
            sequenceOfInts
                .doOn({ (event) in
                    print("Intercepted event \(event)")
                })
                .subscribeNext({ (num) in
                    print(num)
                })
                .addDisposableTo(self.bag)
            
            sequenceOfInts.onNext(1)
            sequenceOfInts.on(.Completed)
        }

        //takeUntil 其实就是 take ，它会在终于等到那个事件之后触发 .Completed 事件。
        example("takeUntil") {
            let originalSequence = PublishSubject<Int>()
            let whenThisSendsNextWorldStops = PublishSubject<Int>()
            originalSequence
                .takeUntil(whenThisSendsNextWorldStops)
                .subscribe {
                    print($0)
            }
            .addDisposableTo(self.bag)
            originalSequence.on(.Next(1))
            originalSequence.on(.Next(2))
            whenThisSendsNextWorldStops.on(.Next(1))
            originalSequence.on(.Next(3))
        }
        
        //takeWhile 则是可以通过状态语句判断是否继续 take 。
        example("takeWhile") {
            let sequence = PublishSubject<Int>()
            sequence
                .takeWhile { int in
                    int < 2
                }
                .subscribe {
                    print($0)
            }
            sequence.on(.Next(1))
            sequence.on(.Next(2))
            sequence.on(.Next(3))
        }
        
        //concat 可以把多个事件序列合并起来。
        example("concat") {
            let var1 = BehaviorSubject(value: 0)
            let var2 = BehaviorSubject(value: 200)
            // var3 is like an Observable<Observable<Int>>
            let var3 = BehaviorSubject(value: var1)
            var3
            .concat().subscribe {
                print($0)
            }
            .addDisposableTo(self.bag)
            var1.on(.Next(1))
            var1.on(.Next(2))
            var3.on(.Next(var2))
            var2.on(.Next(201))
            var1.on(.Next(3))
            var1.on(.Completed)
            var2.on(.Next(202))
        }
        
        //
        example("reduce") {
            let seq = Observable<Int>.of(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
            seq.reduce(0, accumulator: { (result, ele) -> Int in
                result + ele
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

