//
//  AppDelegate.swift
//  SandboxSample
//
//  Created by yuki on 2019/05/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        TSSandboxBlockSystem.default.applicationDidLuanched()
        
        // TEST
        let alice = TSPlayer(named: "Alice")
        let itemStack1 = TSItemStack(item: .japaneseHouse1, count: 1)
        let itemStack2 = TSItemStack(item: .japaneseHouse2, count: 10)
        
        alice.itemBarInventory.placeItemStack(itemStack1, at: 0)
        alice.itemBarInventory.placeItemStack(itemStack2, at: 2)
        
        let itemStack3 = TSItemStack(item: .japaneseHouse1, count: 10)
        let itemStack4 = TSItemStack(item: .japaneseHouse1, count: 10)
        let itemStack5 = TSItemStack(item: .japaneseHouse2, count: 10)
        let itemStack6 = TSItemStack(item: .normailBuilding, count: 10)
        
        alice.inventory.addItemStack(itemStack3)
        alice.inventory.addItemStack(itemStack4)
        alice.inventory.addItemStack(itemStack5)
        alice.inventory.addItemStack(itemStack6)
        
        TSSandboxPlayerSystem.default.setPlayer(alice)
        
        // End TEST
        
        return true
    }
}
