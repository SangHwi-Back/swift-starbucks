//
//  AdjustableSwitch.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/19.
//

import UIKit
import RxCocoa
import RxSwift

class AdjustableSwitch: UIView {
    
    enum SwitchState {
        case on
        case off
        
        func getColor() -> UIColor {
            switch self {
            case .on: return .green
            case .off: return .systemGray4
            }
        }
        
        func getPosition(from superView: UIView) -> CGPoint {
            switch self {
            case .on: return CGPoint(x: superView.frame.width / 2 - 2, y: 2)
            case .off: return CGPoint(x: 2, y: 2)
            }
        }
    }
    
    @IBOutlet private weak var switchMarker: UIView!
    @IBOutlet private weak var clickableBackgroundButton: UIButton!
    
    let switchStateRelay = BehaviorRelay<SwitchState>(value: SwitchState.off)
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        setMarkerShadow()
        makeRound()
        setBinding()
    }
    
    private func makeRound() {
        self.setCornerRadius(self.frame.height / 2)
        self.switchMarker.setCornerRadius(self.switchMarker.frame.height / 2)
    }
    
    private func setMarkerShadow() {
        self.switchMarker.putShadows(dx:2, dy:2, offset: CGSize(width: 2, height: 2))
    }
    
    private func mutateState(_ state: SwitchState? = nil) {
        let mutatingState: SwitchState = (switchStateRelay.value == .on) ? .off : .on
        switchStateRelay.accept(mutatingState)
    }
    
    private func setBinding() {
        clickableBackgroundButton.rx
            .tap
            .bind(onNext: { self.mutateState() } )
            .disposed(by: disposeBag)
        
        switchStateRelay
            .bind(onNext: { state in
                UIView.animate(withDuration: 0.2) {
                    self.switchMarker.backgroundColor = .white
                    self.setBackgroundColor(state.getColor())
                    self.switchMarker.frame.origin.x = state.getPosition(from: self).x
                }
            })
            .disposed(by: disposeBag)
        
        switchStateRelay.accept(.off)
    }
    
    func setBackgroundColor(_ color: UIColor) {
        self.clickableBackgroundButton.backgroundColor = color
    }
    
    func setMarkerColor(_ color: UIColor) {
        self.switchMarker.backgroundColor = color
    }
  
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: Self.self),
                        bundle: Bundle.main)
        let instantiatedNib = nib.instantiate(withOwner: self,
                                              options: nil)
        return instantiatedNib.first as? UIView
    }
}
