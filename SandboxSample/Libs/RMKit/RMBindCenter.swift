//
//  RMBindCenter.swift
//  EXKit
//
//  Created by yuki on 2019/05/14.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/**
 型安全な`NotificationCenter`です。
 純正の`NotificationCenter`と異なり、`Notification.object`の型を確定できるので安全に使用できます。
 
 ```
 // 通知のために拡張する。
 // 型は `where Object == [型]` で登録する。
 extension RMBinder.Name where Object == String { //String型を送る通知
    static let sampleNotification = RMBinder.Name("__sampleNotification")
 
 }
 
 ----
 // 通知センターに登録する。
 // この時点で既に`notice.object`は`String`型である。
 RMBindCenter.default.addObserver(for .sampleNotification){ notice in
    print(notice.object)
 }
 
 ----
 // 通知を発行する。
 // 引数`object`には拡張時に定義した型のみ、渡すことができる。
 
 RMBindCenter.default(.sampleNotification, object: "Hello World")
 
 ----
 // 通知登録元で`"Hello World"`が出力される。
 
 ```
 */

public final class RMBindCenter {
    
    // MARK: - Singleton
    
    /// アプリのデフォルトの`RMBindCenter`
    public static let `default` = RMBindCenter()
    
    // MARK: - Private Properties
    private var handlers = [String: [() -> Void]]()
    private var objects = [String: Any]()
    
    // MARK: - APIs
    /**
     引数`name`に対して`handler`を登録します。
     `handler`は自動で解放されません。
     `[weak self]` などを用いて呼び出し側で対策してください。
     */
    public func addObserver<T>(forName name:RMBinder<T>.Name, queue:DispatchQueue? = .main, using handler:((RMBinder<T>) -> Void)?) {
        let rawName = name.rawValue
        
        let block = {[weak self] in
            guard let self = self else {fatalError()}
            guard let handler = handler else {fatalError()}
            
            let _object = self.objects[rawName] as! T
            let _notification = RMBinder(name:name, object: _object)
            
            if let queue = queue {
                queue.async { handler(_notification) }
            }else{
                handler(_notification)
            }
            
        }
        if handlers[rawName] == nil { handlers[rawName] = [] }
        
        self.handlers[rawName]!.append(block)
    }
    /**
     引数`name`で登録された`Observer`に対して、`Notification`を送ります。
     */
    public func post<T>(name:RMBinder<T>.Name, object:T) {
        let rawName = name.rawValue
        self.objects[rawName] = object
        
        handlers[rawName]?.forEach{$0()}
        
        self.objects.removeValue(forKey: rawName)
        
    }
}

// MARK: - RMBinder

/**
 通知に送られる`Notification`です。
 型情報を持っています。
 */
public final class RMBinder<Object> {
    public let object:Object
    public let name:Name
    
    fileprivate init(name:Name,object:Object) {
        self.name = name
        self.object = object
    }
    /// 通知の識別子です。
    public struct Name {
        let rawValue:String
        
        public init(rawValue:String) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - RMBinder.Name Extension.

extension RMBinder.Name: Equatable, Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    public static func == (left:RMBinder.Name, right:RMBinder.Name) -> Bool {
        return left.rawValue == right.rawValue
    }
}
