//
//  Grade.swift
//  getntubgrade
//
//  Created by tony on 2017/6/29.
//  Copyright © 2017年 tony. All rights reserved.
//

import Foundation
class Grade{
    var year : String?
    var classname : String?
    var score : String?
    init(){
        self.year = ""
        self.classname = ""
        self.score = ""
    }
    func setYear(year:String){
        self.year = year
    }
    func getYear() -> String{
        return year!
    }
    func setClassName(classname:String){
        self.classname = classname
    }
    func getClassName() -> String{
        return classname!
    }
    func setScore(score:String){
        self.score = score
    }
    func getScore() -> String{
        return score!
    }
}
