import SwiftUI
import FirebaseStorage

struct ProfileEditPage: View {
    @State private var user: UserData
    @State private var selectImage = UIImage()
    @State private var isShowPhotoLibrary = false
    @State private var fullname: String
    @EnvironmentObject var viewModel: ProfileEditPageViewModel
    
    init(user: UserData) {
        self._user = State(initialValue: user)
        self._fullname = State(initialValue: user.fullname)
    }
    
    var body: some View {
        VStack {
            Image(uiImage: self.selectImage)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .edgesIgnoringSafeArea(.all)
            
            InputField(
                text: $fullname,
                title: "fullname",
                placeholder: "Enter your full name"
            )
            .padding(.horizontal, 40)
            
            Button(action: {
                self.isShowPhotoLibrary = true
            }, label: {
                Text("画像を選択")
                    .padding()
            })
            
            Button(action: {
                Task {
                    let storageRef = Storage.storage().reference(forURL: "gs://noname-383d9.appspot.com").child(user.id).child("profileImage")
                    let url = try await viewModel.uploadImage(user: user, image: selectImage, storageRef: storageRef)
                    
                    try await viewModel.updateProfileData(user: user, imageURL: url.absoluteString)
                    print("success profile image")
                }
            }, label: {
                Text("保存")
                    .padding()
            })
        }
        .sheet(isPresented: $isShowPhotoLibrary, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$selectImage)
        })
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
