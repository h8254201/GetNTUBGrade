//
//  ViewController.swift
//  getntubgrade
//
//  Created by tony on 2017/6/29.
//  Copyright © 2017年 tony. All rights reserved.
//

import UIKit
import Kanna

class GetGradeController: UIViewController,ViewControllerBaseDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate{
    @IBOutlet weak var gradetable: UITableView!
    @IBOutlet weak var termpick: UIPickerView!
    @IBOutlet weak var yearpick: UIPickerView!
    @IBOutlet weak var numtxt: UITextField!
    private var isKeyboardShown = false //驗盤有無出現
    var selectyear : Int?
    var selectterm : Int?
    var terms = [1,2]
    var years = [Int]()
    var grades = [Grade]()
    var getgradepresenter : GetGradePresenter?
    @IBAction func searchbt(_ sender: Any) {
        grades.removeAll()
        getgradepresenter = GetGradePresenter(getgradeVC: self)
        getgradepresenter?.postsearchdata(StdNo: numtxt.text!, strYears: (selectyear?.description)!, strTerm: (selectterm?.description)!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        TextView監聽show/hide
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GetGradeController.keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GetGradeController.keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self ,action: #selector(GetGradeController.txtdismiss)))
        //TextView監聽show/hide
        
        termpick.dataSource = self
        termpick.delegate = self
        yearpick.dataSource = self
        yearpick.delegate = self
        gradetable.rowHeight = 100.0
        gradetable.delegate = self
        gradetable.dataSource = self
        
        //設定可查10年間的成績
        let date = Date()
        let calendar = Calendar.current
        
        var year = calendar.component(.year, from: date)
        year = year - 1911 - 1
        for i in year - 10 ... year{
            years.append(i)
        }
        yearpick.selectRow(years.count - 1, inComponent: 0, animated: true)
        selectyear = years.last
        selectterm = terms.first
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        numtxt = textField
    }
    func keyboardWillShow(note: NSNotification) {
        if isKeyboardShown {
            return
        }
        //        if (currentTextField != textBottom) {
        //            return
        //        }
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        //        let duration = NSTimeInterval(keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber)
        let keyboardFrameValue = keyboardAnimationDetail[UIKeyboardFrameBeginUserInfoKey]! as! NSValue
        //        let keyboardFrame = keyboardFrameValue.CGRectValue()
        
        //        UIView.animateWithDuration(duration, animations: { () -> Void in
        //            self.view.frame = CGRectOffset(self.view.frame, 0, -keyboardFrame.size.height)
        //        })
        isKeyboardShown = true
    }
    
    func keyboardWillHide(note: NSNotification) {
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber)
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
        })
        isKeyboardShown = false    }
    func txtdismiss(){
        numtxt.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        numtxt.resignFirstResponder()
        return true
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case yearpick:
            return years.count
        case termpick:
            return terms.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case yearpick:
            return years[row].description
        case termpick:
            return terms[row].description
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case yearpick:
            self.selectyear = years[row]
        case termpick:
            self.selectterm = terms[row]
        default:
            print("error")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grades.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GradeSamepleCell", for: indexPath) as! GradeSamepleCell
        let row = indexPath.row
        let grade = grades[row]
        cell.yearlbl.text = grade.getYear()
        cell.classnamelbl.text = grade.getClassName()
        cell.scorelbl.text = grade.getScore()
        return cell
    }
    func PresenterCallBack(data: NSData, success: Bool, type: String) {
        let responseString = String(data: data as Data, encoding: .utf8)
        print("responseString = \(String(describing: responseString))")
        DispatchQueue.main.async(execute: { () -> Void in
            if let doc = HTML(html: responseString!, encoding: .utf8) {
                for div in doc.css("li"){
                    let grade = Grade()
                    let classobject = div.css("p")
                    let year = classobject[0].content
                    let classname = classobject[1].content
                    let score = classobject[2].content
                    grade.setYear(year: year!)
                    grade.setClassName(classname: classname!)
                    grade.setScore(score: score!)
                    //                let titlenews = div.at_css("a[class^='news']")
                    //                let description = div.at_css("div[class^='topic-article-description']")
                    //
                    //                let spanremove = div.css("span")
                    //                if spanremove.count != 0{
                    //                    description?.removeChild(spanremove.first!)
                    //                }
                    //                let titlestr = titlenews?.content?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    //                let hrefstr = titlenews?["href"]?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    //                let descriptionstr = description?.content?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    self.grades.append(grade)
                    
                }
            }
            self.gradetable.reloadData()
        })
    }
    func PresenterCallBackError(error: NSError, type: String) {
        
    }
}

class GradeSamepleCell:UITableViewCell{
    @IBOutlet weak var yearlbl: UILabel!
    @IBOutlet weak var classnamelbl: UILabel!
    @IBOutlet weak var scorelbl: UILabel!
}
