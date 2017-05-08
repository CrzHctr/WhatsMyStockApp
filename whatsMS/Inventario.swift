//
//  Inventario.swift
//  whatsMS
//
//  Created by Oscar Glez on 4/12/17.
//  Copyright © 2017 Oscar Glez. All rights reserved.
//


import Foundation
import UIKit

class Inventario: UITableViewController, UISearchResultsUpdating {
    
    var detailViewController: ViewController? = nil
    
    var arrNombres = [String]()
    var arrNombresFiltrados = [String]()
    var arrIDs = [String]()
    var arrIDsConsultados = [String]()
    var idConsultado = "0"
    
    var searchController : UISearchController!
    var resultados = UITableViewController()
    var pagina = 2
    var banderaDidSelect = false
    
    //////// BD
    
    // MARK: - Funciones de la BD
    // Apuntador a la BD
    var baseDatos: OpaquePointer? = nil
    
    func abrirBaseDatos() -> Bool {
        if let path = obtenerPath("baseDatos.txt") {
            print(path)
            if sqlite3_open(path.absoluteString, &baseDatos) == SQLITE_OK {
                return true
            }
            // Error
            sqlite3_close(baseDatos)
        }
        return false
    }
    
    func crearTabla(nombreTabla: String) -> Bool {
        let sqlCreaTabla = "CREATE TABLE IF NOT EXISTS \(nombreTabla)" +
        "(CODIGO TEXT PRIMARY KEY, NOMBRE TEXT,COSTO TEXT, CANTIDAD DECIMAL, PROVEEDOR TEXT, TIEMPOENTREGA TEXT, NIVELSERVICIO TEXT, CANTIDADANUAL TEXT, UNIDADPORCAJA TEXT, MAXIMO TEXT, MINIMO TEXT)"
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
    
    func consultarBaseDatos() {
        arrNombres.removeAll()
        arrIDs.removeAll()
        let sqlConsulta = "SELECT * FROM PRODUCTOS"
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
                let minimo = String.init(cString:sqlite3_column_text(declaracion, 10))
                
                print("\(codigo), \(nombre), \(costo), \(cantidad),\(proveedor), \(tiempo), \(nivelServicio), \(cantidadAnual), \(unidadPorCaja), \(maximo), \(minimo)")
                arrNombres.append(nombre)
                var codigo2 = "-1"
                print("codigo \(codigo)")
                if(codigo != nil){
                    codigo2 = codigo
                }
                else{
                    print("No se pudo desenvolver codigo \(codigo)")
                }
                arrIDs.append(codigo2)
            }
        }
    }
    
    func borrarRegistro(codigo: String) {
        print("numero de registro a borrar: '\(codigo)'")
        let sqlConsulta = "SELECT * FROM PRODUCTOS WHERE CODIGO= '\(codigo)'"
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
                print("informacion de lo que se borrara \(codigo), \(nombre), \(costo),\(cantidad), \(proveedor), \(tiempo), \(nivelServicio), \(cantidadAnual), \(unidadPorCaja), \(maximo), \(minimo)")
            }
        }
        
        let query = "DELETE FROM PRODUCTOS WHERE CODIGO = '\(codigo)'"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, query, nil, nil, &error) == SQLITE_OK {
            print("Registro borrado")
        } else {
            print("Error al borrar: \(codigo)")
            let msg = String.init(cString: error!)
            print("Error: \(msg)")
        }
    }
    
    //////// FIN BD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        self.searchController = UISearchController(searchResultsController: self.resultados)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        self.resultados.tableView.dataSource = self
        self.resultados.tableView.delegate = self
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ViewController
        }
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        super.viewDidLoad()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        print("search")
        if(self.searchController.searchBar.text!.lowercased() != ""){
            banderaDidSelect = true
        }
        else{
            banderaDidSelect = false
        }
        self.arrNombresFiltrados.removeAll()
        self.arrIDsConsultados.removeAll()
        //for index in (arrNombres.count.predecessor()).stride(through: 0, by: 1) {
        
        
        for index in stride(from: 0, to:(arrNombres.count), by: 1) {
            if(arrNombres[index].lowercased().contains(self.searchController.searchBar.text!.lowercased())){
                print("encontrado  \(arrNombres[index])")
                self.arrNombresFiltrados.append(arrNombres[index])
                self.arrIDsConsultados.append(arrIDs[index])
                
            }
            //        for index in 0 ... arrNombres.count - 1 {
            //            if(arrNombres[index].lowercased().contains(self.searchController.searchBar.text!.lowercased())){
            //                print("encontrado  \(arrNombres[index])")
            //                self.arrNombresFiltrados.append(arrNombres[index])
            //                self.arrIDsConsultados.append(arrIDs[index])
            //            }
            //        }
            
            // Actualizar TableView
            self.resultados.tableView.reloadData()
        }
    }
    
    func addButton(_ sender: Any) {
        pagina = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        print("viewwillappear")
        ///////BD
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
        
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("tableview editing")
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            print(indexPath.row)
            arrNombres.remove(at: indexPath.row)
            print("indice")
            let indice1 = arrIDs[indexPath.row]
            print(indice1)
            
            
            if abrirBaseDatos() {
                print("se intentara abrir la base de datos")
                if crearTabla(nombreTabla: "PRODUCTOS") {
                    print("se intentara abrir la base de datos")
                    borrarRegistro(codigo: indice1)
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
            arrIDs.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(banderaDidSelect){
            banderaDidSelect = false
            // Get Cell Label
            let indexPath = tableView.indexPathForSelectedRow!
            print("asignando valor idconsultado = \(indexPath[1])")
            let indice1 = arrIDsConsultados[indexPath[1]]
            idConsultado = indice1
            print("el idconsultado asignado es \(idConsultado)")
            //idConsultado = currentCell.textLabel!.text
            performSegue(withIdentifier: "descripcionFiltro", sender: self)
        }
            
        else{
            print("se selecciono algo normal de la base")
            performSegue(withIdentifier: "descripcionBase", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("entraste al prepare")
        if (pagina == 2){
            print(2)
            if (segue.identifier == "descripcionFiltro") {
                print("entro a cosa rara")
                let viewController = segue.destination as! detalleProducto
                viewController.detailItem = idConsultado
                banderaDidSelect = false
            }
            else if (segue.identifier == "descripcionBase") {
                print(3)
                let indexPath = self.tableView.indexPathForSelectedRow
                let indice1 = arrIDs[(indexPath?[1])!]
                idConsultado = indice1
                let controller = segue.destination as! detalleProducto
                controller.detailItem = idConsultado
            }
        }
        else if(pagina == 1){
            print(1)
            pagina = 2
        }
        else{
            print("ptm")
        }
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return arrNombres.count
        } else {
            return self.arrNombresFiltrados.count
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.tableView) {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
            celda.textLabel?.text = arrNombres[indexPath.row]
            return celda
        } else {
            let celda = self.tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
            celda.textLabel?.text = arrNombresFiltrados[indexPath.row]
            return celda
        }
        
        
    }
}
