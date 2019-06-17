//
//  TPSandboxViewController.swift
//  SandboxSample
//
//  Created by yuki on 2019/05/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxSwift
import RxCocoa

class TPSandboxViewController: ESViewController {
    // =================================================================
    // MARK: - Public Properties -
    
    // ==============================
    // MARK: - UI Components -
    @IBOutlet weak var itemBar: TSItemBarView!
    @IBOutlet weak var overLayView: UIView!
    
    @IBOutlet weak var constCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constCollectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var itemCollectionView: UIView!
    
    // ==============================
    // MARK: - ViewModel -
    public lazy var viewModel = TPSandboxViewModel(sceneModel: mainSceneController.sceneModel)
    
    // =================================================================
    // MARK: - Private Properties -
    
    private lazy var mainSceneController = TPSandboxSceneController(self)
    private let bag = DisposeBag()
    
    // =================================================================
    // MARK: - Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scnView.showsStatistics = true
        
        // ========= 初期化 =========
        // アイテムバー初期化
        self.itemBar.registerInventory(TSSandboxPlayerSystem.default.getPlayer().itemBarInventory)
        
        // ========= Rx登録 =========
        // MoreButton登録
        self.itemBar.moreitemImageButton.rx.tap.subscribe { [unowned self] _ in
            self.viewModel.isItemCollectionHidden.accept(!self.viewModel.isItemCollectionHidden.value)
            
        }.disposed(by: bag)
        
        // gestureRecognizers登録
        self.viewModel.isItemCollectionHidden.subscribe{ [unowned self] in
            $0.element.map{flag in self.gestureRecognizers.forEach{$0.isEnabled = flag}}
            
        }.disposed(by: bag)
        
        // ItemCollection登録
        self.viewModel.isItemCollectionHidden.bind(to: overLayView.rx.isHidden).disposed(by: bag)
        self.viewModel.isItemCollectionHidden.bind(to: itemCollectionView.rx.isHidden).disposed(by: bag)
        
        // View 設定
        self.constCollectionViewWidth.constant = TSItemCollectionViewController.viewSize.width
        self.constCollectionViewHeight.constant = TSItemCollectionViewController.viewSize.height
    }
    
    override func getSceneController() -> ESSceneController {
        return mainSceneController
    }
}
