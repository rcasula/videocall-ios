//
//  File.swift
//
//
//  Created by Roberto Casula on 25/06/22.
//

import Foundation
import UIKit

class StreamCell: UICollectionViewCell {

    func configure(with stream: Stream) {
        contentView.backgroundColor = .red
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
}
