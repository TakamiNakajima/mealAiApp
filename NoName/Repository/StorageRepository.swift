//
//  StorageRepository.swift
//  NoName
//
//  Created by 中島昂海 on 2024/10/20.
//

import Foundation
import UIKit
import FirebaseStorage

class StorageRepository: ObservableObject {
    
    // 画像をStoregeに保存する
    func uploadImageToFirebaseStorage(image: UIImage, userId: String, mealId: String) async throws -> String {
        // Firebase Storage の参照を取得
        let storageRef = Storage.storage().reference()
        
        // アップロードする画像データをJPEG形式で取得 (圧縮率を0.8に設定)
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }
        
        // アップロードするファイル名を設定
        let fileName = "meals/\(userId)/\(mealId).jpg"
        let imageRef = storageRef.child(fileName)
        
        // 画像をFirebase Storageにアップロード
        let _ = try await imageRef.putDataAsync(imageData, metadata: nil)
        
        // ダウンロードURLを取得
        let url = try await imageRef.downloadURL()
        
        // ダウンロードURLをStringで返す
        return url.absoluteString
    }
}
