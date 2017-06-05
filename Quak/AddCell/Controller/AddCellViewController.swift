//
//  AddCellViewController.swift
//  Quak
//
//  Created by 高炼 on 16/10/18.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import UIKit

class AddCellViewController: UIViewController, UITextFieldDelegate {
    weak var host: DWMainCollectionController?
    
    @IBOutlet weak var placeholderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleField: DWTextField!
    @IBOutlet weak var urlField: DWTextField!
    
    @IBOutlet weak var urlValidImage: UIImageView!
    @IBOutlet weak var doneItem: UIBarButtonItem!
    @IBOutlet weak var testIconContainer: UIView!
    
    var indexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        
        titleField.delegate = self
        urlField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyBoardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyBoardWillHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.textChanged(_:)), name: UITextFieldTextDidChangeNotification, object: nil)
        
        doneItem.enabled = valid
        
        urlValidImage.image = nil
        
        if let indexPath = indexPath {
            let dict = DWItems.validItems[indexPath.row]
            titleField.text = dict[kDWTITLE] as? String
            urlField.text = dict[kDWSCHEME] as? String
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var titleValid: Bool {
        guard let title = titleField.text else { return false }
        
        guard let white = try? NSRegularExpression(pattern: "\\w+", options: []) else { return false }
        
        let matches = white.matchesInString(title, options: [], range: NSMakeRange(0, NSString(string: title).length))
        
        
        var whiteTitle = [String]()
        if let indexPath = indexPath {
            let dict = DWItems.validItems[indexPath.row]
            if let selfTitle = dict[kDWTITLE] as? String {
                whiteTitle.append(selfTitle)
            }
        }
        
        return matches.count != 0 && !DWItems.containsTitle(title, whitePaper: whiteTitle)
    }
    
    var urlValid: Bool {
        guard let scheme = urlField.text else { return false }
        return scheme.validAsURL
    }
    
    var valid: Bool {
        return titleValid && urlValid
    }
    
    // MARK: - Action
    @IBAction func doneAction(sender: AnyObject?) {
        view.endEditing(true)
        dismissViewControllerAnimated(true) {
            guard self.valid else { return }
            if self.indexPath == nil {
                self.saveScheme()
            } else {
                self.updateScheme()
            }
        }
    }
    
    @IBAction func cencelAction(sender: AnyObject) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyBoardShown(notif: NSNotification) {
        guard let f = notif.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() else { return }
        placeholderHeightConstraint.constant = f.height
    }
    
    func keyBoardWillHidden(notif: NSNotification) {
        placeholderHeightConstraint.constant = 0
    }
    
    func textChanged(notif: NSNotification) {
        guard let textField = notif.object as? UITextField else { return }
        
        var v = false
        switch textField {
        case titleField:
            v = titleValid
        case urlField:
            v = urlValid
            urlValidImage.image = UIImage(named: v ? "correct": "error")
        default:
            break
        }
        
        textField.layer.borderColor = v ? UIColor.dwWarmGreyColor().CGColor: UIColor.dwPinkishRedColor().CGColor
        textField.textColor = v ? UIColor.darkGrayColor(): UIColor.dwPinkishRedColor().darken(10)
        
        updateDoneEnable()
    }
    
    private func updateDoneEnable() {
        doneItem.enabled = valid
    }
    
    @IBAction func test(sender: AnyObject) {
        guard urlValid else {
            testIconContainer.shake()
            return
        }
        
        guard let url = urlField.text?.validURL("42") else { return }
        guard UIApplication.sharedApplication().canOpenURL(url) else { return }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            UIApplication.sharedApplication().openURL(url)
        })
    }
    
    //MARK: - UITextFieldDelegate
    func updateScheme() {
        guard let indexPath = indexPath else { return }
        guard let title = DWItems.validItems[indexPath.row][kDWTITLE] as? String else { return }
        
        var dict = DWItems.validItems[indexPath.row]
        dict[kDWTITLE] = self.titleField.text ?? ""
        dict[kDWSCHEME] = self.urlField.text ?? "127.0.0.1"
        
        guard !(DWItems.validItems[indexPath.row][kDWLOCKED] as? Bool ?? true) else {
            // Locked
            return
        }
        
        var i = 0
        repeat {
            if let t = DWItems.items[i][kDWTITLE] as? String {
                if t == title {
                    DWItems.items[i] = dict
                    break
                }
            }
            i += 1
        } while (i < DWItems.items.count)
        
        DWItems.invalid()
        if let host = host {
            host.collectionView.performBatchUpdates({
                host.collectionView.reloadItemsAtIndexPaths([indexPath])
                }, completion: { (_) in
            })
        }
    }
    
    func saveScheme() {
        guard valid else { return }
        
        let dict:[String: AnyObject] = [
            kDWCUSTOM: "",
            kDWTIMESTAMP: 0,
            kDWLOCKED: false,
            kDWTITLE: self.titleField.text ?? "",
            kDWACTIVE: false,
            kDWSCHEME: self.urlField.text ?? "127.0.0.1",
            ]
        
        DWItems.items.append(dict)
        DWItems.invalid()
        
        if let host = host {
            let indexPath = NSIndexPath(forRow: DWItems.validItems.count - 1, inSection: 0)
            host.collectionView.performBatchUpdates({
                host.collectionView.insertItemsAtIndexPaths([indexPath])
                }, completion: { (_) in
            })
            host.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !titleValid {
            titleField.swing()
        }
        if !urlValid {
            urlField.swing()
        }
        
        switch textField {
        case titleField:
            urlField.becomeFirstResponder()
        case urlField:
            if doneItem.enabled {
                doneAction(nil)
            } else {
            }
        default:
            break
        }
        
        return true
    }
}























