//
//  TSItemBar.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

protocol TSItemBarDelegate {
    
}

/** SandBoxシーンでのアイテムバーを提供します。
 -- Usage --
 
 */
class TSItemBar: UIImageView {
    // ======================================================================== //
    // MARK: - TSItemBar Properties -
    
    // ======================================================================== //
    // MARK: - Private Properties -
    private var _registeredInventory:TSInventry?
    private var _selectedItemIndex = 0
    
    // ================================== //
    // MARK: - UI Compornents -
    /// アイテム保持用ボタン
    private let itemImageButton1 = UIButton()
    private let itemImageButton2 = UIButton()
    private let itemImageButton3 = UIButton()
    private let itemImageButton4 = UIButton()
    
    /// インベントリを開くようボタン
    private let moreitemImageButton = UIButton()
    
    /// 選択中のアイテムを表すボタン
    private var itemSelectionFrame = UIImageView(image: #imageLiteral(resourceName: "TP_itembar_selected_frame"))
    
    /// 簡易使用用配列
    private var itemImageButtons:[UIButton] {
        return [itemImageButton1, itemImageButton2, itemImageButton3, itemImageButton4, moreitemImageButton]
    }
    
    // ======================================================================== //
    // MARK: - Public Methods -
    
    func registerInventry(_ inventory:TSInventry) {
        self._registeredInventory = inventory
        
        self.inventoryDidRegistered()
    }
    
    // ======================================================================== //
    // MARK: - Private Methods -
    
    func inventoryDidRegistered() {
        guard let inventory = _registeredInventory else {return}
        for i in 0...4 {
            if let stack = inventory.itemStacks.at(i) {
                self.setItemImage(toButtonIndexed: i, image: stack.item.itemImage)
            }
        }
    }
    
    func setItemImage(toButtonIndexed index:Int, image:UIImage) {
        self.itemImageButtons[index].setImage(image, for: .normal)
    }
    

    
    override func setNeedsDisplay() {
        isUserInteractionEnabled = true
        self.clipsToBounds = false
        // サイズ決定
        self.frame.size = [304, 61]
        self.image = #imageLiteral(resourceName: "TS_itembar_background")
        
        self.itemSelectionFrame.frame.size = [70, 67]
        self.moveSelectedFrame(to: 0)
        // ボタン初期化
        itemImageButtons.enumerated().forEach(setupItemButton(t:))
        
        self.addSubview(itemSelectionFrame)
        
        
        itemImageButton1.setImage(#imageLiteral(resourceName: "TP_item_thumb_japanese_house_1"), for: .normal)
        itemImageButton2.setImage(#imageLiteral(resourceName: "TP_item_thumb_japanese_house_2"), for: .normal)
    }
    
    // ボタンのハンドラ
    @objc func itemButtonDidPushed(_ sender:UIButton) {
        guard let index = itemImageButtons.enumerated().first(where: {$0.element == sender})?.offset else {return}
        moveSelectedFrame(to: index)
    }
    
    private func moveSelectedFrame(to index:Int) {
        itemSelectionFrame.frame.origin = [-2 + CGFloat(index) * 60, -2]
    }
    private func setupItemButton(t: ( offset:Int, element:UIButton)) {
        let button = t.element
        let index = t.offset
        
        button.frame.size = [55, 53]
        button.addTarget(self, action: #selector(itemButtonDidPushed), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.frame.origin = [4 + CGFloat(index) * 60, 4]
        
        
        self.addSubview(button)
    }
}
