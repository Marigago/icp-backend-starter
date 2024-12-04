import Text "mo:base/Text";
import Int "mo:base/Int";
// Nombre:
// Pais: 
// Experiencias:

actor Nombre {
  //stable var nombre: Text = "";
  //stable var edadUsuario: Nat8 = 0;
  stable var contador: Int =0;
  stable var datos: (Text, Nat8) = ("",0);

  public query func obtenerfalso(): async Bool{
    let falso: Bool = false;
    let _caracter: Char ='b';
    falso
  };
  
  public func aumentadorContador (): async Int {
    //contador := contador + 1;
    contador += 1;
    return contador;
  };

  public func decrementarContador(): async Int{
    // contador := contador -1;
    contador -= 1;
    return contador;

  };


  public func leerDatosUsuario (nombre: Text, edad:Nat8): async (Text, Nat8){
    let datosUsuario: (Text,Nat8) = (nombre, edad);

    datos := datosUsuario;

    datos
  };

  public func obtenerArreglo(indice: Nat): async Text {
    let arreglo: [Text] = ["Hola", "Adios","KIUBU"];
    return arreglo[indice];
  };
  
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
};
