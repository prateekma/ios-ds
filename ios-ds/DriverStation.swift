//
//  File.swift
//  ios-ds
//
//  Created by Prateek Machiraju on 8/23/20.
//

import Foundation


/// Global stdout (message queue)
var messageQueue = MessageStack()

/// This class is a wrapper around the C DriverStation class to make it
/// more usable from Swift code.
class DriverStation {
  /// The DriverStation instance.
  var ds: OpaquePointer;
  
  
  /// Creates a DriverStation with a given team number and alliance.
  init(team: UInt32, alliance: Alliance) {
    // Create driver station
    ds = DS_DriverStation_new_team(team, DriverStation.getRawAlliance(alliance: alliance))
    
    // Add this DS's messages to the global message queue.
    setTCPConsumer()
  }
  
  /// Destroys the driver station instance when this class is destroyed.
  deinit {
    DS_DriverStation_destroy(ds);
  }
  
  /// Return battery voltage.
  func getBatteryVoltage() -> Float {
    return DS_DriverStation_battery_voltage(ds);
  }
  
  /// Enable the robot.
  func enable() {
    DS_DriverStation_enable(ds);
  }
  
  /// Disable the robot.
  func disable() {
    DS_DriverStation_disable(ds);
  }
  
  /// Returns whether the robot is enabled.
  func isEnabled() -> Bool {
    return DS_DriverStation_enabled(ds);
  }
  
  /// Emergency stops the robot.
  func estop() {
    DS_DriverStation_estop(ds);
  }
  
  /// Returns whether the robot is emergency stopped.
  func isEstopped() -> Bool {
    return DS_DriverStation_estopped(ds);
  }
  
  /// Returns the driver station mode.
  func getDSMode() -> DSMode {
    var mode = DsMode.init(rawValue: 0);
    withUnsafeMutablePointer(to: &mode, { (ptr: UnsafeMutablePointer<DsMode>) -> Void in
      DS_DriverStation_get_ds_mode(ds, ptr)
    })
    return DSMode(rawValue: mode.rawValue)!
  }
  
  /// Return the current game mode (autonomous, teleoperated, test)
  func getGameMode() -> GameMode {
    var mode = Mode.init(0);
    withUnsafeMutablePointer(to: &mode) { (ptr: UnsafeMutablePointer<Mode>) -> Void in
      DS_DriverStation_get_mode(ds, ptr)
    }
    return GameMode(rawValue: mode.rawValue)!
  }
  
  /// Returns the team number of the DS.
  func getTeamNumber() -> UInt32 {
    return DS_DriverStation_get_team_number(ds)
  }
  
  /// Restarts code.
  func restartCode() {
    DS_DriverStation_restart_code(ds)
  }
  
  /// Restarts the roboRIO
  func restartRoboRIO() {
    DS_DriverStation_restart_roborio(ds);
  }
  
  /// Sets the DriverStation alliance.
  func setAlliance(alliance: Alliance) {
    DS_DriverStation_set_alliance(ds, DriverStation.getRawAlliance(alliance: alliance))
  }
  
  /// Sets the game specific message.
  func setGameSpecificMessage(message: String) -> Int8 {
    return DS_DriverStation_set_game_specific_message(ds, message)
  }
  
  /// Sets the team number.
  func setTeamNumber(team: UInt32) {
    DS_DriverStation_set_team_number(ds, team)
  }
  
  private func setTCPConsumer() {
    DS_DriverStation_set_tcp_consumer(ds) { (msg: StdoutMessage) in
      messageQueue.push(String(cString: msg.message))
    }
  }

  /// Return pointer to alliance type from the Alliance enum.
  private static func getRawAlliance(alliance: Alliance) -> OpaquePointer {
    switch alliance {
    case .Blue:
      return DS_Alliance_new_blue(1);
    case .Red:
      return DS_Alliance_new_red(1);
    }
  }
}
