//
//  ImagenViewController.swift
//  RodriguezSnapchat
//
//  Created by Dante Rodriguez on 14/11/23.
//

import UIKit
import FirebaseStorage

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    //-----------
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(NSUUID().uuidString).jpg")
            cargarImagen.putData(imagenData!, metadata: nil){(metada,error) in
            if error != nil {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo.", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrio un error al subir imagen: \(error) ")
                return
            }else{
                cargarImagen.downloadURL(completion: { (url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen.", accion: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error al obtener informacion de imagen \(error)")
                        return
                    }
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                })
            }
        }
        /*let alertaCarga = UIAlertController(title: "Cargando Imagen ...", message: "0%", preferredStyle: .alert)
        let progresoCarga: UIProgressView = UIProgressView(progressViewStyle: .default)
        cargarImagen.observe(.progress) {(snapshot) in
            let porcentaje = Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
            print(porcentaje)
            progresoCarga.setProgress(Float(porcentaje), animated: true)
            progresoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
            alertaCarga.message = String(round(porcentaje*100.0)) + " %"
            if porcentaje>=1.0{
                alertaCarga.dismiss(animated: true, completion: nil)
            }
        }
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertaCarga.addAction(btnOK)
        alertaCarga.view.addSubview(progresoCarga)
        present(alertaCarga, animated: true, completion: nil)
        */
    }
    //-----------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func mostrarAlerta(titulo:String, mensaje:String, accion:String){
        let alerta = UIAlertController(title:titulo,message: mensaje, preferredStyle: .alert)
        let btnCACELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCACELOK)
        present(alerta,animated: true,completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
