// import HashMap "mo:base/HashMap";
// import Text "mo:base/Text";
// import Iter "mo:base/Iter";
// import Debug "mo:base/Debug";
// import Map "mo:map/Map";
// import {thash} "mo:map/Map";


import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";

actor Crud {
  type Id = Nat;
  type Tipo = {#topPart; #downPart};
  type Color = {#color; #blanco};
  type EstadoLimpieza = {#limpio; #sucio};
  type Calificacion = Nat8;

  public func esCalificacionValida(c : Calificacion) : async Bool {
    c <= 10
  };

  type TopPart = {
    id: Nat;
    tipo: Tipo;
    color: Color;
    calificacion: Calificacion;
    limpio: EstadoLimpieza;
  };

  type DownPart = {
    id: Nat;
    tipo: Tipo;
    color: Color;
    calificacion: Calificacion;
    limpio: EstadoLimpieza;
  };

  // Definimos un tipo Part que puede ser TopPart o DownPart
  type Part = {
    #topPart: TopPart;
    #downPart: DownPart;
  };

  // Creamos un HashMap para almacenar las partes
  let partsMap = HashMap.HashMap<Id, Part>(0, Nat.equal, Hash.hash);

  // Función para agregar una parte
  public func addPart(id: Id, tipo: Tipo, color: Color, calificacion: Calificacion, limpio: EstadoLimpieza) : async () {
    let part = switch (tipo) {
      case (#topPart) {
        #topPart({
          id = id;
          tipo = tipo;
          color = color;
          calificacion = calificacion;
          limpio = limpio;
        });
      };
      case (#downPart) {
        #downPart({
          id = id;
          tipo = tipo;
          color = color;
          calificacion = calificacion;
          limpio = limpio;
        });
      };
    };
    partsMap.put(id, part);
  };
};
  // let map =Map.new<Nombre, Perro>();
  // let perritos =HashMap.HashMap <Nombre, Perro>(0,Text.equal,Text.hash);

  // public func crearPerrito(perro: Perro){
  //   Map.set(map, thash, perro.nombre, perro);
  // };

  // public func borrarPerrito( nombre: Nombre){
  //   Map.delete(map, thash, nombre);
  // };

  // public func crearRegristro(nombre:Nombre, raza:Text, edad: Nat8){
  //   let perrito = {nombre; raza; edad; adoptado = false};
  //   perritos.put(nombre,perrito);
  //   Debug.print("Registro creado correctamente.");
  // };

  // public query func leerRegistro(nombre:Nombre): async ?Perro{
  //   perritos.get(nombre);
  // };
  
  // public query func leerRegistros(): async [(Nombre, Perro)]{
  //   let primerPaso: Iter.Iter<(Nombre, Perro)> = perritos.entries();
  //   let segundoPaso: [(Nombre, Perro)] = Iter.toArray(primerPaso);
  //   return segundoPaso;
  // };

  // public func actualizarRegistro(nombre: Nombre): async Bool{
  //   let perrito: Perro = perritos.get(nombre);

    // switch (perrito){
    //   case (null){
    //     Debug.print("Nose encontro el registro.");
    //     false
    //   };
    //   case(perritook){
    //     perritook.adoptado := true;
    //     perritos.put(nombre, perritook);
    //     true
    //   };
    //};
  
    // let perrito: ?Perro = perritos.get(nombre);

    // switch (perrito){
    //    case (null){
    //      Debug.print("Nose encontro el registro.");
    //      false
    //    };
    //    case(?perritook){
    //     let nuevoPerrito ={nombre; raza = perritook.raza; edad = perritook.edad; adoptado =true};
    //     perritos.put(nombre, nuevoPerrito);
    //     true
        // let nuevoPerrito: Perro = { raza = raza; nombre = perritoEncontrado.nombre; edad = perritoEncontrado.edad; adoptado = false};
        // perritos.put(perritoEncontrado.nombre, nuevoPerrito);
        // Debug.print("Perrito actualizado correctamente.");
        // true
//        };
//     };
//   };
//   public func borrarRegistro(nombre: Nombre): async Bool {
//     let perrito: ?Perro = perritos.get(nombre);
//     switch (perrito){
//        case (null){
//          Debug.print("Nose encontro el registro.");
//          false
//        };
//        case(_){
//           ignore perritos.remove(nombre);
//           Debug.print("Perrito borrado correctamente.");
//           true
//        };
//     };
//   };
// };



// import Debug "mo:base/Debug";
// import Principal "mo:base/Principal";
// import Result "mo:base/Result";

// actor Practica {
//   type DatosUsuario = (Text, Nat8, Principal);
//   type ResultadoUsuario = Result.Result<DatosUsuario, Text>;
//   type ResultadoStruct =Result.Result<Usuario,Text>;
// // structs
//   type Usuario = {
//     nombre: Text;
//     edad: Nat8;
//     identidad: Principal;
//   };

//   stable var datos: DatosUsuario = ("", 0, Principal.fromText("2vxsx-fae"));
//   stable var datosStruct: Usuario = {nombre=""; edad = 0; identidad = Principal.fromText("2vxsx-fae")};

//   public shared ({caller}) func leerDatosUsuarioStruct (nombre: Text, edad:Nat8): async 
//     ResultadoStruct{
//     if (edad >= 18){
//       let datosUsuario: Usuario = {nombre ; edad; identidad = caller};
//       datosStruct := datosUsuario;
      
//       return #ok(datosStruct);
//     } else {
//       #err("Lo siento no puedes continuar.");
//     };
//   };

//   public shared ({caller}) func leerDatosUsuariotupla (nombre: Text, edad:Nat8): async 
//     ResultadoUsuario{
//     if (edad >= 18){
//       let datosUsuario: DatosUsuario = (nombre, edad, caller);
//       datos :=datosUsuario;
      
//       return #ok(datos);
//     } else {
//       #err("Lo siento no puedes continuar.");
//     };
//   };

//   public query func ontenerDatosUsuario(): async DatosUsuario {
//   return datos ;
//   };

//   public shared query ({caller}) func whoAmI(): async  Principal{

//     return caller;
//   };
//};


//actor Practica {
//   public shared query (msg) func whoAmI() : async Principal {
//     Debug.print(debug_show(msg));
//     return msg.caller;
//   };
// };
//import Text "mo:base/Text";
//import Int "mo:base/Int";
// Nombre:
// Pais: 
// Experiencias:
//import Debug "mo:base/Debug";
//import Nat "mo:base/Nat";
//import Iter "mo:base/Iter";

//actor Nombre {
  //stable var nombre: Text = "";
  //stable var edadUsuario: Nat8 = 0;
  //stable var contador: Int =0;
  //stable var datos: (Text, Nat8) = ("",0);

  //public query func obtenerfalso(): async Bool{
   // let falso: Bool = false;
   // let _caracter: Char ='b';
    //falso
  //};
  
  //public func aumentadorContador (): async Int {
    //contador := contador + 1;
    //contador += 1;
    //return contador;
 // };

//public func decrementarContador(): async Int{
////// contador := contador -1;
////contador -= 1;
////return contador;

//};"


//  public func leerDatosUsuario (nombre: Text, edad:Nat8): async Bool{
 //   if (edad >= 18){
 //     let datosUsuario: (Text, Nat8) = (nombre, edad);
  //    datos :=datosUsuario;
 //     Debug.print("Guardado exitosamente.");
 //     true
  //  } else {
  //    Debug.print("Lo siento, no puedes continuar.");
   //   false
  //  };
  //};


  //public func obtenerSaludos (indice: Nat): async Text{
  //  switch(indice) {
   //   case(0) { 
   //     return "Hola";
   //    };
   //   case(1) { 
   //     return "Adios";
   //   };
   //   case(2){
   //     return "kiubu";
    //  };
    //  case _ {
    //    return ""
    //  };
   // };
  //}; 

 // public func loopContador() {
 //   var cont: Nat8 =0;
  //  loop{
  //    cont +=1;
  //    Debug.print(Nat8.toText(cont));
  //  } while(cont < 11);
  //  for (j in Iter.range(0,10)){
  //    Debug.print(debug_show(j));
   // };
  //};

  //public func obtenerArreglo(indice: Nat): async Text {
  //  let arreglo: [Text] = ["Hola", "Adios","KIUBU"];

  //  let saludo: Text = arreglo[0] # " " # arreglo[2];
  //  Debug.print(saludo);

  //  return arreglo[indice];
  //};
  
  //public query func obtenerContador(): async Int {
    // return contador;
   // return contador
  //};

  //public query func obtenerNombre(): async Text{
  //  return nombre;
  //};

 // public func guardarNombre(name : Text) {
  //  return nombre := name;
  //};
//};
