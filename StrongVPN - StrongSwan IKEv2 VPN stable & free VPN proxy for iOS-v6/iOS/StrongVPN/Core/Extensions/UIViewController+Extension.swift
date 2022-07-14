//
//  UIViewController+Extension.swift
//  StrongVPN
//
//  Created by witworkapp on 12/23/20.
//

import Foundation
import UIKit
extension UIViewController {
    
    // Save object in document directory
    @discardableResult
    func saveObject(fileName: String, object: Any) -> Bool {
        
        let filePath = self.getDirectoryPath().appendingPathComponent(fileName)//1
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)//2
            try data.write(to: filePath)//3
            return true
        } catch {
            print("error is: \(error.localizedDescription)")//4
        }
        return false
    }
    
    @discardableResult
    // Get object from document directory
    func getObject(fileName: String) -> Any? {
        
        let filePath = self.getDirectoryPath().appendingPathComponent(fileName)//5
        do {
            let data = try Data(contentsOf: filePath)//6
            let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)//7
            return object//8
        } catch {
            print("error is: \(error.localizedDescription)")//9
        }
        return nil
    }
    
    //Get the document directory path
    //10
    func getDirectoryPath() -> URL {
        let arrayPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return arrayPaths[0]
    }
}
