//
//  CellSubgridCollectionViewCell.swift
//  Sudoku4x4-SATSolver
//
//  Created by Diego Brito, Diêgo Farias and Nykolas Mayko on 29/05/16.
//  Copyright © 2016 Diego Brito. All rights reserved.
//

import UIKit

class CellSubgridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Toolbar of Keyboard
        
        let numberToolbar = UIToolbar.init(frame: CGRectMake(0, 0, ScreenSize.SCREEN_WIDTH, 50))
        numberToolbar.barStyle = .Default
        numberToolbar.items = [UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem.init(title: "Ok   ", style: .Done, target: self, action: #selector(CellSubgridCollectionViewCell.toolbarButtonOk))]
        numberToolbar.sizeToFit()
            textField.inputAccessoryView = numberToolbar
    }
    
    func toolbarButtonOk() {
        textField.resignFirstResponder()
    }
    
    

    
    
}
