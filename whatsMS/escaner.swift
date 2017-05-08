//
//  ViewController.swift
//  PruebaReachJSONScanner
//
//  Created by Roberto Martinez Roman on 01/03/17.
//  Copyright © 2017 Roberto Martinez Roman. All rights reserved.
//

import UIKit

class escaner: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate
{
    
    let lector = BarcodeScannerController()
    
    @IBOutlet weak var tfCodigo: UITextField!
    @IBOutlet weak var tfNombre: UITextField!
    
    @IBOutlet weak var registrar: UIButton!
    @IBOutlet weak var modificar: UIButton!
    @IBOutlet weak var infoNoRegistrado: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var agregarTxt: UILabel!
    @IBOutlet weak var eliminarTxt: UILabel!
    
    @IBOutlet weak var numeroIn: UITextField!
    @IBOutlet weak var numeroOut: UITextField!
    
    @IBOutlet weak var labelEliminado: UILabel!
    
    @IBOutlet weak var labelAgregado: UILabel!
    
    var cantidadGlobal = ""
    var cantidadSumada = ""
    var cantidadRestada = ""
    var numeroInt = ""
    var numeroOut2 = ""
    
    @IBOutlet weak var agregar: UIButton!
    @IBAction func agregarBtn(_ sender: Any) {
        
        numeroInt = numeroIn.text!
        //cantidadSumada = cantidadGlobal + numeroIn
        
        if let indexPath = Float(cantidadGlobal) {
            if let indexPath2 = Float(numeroInt) {
                self.cantidadSumada = String(indexPath + indexPath2)
                print("cantidad nueva se calculo como \(cantidadSumada)")
            }
        }

        cantidadGlobal = numeroIn.text!
        
        if(cantidadGlobal != nil && cantidadGlobal != ""){
            if abrirBaseDatos() {
                print("se intentara abrir la base de datos")
                if crearTabla(nombreTabla: "PRODUCTOS") {
                    print("se intentara abrir la base de datos")
                    insertarDatos()
                    print("---------------")
                    // Cerrar BD
                    sqlite3_close(baseDatos)
                }
                else {
                    print("No se puede crear la tabla")
                }
            }
            else {
                print("Error al abrir la base de datos")
            }
            print("Se modificaron datos")
            self.agregar.isHidden = true
            self.labelAgregado.isHidden = false
        }
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBOutlet weak var eliminar: UIButton!
    @IBAction func eliminarBtn(_ sender: Any) {
        numeroOut2 = numeroOut.text!
        
        if let indexPath = Float(cantidadGlobal) {
            if let indexPath2 = Float(numeroOut2) {
                self.cantidadRestada = String(indexPath - indexPath2)
                print("cantidad nueva se calculo como \(cantidadRestada)")
            }
        }
        
        cantidadGlobal = numeroOut.text!
        
        if(cantidadGlobal != nil && cantidadGlobal != ""){
            if abrirBaseDatos() {
                print("se intentara abrir la base de datos")
                if crearTabla(nombreTabla: "PRODUCTOS") {
                    print("se intentara abrir la base de datos")
                    insertarDatos2()
                    print("---------------")
                    // Cerrar BD
                    sqlite3_close(baseDatos)
                }
                else {
                    print("No se puede crear la tabla")
                }
            }
            else {
                print("Error al abrir la base de datos")
            }
            print("Se modificaron datos")
            self.eliminar.isHidden = true
            self.labelEliminado.isHidden = false
        }
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func cambioOpcion(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.agregarTxt.isHidden = false
            self.eliminarTxt.isHidden = true
            self.agregar.isHidden = false
            self.eliminar.isHidden = true
            self.numeroIn.isHidden = false
            self.numeroOut.isHidden = true
            self.labelAgregado.isHidden = true
            self.labelEliminado.isHidden = true
        case 1:
            self.eliminarTxt.isHidden = false
            self.agregarTxt.isHidden = true
            self.agregar.isHidden = true
            self.eliminar.isHidden = false
            self.numeroIn.isHidden = true
            self.numeroOut.isHidden = false
            self.labelAgregado.isHidden = true
            self.labelEliminado.isHidden = true
        default:
            break
        }
    }
    

    var existeDato = false;
    
    var baseDatos: OpaquePointer? = nil
    
    var idEscaneado = ""
    var nombreProdEscaneado = ""
    
    var pagina = 0
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print("Código: \(code), tipo: \(type)")
        self.registrar.isHidden = true
        self.modificar.isHidden = true
        self.infoNoRegistrado.isHidden = true
        self.agregarTxt.isHidden = true
        self.eliminarTxt.isHidden = true
        self.segmentedControl.isHidden = true
        self.tfNombre.isHidden = true
        self.numeroIn.isHidden = true
        self.numeroOut.isHidden = true
        self.agregar.isHidden = true
        self.eliminar.isHidden = true
        self.labelAgregado.isHidden = true
        self.labelEliminado.isHidden = true
        
        existeDato = false
        
        
        if abrirBaseDatos() {
            print("se intentara abrir la base de datos")
            if crearTabla(nombreTabla: "PRODUCTOS") {
                print("se intentara abrir la base de datos")
                verificarExistencia(codigo: code)
                print("---------------")
                // Cerrar BD
                sqlite3_close(baseDatos)
            }
            else {
                print("No se puede crear la tabla")
            }
        }
        else {
            print("Error al abrir la base de datos")
        }
    
        if(existeDato){
            self.registrar.isHidden = true
            self.modificar.isHidden = false
            self.infoNoRegistrado.isHidden = true
            self.agregarTxt.isHidden = false
            self.eliminarTxt.isHidden = true
            self.segmentedControl.isHidden = false
            self.tfNombre.isHidden = false
            self.numeroIn.isHidden = false
            self.numeroOut.isHidden = true
            self.agregar.isHidden = false
            self.eliminar.isHidden = true
            self.labelAgregado.isHidden = true
            self.labelEliminado.isHidden = true
            
        }
        else{
            self.registrar.isHidden = false
            self.modificar.isHidden = true
            self.infoNoRegistrado.isHidden = false
            self.agregarTxt.isHidden = true
            self.eliminarTxt.isHidden = true
            self.segmentedControl.isHidden = true
            self.tfNombre.isHidden = true
            self.numeroIn.isHidden = true
            self.numeroOut.isHidden = true
            self.agregar.isHidden = true
            self.eliminar.isHidden = true
            self.labelAgregado.isHidden = true
            self.labelEliminado.isHidden = true
            
        }
        // DESPUES de cierto tiempo
        tfCodigo.text = code
        idEscaneado = code
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func verificarExistencia(codigo : String){
        
        let code = codigo
            let sqlConsulta = "SELECT * FROM PRODUCTOS WHERE CODIGO= '\(code)'"
            var declaracion: OpaquePointer? = nil
            ////
            if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
                while sqlite3_step(declaracion) == SQLITE_ROW {
                    let nombre = String.init(cString: sqlite3_column_text(declaracion, 1))
                    let cantidad = String.init(cString: sqlite3_column_text(declaracion, 3))
                    nombreProdEscaneado = nombre
                    cantidadGlobal = cantidad
                    tfNombre.text = nombre
                    
                }
            }
            ////
            if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
                print("se buscara el codigo \(code)")
                var contador = 0
                while sqlite3_step(declaracion) == SQLITE_ROW {
                    contador = contador + 1
                }
                
                print("contador = \(contador)")
                
                if(contador > 0){
                    print("Ya existe el dato")
                    existeDato = true
                    pagina = 2
                }
                else{
                    print("No existe el dato 1")
                    existeDato = false
                    pagina = 1
                }
 
                
            }
            else{
                print("No existe el dato 2")
                existeDato = false
                pagina = 1
            }
    }
    
    func obtenerPath(_ salida: String) -> URL? {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return path.appendingPathComponent(salida)
        }
        return nil
    }
    
    func abrirBaseDatos() -> Bool {
        if let path = obtenerPath("baseDatos.txt") {
            print(path)
            if sqlite3_open(path.absoluteString, &baseDatos) == SQLITE_OK { return true
            }
            // Error
            sqlite3_close(baseDatos)
        }
        return false
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    func crearTabla(nombreTabla: String) -> Bool {
        let sqlCreaTabla = "CREATE TABLE IF NOT EXISTS \(nombreTabla)" +
        "(CODIGO TEXT PRIMARY KEY, NOMBRE TEXT, COSTO TEXT,CANTIDAD DECIMAL, PROVEEDOR TEXT, TIEMPOENTREGA TEXT, NIVELSERVICIO TEXT, CANTIDADANUAL TEXT, UNIDADPORCAJA TEXT, MAXIMO TEXT, MINIMO TEXT)"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlCreaTabla, nil, nil, &error) == SQLITE_OK {
            return true
        }
        else {
            sqlite3_close(baseDatos)
            let msg = String.init(cString: error!)
            print("Error al crear tabla: \(msg)")
            return false
        }
    }
    
    func insertarDatos() {
        print("se modifico un elemento")
                let sqlInserta = "UPDATE PRODUCTOS SET CANTIDAD= '\(cantidadSumada)' WHERE CODIGO = '\(idEscaneado)'"
                var error: UnsafeMutablePointer<Int8>? = nil
                if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK {
                    print("Error al insertar datos")
                    let msg = String.init(cString: error!)
                    print("Error: \(msg)")
                }
    }
    func insertarDatos2() {
        print("se modifico un elemento")
        let sqlInserta = "UPDATE PRODUCTOS SET CANTIDAD= '\(cantidadRestada)' WHERE CODIGO = '\(idEscaneado)'"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK {
            print("Error al insertar datos")
            let msg = String.init(cString: error!)
            print("Error: \(msg)")
        }
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print("Error")
    }
    
    @IBAction func abrirScanner(_ sender: Any) {
        lector.reset()
        lector.codeDelegate = self
        lector.errorDelegate = self
        lector.dismissalDelegate = self
        present(lector, animated: true, completion: nil)
    }
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        idEscaneado = tfCodigo.text!
        controller.dismiss(animated: true, completion: nil)
        /*
         let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Inventario") as! Inventario
         self.present(viewController, animated: false, completion: nil)*/
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        existeDato = false
        self.registrar.isHidden = true
        self.modificar.isHidden = true
        self.infoNoRegistrado.isHidden = true
        self.agregarTxt.isHidden = true
        self.eliminarTxt.isHidden = true
        self.segmentedControl.isHidden = true
        self.tfNombre.isHidden = true
        self.numeroIn.isHidden = true
        self.numeroOut.isHidden = true
        self.agregar.isHidden = true
        self.eliminar.isHidden = true
        self.labelAgregado.isHidden = true
        self.labelEliminado.isHidden = true
        
        lector.reset()
        lector.codeDelegate = self
        lector.errorDelegate = self
        lector.dismissalDelegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        present(lector, animated: true, completion: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return (true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (pagina == 2){
            //idEscaneado = tfCodigo.text!
            let controller = segue.destination as! detalleProducto
            let idEnviado = idEscaneado
            controller.detailItem = idEnviado
            existeDato = false
            self.registrar.isHidden = true
            self.modificar.isHidden = true
            self.infoNoRegistrado.isHidden = true
            self.agregarTxt.isHidden = true
            self.eliminarTxt.isHidden = true
            self.segmentedControl.isHidden = true
            self.tfNombre.isHidden = true
            self.numeroIn.isHidden = true
            self.numeroOut.isHidden = true
            self.agregar.isHidden = true
            self.eliminar.isHidden = true
            self.labelAgregado.isHidden = true
            self.labelEliminado.isHidden = true
            
        }
        else if(pagina == 1){
            //idEscaneado = tfCodigo.text!
            let controller = segue.destination as! ViewController
            controller.codigoGlobal = idEscaneado
            existeDato = false
            self.registrar.isHidden = true
            self.modificar.isHidden = true
            self.infoNoRegistrado.isHidden = true
            self.agregarTxt.isHidden = true
            self.eliminarTxt.isHidden = true
            self.segmentedControl.isHidden = true
            self.tfNombre.isHidden = true
            self.numeroIn.isHidden = true
            self.numeroOut.isHidden = true
            self.agregar.isHidden = true
            self.eliminar.isHidden = true
            self.labelAgregado.isHidden = true
            self.labelEliminado.isHidden = true
           
        }
    }
    
}

