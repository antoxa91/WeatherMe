//
//  NewsMeTests.swift
//  NewsMeTests
//
//  Created by Антон Стафеев on 09.09.2022.
//

import XCTest
@testable import WeatherMe

final class AsynchronousTest: XCTestCase {
    
    let timeout: TimeInterval = 2
    var expectation: XCTestExpectation!
    
    override func setUp() {
        expectation = expectation(description: "Server responds in reasonable time")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_decodeWeather() {

        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?&appid=\(apiKey)&units=metric&lang=ru&lat=55.45&lon=37.36")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {self.expectation.fulfill()}
            
            XCTAssertNil(error)
            
            do {
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                
                let data = try XCTUnwrap(data)
                XCTAssertNoThrow(
                    try JSONDecoder().decode(WeatherResponse.self, from: data)
                )
            }
            catch {
                print(error)
            }
            
        }
        .resume()
        
        waitForExpectations(timeout: timeout)
    }
}
