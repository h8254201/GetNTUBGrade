//
//  GetGradePresenter.swift
//  getntubgrade
//
//  Created by tony on 2017/6/29.
//  Copyright © 2017年 tony. All rights reserved.
//

import Foundation
class GetGradePresenter:BasePresenter{
    var getgradeVC : ViewControllerBaseDelegate?
    init(getgradeVC:ViewControllerBaseDelegate){
        self.getgradeVC = getgradeVC
    }

    func postsearchdata(StdNo:String,strYears:String,strTerm:String){
        let urlsession = UrlSession(url: "http://140.131.110.76/JMobile_STD/AjaxPage/SRHGRD_Years_ajax.aspx", delegate: self)
        urlsession.postsearchdata(StdNo: StdNo, strYears: strYears, strTerm: strTerm)
        urlsession.postData()
    }
    override func SessionFinish(data: NSData) {
        self.getgradeVC?.PresenterCallBack(data: data, success: true, type: "")
        

    }
    override func SessionFinishError(error: NSError) {
        getgradeVC?.PresenterCallBackError(error: error, type: "")
    }
}
