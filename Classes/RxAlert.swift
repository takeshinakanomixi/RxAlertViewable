//
//  RxAlert.swift
//  RxAlertViewable
//
//  Created by Meng Li on 2018/12/09.
//  Copyright © 2018 MuShare. All rights reserved.
//

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public struct RxAlertConfig {
    
    var tip: String
    var confirm: String
    var warning: String
    var error: String
    var yes: String
    var no: String
    var ok: String
    var tintColor: UIColor?
    
    public init(tip: String? = nil, confirm: String? = nil, warning: String? = nil, error: String? = nil,
        yes: String? = nil, no: String? = nil, ok: String? = nil, tintColor: UIColor? = nil) {
        self.tip = tip ?? "Tip"
        self.confirm = confirm ?? "Confirm"
        self.warning = warning ?? "Warning"
        self.error = error ?? "Error"
        self.yes = yes ?? "Yes"
        self.no = no ?? "No"
        self.ok = ok ?? "OK"
        self.tintColor = tintColor
    }
}

public typealias RxAlertCompletion = (() -> ())?

public enum RxAlertCategory {
    case single(RxAlertCompletion)
    case double(confirmTitle: String,
                denyTitle: String,
                onConfirm: RxAlertCompletion,
                onDeny: RxAlertCompletion)
}

public struct RxAlert {
    
    public static var config = RxAlertConfig()
    
    private var title: String
    private var message: String
    private var category: RxAlertCategory
    
    public static func tip(_ message: String, onConfirm: RxAlertCompletion = nil) -> RxAlert {
        return self.init(title: config.tip, message: message, category: .single(onConfirm))
    }
    
    public static func customTip(title: String, message: String, onConfirm: RxAlertCompletion = nil) -> RxAlert {
        return self.init(title: title, message: message, category: .single(onConfirm))
    }
    
    public static func warning(_ message: String, onConfirm: RxAlertCompletion = nil) -> RxAlert {
        return self.init(title: config.warning, message: message, category: .single(onConfirm))
    }
    
    public static func error(_ message: String, onConfirm: RxAlertCompletion = nil) -> RxAlert {
        return self.init(title: config.error, message: message, category: .single(onConfirm))
    }
    
    public static func confirm(_ message: String, onConfirm: RxAlertCompletion = nil, onDeny: RxAlertCompletion = nil) -> RxAlert {
        return self.init(title: config.confirm, message: message, category: .double(confirmTitle: RxAlert.config.yes, denyTitle: RxAlert.config.no, onConfirm: onConfirm, onDeny: onDeny))
    }
    
    public static func customConfirm(title: String, message: String, confirmTitle: String? = nil, denyTitle: String? = nil, onConfirm: RxAlertCompletion = nil, onDeny: RxAlertCompletion = nil) -> RxAlert {
        let confirmTitle = confirmTitle ?? RxAlert.config.yes
        let denyTitle = denyTitle ?? RxAlert.config.no
        return self.init(title: title, message: message, category: .double(confirmTitle: confirmTitle, denyTitle: denyTitle, onConfirm: onConfirm, onDeny: onDeny))
    }
    
    public var alertController: UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        switch category {
        case .single(let onConfirm):
            alertController.addAction(UIAlertAction(title: RxAlert.config.ok, style: .cancel) { _ in
                onConfirm?()
            })
        case .double(let comfirmMessage, let denyMessage, let onConfirm, let onDeny):
            alertController.addAction(UIAlertAction(title: comfirmMessage, style: .destructive) { _ in
                onConfirm?()
            })
            alertController.addAction(UIAlertAction(title: denyMessage, style: .cancel) { _ in
                onDeny?()
            })
        }
        if let tintColor = RxAlert.config.tintColor {
            alertController.view.tintColor = tintColor
        }
        return alertController
    }
    
}
