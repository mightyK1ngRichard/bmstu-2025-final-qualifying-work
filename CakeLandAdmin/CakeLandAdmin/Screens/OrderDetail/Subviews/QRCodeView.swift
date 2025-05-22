//
//  QRCodeView.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 22.05.2025.
//

import Cocoa
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let urlString: String
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        if let image = generateQRCode(from: urlString) {
            Image(nsImage: image)
                .interpolation(.none)
                .resizable()
                .frame(width: 200, height: 200)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 4)
        } else {
            Text("Не удалось создать QR-код")
        }
    }

    func generateQRCode(from string: String) -> NSImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        guard let outputImage = filter.outputImage else { return nil }
        let transformed = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))

        if let cgImage = context.createCGImage(transformed, from: transformed.extent) {
            let size = NSSize(width: transformed.extent.width, height: transformed.extent.height)
            let nsImage = NSImage(cgImage: cgImage, size: size)
            return nsImage
        }

        return nil
    }
}

#Preview {
    QRCodeView(urlString: "cakeland://cake/550e8400-e29b-41d4-a716-446655441205")
}
