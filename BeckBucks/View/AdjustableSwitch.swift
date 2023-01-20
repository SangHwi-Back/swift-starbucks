//
//  AdjustableSwitch.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/19.
//

import UIKit
import RxCocoa
import RxSwift

class AdjustableSwitch: UIButton {
    
    enum SwitchState {
        case on
        case off
    }
    
    @IBOutlet private weak var switchMarker: UIView!
    @IBOutlet private weak var clickableBackgroundButton: UIButton!
    
    private var switchState: SwitchState = .on {
        didSet {
            self.switchStateRelay.accept(switchState)
        }
    }
    private var switchStateRelay = BehaviorRelay<SwitchState>(value: SwitchState.on)
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeRound()
        setMarkerShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        makeRound()
//        setMarkerShadow()
    }
    
    @IBAction func clickableBackgroundButtonTouchUpInside(_ sender: UIButton) {
        self.mutateState()
    }
    
    private func makeRound() {
        self.setCornerRadius(self.frame.height / 2)
        self.switchMarker.setCornerRadius()
        self.setNeedsLayout()
    }
    
    private func setMarkerShadow() {
        self.switchMarker.putShadows(dx: 1, dy: 1)
    }
    
    private func mutateState(_ state: SwitchState? = nil) {
        let mutatingState: SwitchState = (self.switchState == .on) ? .off : .on
        self.switchState = mutatingState
    }
    
    func setState(_ state: SwitchState) {
        self.switchState = state
    }
    
    private func setBinding() {
        clickableBackgroundButton.rx
            .tap
            .bind(onNext: { self.mutateState() } )
            .disposed(by: disposeBag)
        
        switchStateRelay
            .bind(onNext: { state in
                var originX: CGFloat = 0
                switch self.switchState {
                case .on:
                    originX = 4
                case .off:
                    originX = self.clickableBackgroundButton.frame.width / 2 + 4
                }
                
                UIView.animate(withDuration: 0.2) {
                    self.switchMarker.frame.origin.x = originX
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setBackgroundColor(_ color: UIColor) {
        self.clickableBackgroundButton.backgroundColor = color
    }
    
    func setMarkerColor(_ color: UIColor) {
        self.switchMarker.backgroundColor = color
    }
}
