//
//  ContentView.swift
//  ios-ds
//
//  Created by Prateek Machiraju on 8/22/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(String(initializeDS()))
            .padding()
    }
    
}

func initializeDS() -> UInt32 {
    let alliance = DS_Alliance_new_blue(1);
    let ds = DS_DriverStation_new_ip("10.33.24.2", alliance, 3324)
        
    print(DS_DriverStation_battery_voltage(ds));
    
    let num = DS_DriverStation_get_team_number(ds);
    return num;
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
