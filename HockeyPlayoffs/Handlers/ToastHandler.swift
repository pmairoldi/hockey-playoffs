import Toast

@MainActor
enum ToastHandler {
    static func show(_ message: String) {
        Toast.text(message).show()
    }

    static func showError(_ error: Error) {
        show(error.localizedDescription)
    }
}
