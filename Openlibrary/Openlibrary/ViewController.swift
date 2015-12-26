//
//  ViewController.swift
//  Openlibrary
//
//  Created by Victor Chisvert Amat on 15/12/15.
//  Copyright © 2015 Victor Chisvert Amat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var campoTexto: UITextField!
    
    @IBOutlet weak var labelTitulo: UILabel!    
    
    @IBOutlet weak var labelAutores: UILabel!
  
    @IBOutlet weak var labelPortada: UILabel!    
    
    @IBOutlet weak var imagePortada: UIImageView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        campoTexto.delegate=self
        //campoTexto.text="9788426721679"
        loading.hidden=true
        
    }

    func asincrono(isbn: String ){
        self.loading.hidden=false
        self.loading.startAnimating()
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession()
        let bloque = {
            (datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
                if(error != nil){
                    dispatch_async(dispatch_get_main_queue(),{
                        self.loading.stopAnimating()
                        self.loading.hidden=true
                        
                        let alert=UIAlertController(title: "Error", message: "No se puede realizar la conexión", preferredStyle: .Alert)
                        let okAction=UIAlertAction(title: "OK", style: .Default){ (action) in }
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
                else{
                    dispatch_async(dispatch_get_main_queue(),{
                        self.rellenarCampos(datos!)
                    })
                }
        }
        
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()        
    }
    
    func rellenarCampos(datos: NSData){
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(datos, options: NSJSONReadingOptions.MutableLeaves)
            let dicc1 = json as! NSDictionary
            let first = dicc1.allValues[0]
            let dicc2 = first as! NSDictionary
            
            var titulo="Sin titulo"
            let title=dicc2["title"]
            if(title != nil){
                titulo=title as! String
            }
            
            labelTitulo.text="Titulo: \(titulo)"
            
            var autores=""
            let authors=dicc2["authors"]
            if(authors != nil){
                let authors_array=authors as! NSArray
                if(authors_array.count>0){
                    for autor in authors_array {
                        let aux = autor as! NSDictionary
                        let nombre = aux["name"]!
                        autores+="\(nombre) \n"
                    }
                }
            }
            else{
                autores="Sin autor/es"
            }
            
            labelAutores.text = "Autor/es: \(autores)"
            
            var portada=""
            let cover = dicc2["cover"]
            if cover != nil {
                let aux=cover as! NSDictionary
                let medium = aux["medium"]
                if(medium != nil){
                    portada=medium as! String
                }
            }
            
            if(portada==""){
                labelPortada.text="Sin portada"
            }
            else{
                labelPortada.text = "Portada: "
                ponerImagen(portada)
            }
            
        }
        catch _ {
            print("Error")
        }
        self.loading.stopAnimating()
        self.loading.hidden=true
        
    }
    
    func ponerImagen(url : String){
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        let image=UIImage(data: data!)
        imagePortada.image=image
    }
   
    //////////////////// Gestion del teclado /////////////////////////////
    
    
    //Para ocultar el teclado cuando el campo pierde el foco
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    
    // Metodo de UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        print(textField.text!)
        
        labelTitulo.text="Titulo:"
        labelAutores.text="Autores"
        labelPortada.text="Portada"
        imagePortada.image=nil
        
        asincrono(textField.text!)
        return true
    }
    
    /////////////////////////////////////////////////////////////////////
    
    @IBAction func limpiar(sender: UIButton) {
        campoTexto.text=""
        labelTitulo.text="Titulo:"
        labelAutores.text="Autores"
        labelPortada.text="Portada"
        imagePortada.image=nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

