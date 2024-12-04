import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Result "mo:base/Result";

actor Practica {
  type DatosUsuario = (Text, Nat8, Principal);
  type ResultadoUsuario = Result.Result<DatosUsuario, Text>;
  type ResultadoStruct =Result.Result<Usuario,Text>;
// structs
  type Usuario = {
    nombre: Text;
    edad: Nat8;
    identidad: Principal;
  };

  stable var datos: DatosUsuario = ("", 0, Principal.fromText("2vxsx-fae"));
  stable var datosStruct: Usuario = {nombre=""; edad = 0; identidad = Principal.fromText("2vxsx-fae")};

  public shared ({caller}) func leerDatosUsuarioStruct (nombre: Text, edad:Nat8): async 
    ResultadoStruct{
    if (edad >= 18){
      let datosUsuario: Usuario = {nombre ; edad; identidad = caller};
      datosStruct := datosUsuario;
      
      return #ok(datosStruct);
    } else {
      #err("Lo siento no puedes continuar.");
    };
  };

  public shared ({caller}) func leerDatosUsuariotupla (nombre: Text, edad:Nat8): async 
    ResultadoUsuario{
    if (edad >= 18){
      let datosUsuario: DatosUsuario = (nombre, edad, caller);
      datos :=datosUsuario;
      
      return #ok(datos);
    } else {
      #err("Lo siento no puedes continuar.");
    };
  };

  public query func ontenerDatosUsuario(): async DatosUsuario {
  return datos ;
  };

  public shared query ({caller}) func whoAmI(): async  Principal{

    return caller;
  };
};


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
