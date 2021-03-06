//
//  ViewModel.swift
//  RxAlertViewable
//
//  Created by Meng Li on 2018/12/11.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa

class ViewModel {
    
    let globalTip = PublishSubject<RxAlert>()
    let clickTimes = BehaviorRelay<Int>(value: 0)
    
    var tip: Observable<RxAlert> {
        return clickTimes.map { times -> RxAlert in
            let message = "Clicked \(times) time\(times > 1 ? "s" : "")."
            switch times % 5 {
            case 1:
                return .tip(message)
            case 2:
                return .customTip(title: "Custom Tip", message: message)
            case 3:
                return .warning(message)
            case 4:
                return .error(message)
            case 0:
                return .confirm(message, onConfirm: {
                    self.alert()
                })
            default:
                return .tip("???")
            }
        }
    }
    
    func alert() {
        clickTimes.accept(clickTimes.value + 1)
    }
    
    func globalAlert() {
        globalTip.onNext(.confirm("Confirm message.", onConfirm: {
            print("comfirm")
        }, onDeny: {
            print("deny")
        }))
    }
    
}
