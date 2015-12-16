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
    
    @IBOutlet weak var respuesta: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        campoTexto.delegate=self
        
    }

    func asincrono(isbn: String ){
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession()
        let bloque = {
            (datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
                if(error != nil){
                    print(error!)
                }
                else{
                    let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            
                    dispatch_async(dispatch_get_main_queue(),{
                        self.respuesta.text="\(texto!)"
                    })
                }
        }
        
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()        
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
        asincrono(textField.text!)
        return true
    }
    
    /////////////////////////////////////////////////////////////////////
    
    @IBAction func limpiar(sender: UIButton) {
        campoTexto.text=""
        respuesta.text=""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

