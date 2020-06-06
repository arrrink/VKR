//
//  VKRUITests.swift
//  VKRUITests
//
//  Created by Арина Нефёдова on 12.05.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import XCTest

class VKRUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["ВОЙТИ В СИСТЕМУ"].tap()
        app.buttons["Еще нет аккаунта в системе?  Регистрация"].tap()
        app.staticTexts["АС ПЛАНИРОВАНИЯ ТС"].tap()
        app.buttons["Заказчик"].tap()
        app.textFields["Имя"].tap()
        app.textFields["Email"].tap()
        app.textFields["Номер телефона"].tap()
        app.buttons["РЕГИСТРАЦИЯ"].tap()
        
        
        
        
        //StaticText, label: '+7 999 111 11 11',
       // StaticText, label: 'Арина Нефедова',
        //StaticText, label: 'Заявки',
      //  StaticText, label: 'Настройки',
       // StaticText, label: 'Выйти',
      //  StaticText, label: 'В пути на погрузку',
     //   StaticText, label: '+7 995 998 37 48',
     //   StaticText, label: 'А',
      //  StaticText, label: 'ПОСТРОИТЬ МАРШРУТ'
         //  app.staticTexts["Водитель не найден. Пожалуйста, попробуйте ещё раз.."].tap()
        //  app.staticTexts["НАЧАТЬ ПОЕЗДКУ"].tap()
             //  app.staticTexts["ЗАВЕРШИТЬ ПОЕЗДКУ"].tap()
       // app.staticTexts["Заявки"].tap()
       // app.staticTexts["ПОСТРОИТЬ МАРШРУТ"].tap()
     
       // app.buttons["menu"].tap()
     
        //app.staticTexts["Выйти"].tap()

    
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
