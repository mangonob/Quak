//
//  DWMainCollectionController.swift
//  Quak
//
//  Created by 高炼 on 16/10/14.
//  Copyright © 2016年 mangonob. All rights reserved.
//

import UIKit
import AudioToolbox

private let suggestWidthOfCell: CGFloat = 120
let KeyNameUserDefaultArray = "e29530cc4ea437d1447f5559730e5e3b"

class DWMainCollectionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var widget = DWWidgetView.loadView()
    
    //MARK: - UICollectionViewDataSoruce
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DWItems.validItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! DWIconCell
        let dict = DWItems.validItems[indexPath.row]
        
        cell.textLabel.textColor = UIColor.whiteColor()
        cell.textLabel.adjustsFontSizeToFitWidth = true
        
        cell.bold = (dict[kDWACTIVE] as? Bool) ?? false
        cell.textLabel.text = (dict[kDWTITLE] as? String) ?? "UNTITLED"
        if dict[kDWCUSTOM] == nil {
            cell.thumbView.image = UIImage(named: dict[kDWTITLE] as! String)
        } else {
            cell.thumbView.image = UIImage(named: "custom")
        }
        
        // only custom scheme can edit!
        cell.custom = dict[kDWCUSTOM] != nil
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let w = floor(self.view.frame.width / round(self.view.frame.width / suggestWidthOfCell))
        return CGSize(width: w, height: w)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        queryTextField.delegate = self
        queryTextField.tintColor = UIColor.whiteColor().darken(10)
        
        queryTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: queryTextField, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 4)
            ])
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longpressAction(_:)))
        view.addGestureRecognizer(longPress)
    }
    
    private var once = dispatch_once_t()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dispatch_once(&once) {
            guard let flag = (UIApplication.sharedApplication().delegate as? AppDelegate)?.performCustomSchemeflag else {
                view.viewWithTag(kDW_RootViewTag)?.hidden = false
                view.viewWithTag(kDW_InputViewTag)?.hidden = true
                view.viewWithTag(kDW_CollViewTag)?.hidden = false
                view.viewWithTag(kDW_NavigationBarTag)?.hidden = false
                return
            }
            guard flag else {
                view.endEditing(true)
                view.viewWithTag(kDW_RootViewTag)?.hidden = true
                view.viewWithTag(kDW_InputViewTag)?.hidden = true
                view.viewWithTag(kDW_CollViewTag)?.hidden = true
                view.viewWithTag(kDW_NavigationBarTag)?.hidden = false
                return
            }
            
            view.viewWithTag(kDW_RootViewTag)?.hidden = false
            view.viewWithTag(kDW_InputViewTag)?.hidden = false
            view.viewWithTag(kDW_CollViewTag)?.hidden = true
            view.viewWithTag(kDW_NavigationBarTag)?.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print(traitCollection.forceTouchCapability == .Available)
        guard let hide = view.viewWithTag(kDW_InputViewTag)?.hidden else { return }
        if !hide {
            queryTextField.text = ""
            queryTextField.becomeFirstResponder()
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView.performBatchUpdates({
        }) { (_) in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard !(DWItems.validItems[indexPath.row][kDWTITLE] as? String ?? "").locked else {
            // Locked
            return
        }
        
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? DWIconCell else { return }
        guard DWItems.activiteItems.count < 4 || cell.bold else {
            if !widget.shown {
            widget.showIn(viewController: self, animated: true)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1)), dispatch_get_main_queue(), {
                self.widget.hide(true)
            })
            }
            
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            cell.shake()
            return
        }
        cell.userInteracted = true
        cell.bold = !cell.bold
        
        guard let title = DWItems.validItems[indexPath.row][kDWTITLE] as? String else { return }
        var i = 0
        repeat {
            if let t = DWItems.items[i][kDWTITLE] as? String {
                if t == title {
                    DWItems.items[i][kDWACTIVE] = cell.bold
                    DWItems.items[i][kDWTIMESTAMP] = NSDate().timeIntervalSinceReferenceDate
                    break
                }
            }
            i += 1
        } while (i < DWItems.items.count)
        
        DWItems.invalid()
    }
    
    //MARK: - Action
    @IBAction func addCustomCell(sender: AnyObject) {
        guard let vc = UIStoryboard(name: "AddCell", bundle: nil).instantiateInitialViewController() else { return }
        ((vc as? UINavigationController)?.topViewController as? AddCellViewController)?.host = self
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func longpressAction(sender: UILongPressGestureRecognizer) {
        guard sender.state == .Began else { return }
        let loc = sender.locationInView(view)
        guard let hit = view.hitTest(loc, withEvent: nil) as? DWIconCell where hit.custom else { return }
        guard let indexPath = collectionView.indexPathForCell(hit) else { return }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let delete =  UIAlertAction(title: "删除", style: .Destructive) { (_) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            guard let title = DWItems.validItems[indexPath.row][kDWTITLE] as? String else { return }
            
            DWItems.items = DWItems.items.filter({ (dict) -> Bool in
                guard let t = dict[kDWTITLE] as? String else { return false }
                return t != title
            })
            DWItems.invalid()
            
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItemsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)])
                }, completion: { (_) in
            })
        }
        let edit = UIAlertAction(title: "编辑", style: .Default) { (_) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            guard let vc = UIStoryboard(name: "AddCell", bundle: nil).instantiateInitialViewController() else { return }
            ((vc as? UINavigationController)?.topViewController as? AddCellViewController)?.host = self
            ((vc as? UINavigationController)?.topViewController as? AddCellViewController)?.indexPath = indexPath
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "取消", style: .Cancel) { (_) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alert.addAction(delete)
        alert.addAction(edit)
        alert.addAction(cancel)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            alert.popoverPresentationController?.sourceRect = hit.frame
            alert.popoverPresentationController?.sourceView = view
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func clearHistory(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KeyNameUserDefaultArray)
        tableView.beginUpdates()
        tableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: .Left)
        tableView.endUpdates()
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let custom = queryTextField.text else { return false }
        
        if openCustomUrl(custom) {
                var histories = NSUserDefaults.standardUserDefaults().valueForKey(KeyNameUserDefaultArray) as? [String] ?? [String]()
                histories.insert(custom, atIndex: 0)
                NSUserDefaults.standardUserDefaults().setValue(histories, forKey: KeyNameUserDefaultArray)
        }
        
        return true
    }
    
    private func openCustomUrl(custom: String) -> Bool {
        guard let dict = (UIApplication.sharedApplication().delegate as? AppDelegate)?.tempDict else { return false }
        
        guard let scheme = dict[kDWSCHEME] as? String else { return false }
        guard let url = scheme.validURL(custom) else { return false }
        
        if UIApplication.sharedApplication().canOpenURL(url) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                UIApplication.sharedApplication().openURL(url)
            })
        }
        
        return true
    }
    
    //MARK: - UITableDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let histories = NSUserDefaults.standardUserDefaults().valueForKey(KeyNameUserDefaultArray) as? [String] ?? [String]()
        return  histories.count == 0 ? 0 : 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let histories = NSUserDefaults.standardUserDefaults().valueForKey(KeyNameUserDefaultArray) as? [String] ?? [String]()
        let cnt = histories.count
        return cnt == 0 ? 0 : cnt + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cnt = tableView.numberOfRowsInSection(0)
        let identifier = indexPath.row == cnt - 1 ? "ClearCell" : "TableCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        if identifier == "TableCell" {
            let histories = NSUserDefaults.standardUserDefaults().valueForKey(KeyNameUserDefaultArray) as? [String] ?? [String]()
            cell.textLabel?.text = histories[indexPath.row]
        }
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let histories = NSUserDefaults.standardUserDefaults().valueForKey(KeyNameUserDefaultArray) as? [String] ?? [String]()
        guard indexPath.row < histories.count else { return }
        openCustomUrl(histories[indexPath.row])
    }
}



























