//
//  UiViewController+Prompt.swift
//  SparkPerso
//
//  Created by  on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func promptForAnswer(callBack:@escaping(Double, Float) -> ()) {
        let ac = UIAlertController(title: "Valeurs", message: nil, preferredStyle: .alert)
        ac.addTextField { (text) in
            text.placeholder = "Speed"
        }
        ac.addTextField { (text) in
            text.placeholder = "Duration"
        }

        let submitAction = UIAlertAction(title: "Envoyer", style: .default) { [unowned ac] _ in
            if let speedText = ac.textFields![0].text,
                let durationText = ac.textFields![1].text,
                let speed = Float(speedText),
                let duration = Double(durationText) {
                callBack(duration, speed)
            }
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    func promptForAnswerWithHeading(callBack:@escaping(Double, Float, Float) -> ()) {
        let ac = UIAlertController(title: "Valeurs", message: nil, preferredStyle: .alert)
        ac.addTextField { (text) in
            text.placeholder = "Speed"
        }
        ac.addTextField { (text) in
            text.placeholder = "Duration"
        }
        ac.addTextField { (text) in
            text.placeholder = "Heading"
        }

        let submitAction = UIAlertAction(title: "Envoyer", style: .default) { [unowned ac] _ in
            if let speedText = ac.textFields![0].text,
            let durationText = ac.textFields![1].text,
            let headingText = ac.textFields![2].text,
                let speed = Float(speedText),
                let duration = Double(durationText),
                let heading = Float(headingText) {
                callBack(duration, speed, heading)
            }
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
}
