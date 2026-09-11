import Flutter
import UIKit
import app_links

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// Ссылка, которой приложение запустили из закрытого состояния
  /// (`rabbitfarm://join?phone=…`).
  ///
  /// Движок здесь поднимается отложенно, и плагины регистрируются уже после
  /// `didFinishLaunchingWithOptions` — к этому моменту событие открытия
  /// ссылки для плагина `app_links` успевает пройти мимо. Придерживаем URL и
  /// отдаём его сразу после регистрации.
  private var launchLink: URL?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    launchLink = AppLinks.shared.getLink(launchOptions: launchOptions)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    if let url = launchLink {
      launchLink = nil
      AppLinks.shared.handleLink(url: url)
    }
  }
}
