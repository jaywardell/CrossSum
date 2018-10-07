//
//  TableDataSource.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/7/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

final class TableDataSource<Object> : NSObject, UITableViewDataSource {
    
    let title : String?
    var objects : [Object]
    let cellStyle : UITableViewCell.CellStyle
    var configure : (UITableViewCell, Object) -> () = { _, _ in }
    var style : (UITableViewCell) -> () = { _ in }

    init(_ objects:[Object], title:String? = nil, style:UITableViewCell.CellStyle = .default) {
        self.objects = objects
        self.cellStyle = style
        self.title = title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: cellStyle, reuseIdentifier: "cell")
        configure(cell, objects[indexPath.row])
        style(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objects.count != 0 ? title : nil
    }
}
