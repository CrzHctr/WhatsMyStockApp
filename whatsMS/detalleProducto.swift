//
//  ViewController.swift
//  whatsMS
//
//  Created by Oscar Glez on 4/12/17.
//  Copyright © 2017 Oscar Glez. All rights reserved.
//

import UIKit

class detalleProducto: UIViewController {
    
    
    var codigoGlobal = ""
    var nombreGlobal = ""
    var cantidadGlobal = ""
    var proveedorGlobal = ""
    var tiempoGlobal = ""
    var nivelGlobal = ""
    var cantidadAnualGlobal = ""
    var unidadCajaGlobal = ""
    var maximoGlobal = ""
    var minimoGlobal = ""
    var costoGlobal = ""
    
    var IDItem = "-1valorespecial"
    
    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    @IBOutlet weak var nombretf: UITextField!
    @IBOutlet weak var codigotf: UITextField!
    @IBOutlet weak var cantidadtf: UITextField!
    @IBOutlet weak var proveedortf: UITextField!
    @IBOutlet weak var tiempotf: UITextField!
    @IBOutlet weak var niveltf: UITextField!
    @IBOutlet weak var cantidadAnualtf: UITextField!
    @IBOutlet weak var unidadCajatf: UITextField!
    @IBOutlet weak var maximotf: UITextField!
    @IBOutlet weak var minimotf: UITextField!
    @IBOutlet weak var costotf: UITextField!
    
    
    
    @IBAction func actualizar(_ sender: Any) {
        
        print("se actualizaran los datos")
        codigoGlobal = codigotf.text!
        nombreGlobal = nombretf.text!
        cantidadGlobal = cantidadtf.text!
        proveedorGlobal = proveedortf.text!
        tiempoGlobal = tiempotf.text!
        nivelGlobal = niveltf.text!
        cantidadAnualGlobal = cantidadAnualtf.text!
        unidadCajaGlobal = unidadCajatf.text!
        costoGlobal = costotf.text!
        
        ///////////////////////////////////////////////////////////////////////
        if let indexPath = Float(cantidadAnualGlobal) {
            print("valor de index correcto, se usara", indexPath)
            if let indexPath2 = Float(tiempoGlobal) {
                maximoGlobal = String(indexPath * indexPath2)
                print("el maximo global se calculo como \(maximoGlobal)")
            }
        }
        else{
            print("hay datos raros")
            self.maximoGlobal = "1"
        }
        
        var diccionario: [Float: Float] = [99:2.576,98:2.326,97:2.103,96:2.055,95:1.96,94:1.883,93:1.812,92:1.75,91:1.721,90:1.645,89:1.631,88:1.597,87:1.548,86:1.52,85:1.44,84:1.39,83:1.36,82:1.30,81:1.29,80:1.28,79:1.25,78:1.221,77:1.206,76:1.188,75:1.15,74:1.113,73:1.09,72:1.0711,71:1.0528,70:1.04,69:1.0,68:1.0,67:1.0,66:1.0,65:1.0,64:1.0,63:1.0,62:1.0,61:1.0,60:1.0,59:1.0,58:1.0,57:1.0,56:1.0,55:1.0,54:1.0,53:1.0,52:1.0,51:1.0,50:1.0,49:1.0,48:1.0,47:1.0,46:1.0,45:1.0,44:1.0,43:1.0,42:1.0,41:1.0,40:1.0,39:1.0,38:1.0,37:1.0,36:1.0,35:1.0,34:1.0,33:1.0,32:1.0,31:1.0,30:1.0,29:1.0,28:1.0,27:1.0,26:1.0,25:1.0,24:1.0,23:1.0,22:1.0,21:1.0,20:1.0,19:1.0,18:1.0,17:1.0,16:1.0,15:1.0,14:1.0,13:1.0,12:1.0,11:1.0,10:1.0,9:1.0,8:1.0,7:1.0,6:1.0,5:1.0,4:1.0,3:1.0,2:1.0,1:1.0,0.0:1.0,]
        
        let desvEst = round(((Float(cantidadAnualGlobal)! * 10) / 100))
        
        if var indexPath = Float(nivelGlobal) {
            if indexPath > 99 {
                indexPath = 99
                print("valor de index mayor a 99, se usara", indexPath)
                
            } else if indexPath < 1 {
                indexPath = 1
                print("valor de index menor a 1, se usara", indexPath)
            }
            print("el valor de calidad es de \(indexPath) y su correspondiendte es \(String(describing: diccionario[indexPath]))")
            let valor = (desvEst * Float(diccionario[indexPath]!))
            if(valor == nil){
                print("")
                self.minimoGlobal = "1"
            }
            else{
                let value = "\(valor)"
                print("el valor de diccionario es \(value)")
                self.minimoGlobal = value
            }
            print("el minimo global se calculo como \(minimoGlobal)")
        }
        ///////////////////////////////////////////////////////////////////////
        
        
        if(codigoGlobal != nil && nombreGlobal != nil && cantidadGlobal != nil && proveedorGlobal != nil && tiempoGlobal != nil && nivelGlobal != nil && cantidadAnualGlobal != nil && unidadCajaGlobal != nil && costoGlobal != nil && codigoGlobal != "" && nombreGlobal != "" && cantidadGlobal != "" && proveedorGlobal != "" && tiempoGlobal != "" && nivelGlobal != "" && cantidadAnualGlobal != "" && unidadCajaGlobal != "" && costoGlobal != ""){
            
            print("no hay datos nulos")
            if abrirBaseDatos() {
                print("se abrio la base de datos")
                if crearTabla(nombreTabla: "PRODUCTOS") {
                    print("se intentara abrir la base de datos")
                    insertarDatos()
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
        }
        else{
            print("hay datos nulos")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nombretf.resignFirstResponder()
        codigotf.resignFirstResponder()
        cantidadtf.resignFirstResponder()
        proveedortf.resignFirstResponder()
        tiempotf.resignFirstResponder()
        niveltf.resignFirstResponder()
        cantidadAnualtf.resignFirstResponder()
        unidadCajatf.resignFirstResponder()
        costotf.resignFirstResponder()
        maximotf.resignFirstResponder()
        minimotf.resignFirstResponder()
        return (true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if detailItem != nil {
            print("si se pudo")
            print("se leeran los datos de \(String(describing: detailItem))")
            IDItem = detailItem!
        }
        else{
            print("no se pudo")
            print("se tiene que regresar")
            performSegue(withIdentifier: "regresoInventario", sender: self)
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        if abrirBaseDatos() {
            print("ok")
            if crearTabla(nombreTabla: "PRODUCTOS") {
                consultarBaseDatos()
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
    }
    
    
    //@IBOutlet weak var paginaWeb: UIWebView!
    
    func configureView() {
        // Update the user interface for the detail item.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //////// BD
    
    // MARK: - Funciones de la BD
    // Apuntador a la BD
    var baseDatos: OpaquePointer? = nil
    
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
    
    func obtenerPath(_ salida: String) -> URL? {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return path.appendingPathComponent(salida)
        }
        return nil
    }
    
    func insertarDatos() {
        print("se modificara un elemento")
        if abrirBaseDatos() {
            print("se  abrio la base de datos")
            if crearTabla(nombreTabla: "PRODUCTOS") {
                print("se abrio la tabla")
                
                let sqlInserta = "UPDATE PRODUCTOS SET NOMBRE = '\(nombreGlobal)', CODIGO = '\(codigoGlobal)', COSTO= '\(costoGlobal)',CANTIDAD= '\(cantidadGlobal)', PROVEEDOR = '\(proveedorGlobal)', TIEMPOENTREGA = '\(tiempoGlobal)', NIVELSERVICIO = '\(nivelGlobal)', CANTIDADANUAL = '\(cantidadAnualGlobal)', UNIDADPORCAJA = '\(unidadCajaGlobal)', MAXIMO = '\(maximoGlobal)', MINIMO = '\(minimoGlobal)' WHERE CODIGO = '\(IDItem)'"
                var error: UnsafeMutablePointer<Int8>? = nil
                if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK {
                    print("Error al insertar datos")
                    let msg = String.init(cString: error!)
                    print("Error: \(msg)")
                }
                else{
                    print("se insertaron correctamente los datos")
                }
                
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
    }
    
    func consultarBaseDatos() {
        print("se consultaran los datos de \(IDItem)")
        let sqlConsulta = "SELECT * FROM PRODUCTOS WHERE CODIGO = '\(IDItem)'"
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            while sqlite3_step(declaracion) == SQLITE_ROW {
                let codigo = String.init(cString: sqlite3_column_text(declaracion, 0))
                let nombre = String.init(cString: sqlite3_column_text(declaracion, 1))
                let costo = String.init(cString: sqlite3_column_text(declaracion, 2))
                
                let cantidad = String.init(cString: sqlite3_column_text(declaracion, 3))
                let proveedor = String.init(cString: sqlite3_column_text(declaracion, 4))
                let tiempo = String.init(cString: sqlite3_column_text(declaracion, 5))
                let nivelServicio = String.init(cString: sqlite3_column_text(declaracion, 6))
                let cantidadAnual = String.init(cString: sqlite3_column_text(declaracion, 7))
                let unidadPorCaja = String.init(cString: sqlite3_column_text(declaracion, 8))
                let maximo = String.init(cString: sqlite3_column_text(declaracion, 9))
                let minimo = String.init(cString: sqlite3_column_text(declaracion, 10))
                print("\(codigo), \(nombre), \(costo), \(cantidad), \(proveedor), \(tiempo), \(nivelServicio), \(cantidadAnual), \(unidadPorCaja), \(maximo), \(minimo)")
                nombretf.text = nombre
                codigotf.text = codigo
                costotf.text = costo
                cantidadtf.text = cantidad
                proveedortf.text = proveedor
                tiempotf.text = tiempo
                niveltf.text = nivelServicio
                cantidadAnualtf.text = cantidadAnual
                unidadCajatf.text = unidadPorCaja
                maximotf.text = maximo
                minimotf.text = minimo
                
            }
        }
        print("se termino de hacer la consulta")
    }
}
