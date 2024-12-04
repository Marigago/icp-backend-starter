import Text "mo:base/Text";
// Nombre:
// Pais: 
// Experiencias:

actor Nombre {
  var nombre: Text = "";

  public query func obtenerNombre(): async Text{
    return nombre;
  };

  public func guardarNombre(name : Text) {
    nombre := name;
  };
};
