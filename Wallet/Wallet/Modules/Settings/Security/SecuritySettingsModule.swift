import Foundation

protocol ISecuritySettingsView: class {
    func set(title: String)
    func set(biometricUnlockOn: Bool)
    func set(backedUp: Bool)
}

protocol ISecuritySettingsViewDelegate {
    func viewDidLoad()
    func didSwitch(biometricUnlockOn: Bool)
    func didTapEditPin()
    func didTapSecretKey()
}

protocol ISecuritySettingsInteractor {
    var isBiometricUnlockOn: Bool { get }
    var isBackedUp: Bool { get }
    func set(biometricUnlockOn: Bool)
}

protocol ISecuritySettingsInteractorDelegate: class {
    func didBackup()
}

protocol ISecuritySettingsRouter {
    func showEditPin()
    func showSecretKey()
}