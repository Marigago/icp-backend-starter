import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Result "mo:base/Result";

actor Crud {
  type Id = Nat;
  type CId =Nat;
  type ResultadoStruct = Result.Result<Part, Text>;
  type Tipo = {#topPart; #downPart};
  type Color = {#color; #blanco; #mezclilla};
  type EstadoLimpieza = {#limpio; #sucio};
  
  type Calificacion =Nat;
  type Cid = {
    cid: CId;
  };
  type NId = {
    id: Id;
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

  type Conjunto = {
    topPart: NId;
    downPart: NId;
  };

  
  //
  type Part = {
    #topPart : {part: TopPart; creator: Principal};
    #downPart : {part: DownPart; creator: Principal};
  };

  // 
  let partsMap = HashMap.HashMap<Id, Part>(0, Nat.equal, Hash.hash);
  let conjuntosMap = HashMap.HashMap<CId, Conjunto>(0, Nat.equal, Hash.hash);
  //let partsTMap = HashMap.HashMap<NId, TopPart>(0, Nat.equal, Hash.hash);
  //let partsDMap = HashMap.HashMap<NId, DownPart>(0, Nat.equal, Hash.hash);
 

  public shared ({caller}) func addPrend(prenda : TopPart) : async Result.Result<(), Text> {
    if (prenda.calificacion >= 0 and prenda.calificacion <= 10) {
      switch (partsMap.get(prenda.id)) {
        case (null) {
          let partData = {id = prenda.id; tipo = prenda.tipo; color= prenda.color; calificacion = prenda.calificacion; limpio = prenda.limpio};
          let part: Part = switch (prenda.tipo) {
            case (#downPart) #downPart({part = partData; creator = caller});
            case (#topPart) #topPart({part = partData; creator = caller});
          };
          partsMap.put(prenda.id, part);
          #ok(())
        };
        case (?_) {
          #err("Ya existe una prenda con este ID")
        };
      };
    } else {
      #err("La calificación debe estar entre 0 y 10")
    };
  };

  public query func leerPrenda(id:NId): async ?Part{
   partsMap.get(id.id);
  };

  public func actualizarLimpieza(id: NId): async Bool {
    switch (partsMap.get(id.id)) {
      case (null) {
        Debug.print("No se encontró el registro.");
        false
      };
      case (?part) {
        let actualizarE = switch (part) {
          case (#topPart(topPart)) {
            let newData = {
                id = topPart.part.id;
                tipo = topPart.part.tipo;
                color = topPart.part.color;
                calificacion = topPart.part.calificacion;
                limpio = if (topPart.part.limpio == #limpio){
                  #sucio ;
                  } else {
                    #limpio;
                  };
              };
            #topPart({
              part = newData;
              creator = topPart.creator;
            })
          };
          case (#downPart(downPart)) {
            let newData2 = {
                id = downPart.part.id;
                tipo = downPart.part.tipo;
                color = downPart.part.color;
                calificacion = downPart.part.calificacion;
                limpio = if (downPart.part.limpio == #limpio){
                  #sucio ;
                  } else {
                    #limpio;
                  };
              };
            #downPart({
              part = newData2;
              creator = downPart.creator;
            })
          };
        };
        partsMap.put(id.id, actualizarE);
        true
      };
    };
  };

  type Calif ={
    id: Id;
    nuevaCalificacion: Calificacion;
  };

  public func actualizarCalif(calif:Calif): async Result.Result<(), Text> {
    if (calif.nuevaCalificacion < 0 or calif.nuevaCalificacion > 10) {
      return #err("La calificación debe estar entre 0 y 10");
    };

    switch (partsMap.get(calif.id)) {
      case (null) {
        Debug.print("No se encontró el registro.");
        #err("No se encontró el registro con el ID proporcionado")
      };
      case (?part) {
        let actualizarC = switch (part) {
          case (#topPart(topPart)) {
            let newData = {
              id = topPart.part.id;
              tipo = topPart.part.tipo;
              color = topPart.part.color;
              calificacion = calif.nuevaCalificacion;
              limpio = topPart.part.limpio;
            };
            #topPart({
              part = newData;
              creator = topPart.creator;
            })
          };
          case (#downPart(downPart)) {
            let newData2 = {
              id = downPart.part.id;
              tipo = downPart.part.tipo;
              color = downPart.part.color;
              calificacion = calif.nuevaCalificacion;
              limpio = downPart.part.limpio;
            };
            #downPart({
              part = newData2;
              creator = downPart.creator;
            })
          };
        };
        partsMap.put(calif.id, actualizarC);
        #ok(())
      };
    };
  };

  type SConjunto = {
    cid : CId;
    topId: NId;
    downId: NId;
  };
  public func crearConjunto(conjunto : SConjunto): async Result.Result<(), Text> { 
    switch (conjuntosMap.get(conjunto.cid)) {
      case (null) {
        switch (partsMap.get(conjunto.topId.id), partsMap.get(conjunto.downId.id)) {
          case (?topPart, ?downPart) {
            switch (topPart, downPart) {
              case (#topPart(_), #downPart(_)) {
                let nuevoConjunto: Conjunto = {
                  topPart = conjunto.topId;
                  downPart = conjunto.downId;
                };
                conjuntosMap.put(conjunto.cid, nuevoConjunto);
                return #ok(());
              };
              case _ {
                return #err("Las partes seleccionadas no son válidas para un conjunto");
              };
            };
          };
          case _ {
            return #err("No se encontraron las partes especificadas");
          };
        };
      };
      case (?_) {
        return #err("Ya existe un conjunto con este ID");
      };
    };
  };

  public query func obtenerConjunto(cids: Cid): async ?Conjunto {
    conjuntosMap.get(cids.cid)
  };


  public query func prendasDispo() : async [Part] {
    Iter.toArray(
      Iter.filter(partsMap.vals(), func (part : Part) : Bool {
        switch part {
          case (#topPart(t)) { t.part.limpio == #limpio };
          case (#downPart(d)) { d.part.limpio == #limpio };
        };
      })
    );
  };

  public query func prendasSucias() : async [(Id, Color)] {
    Iter.toArray(
      Iter.map<Part, (Id, Color)>(
        Iter.filter<Part>(partsMap.vals(), func (part : Part) : Bool {
          switch part {
            case (#topPart(t)) { t.part.limpio == #sucio };
            case (#downPart(d)) { d.part.limpio == #sucio };
          }
        }),
        func (part : Part) : (Id, Color) {
          switch part {
            case (#topPart(t)) { (t.part.id, t.part.color) };
            case (#downPart(d)) { (d.part.id, d.part.color) };
          }
        }
      )
    )
  };
  // public query func leerTPart(id:NId): async ?TopPart{
  //  partsTMap.get(id);
  // };

  // public query func leerDPart(id:NId): async ?DownPart{
  //  partsDMap.get(id);
  // };

  // public shared ({caller}) func addPart(id: Id, tipo: Tipo, color: Color, calificacion: Nat, limpio: EstadoLimpieza) : async Result.Result<(), Text> {
  //   if (calificacion >= 0 and calificacion <= 10) {
  //     let partData = {id; tipo; color; calificacion; limpio};
  //     let part: Part = switch (tipo) {
  //       case (#downPart) #downPart(partData);
  //       case (#topPart) #topPart(partData);
  //     };
  //     partsMap.put(id, part);
  //     #ok(())
  //   } else {
  //     #err("La calificación debe estar entre 0 y 10")
  //   };
  // };

  // public shared ({caller}) func leerDatosPartStruct(id: Nat, tipo: Tipo, color: Color, calificacion: Nat, limpio: EstadoLimpieza): async ResultadoStruct {
  //   if (calificacion >= 0 and calificacion <= 10) {
  //     let partData = {id; tipo; color; calificacion; limpio};
  //     let part: Part = switch (tipo) {
  //       case (#downPart) #downPart(partData);
  //       case (#topPart) #topPart(partData);
  //     };
  //     return #ok(part);
  //   } else {
  //     return #err("La calificación debe estar entre 0 y 10");
  //   };
  // };
  
  // public func addPart(id: Id, tipo: Tipo, color: Color, calificacion: Nat, limpio: EstadoLimpieza) : async () {
  //   let part = switch (tipo) {
  //     case (#topPart) {
  //       #topPart({
  //         id = id;
  //         tipo = tipo;
  //         color = color;
  //         calificacion = calificacion;
  //         limpio = limpio;
  //       });
  //     };
  //     case (#downPart) {
  //       #downPart({
  //         id = id;
  //         tipo = tipo;
  //         color = color;
  //         calificacion = calificacion;
  //         limpio = limpio;
  //       });
  //     };
  //   };
  //   partsMap := Map.set(partsMap, id, part);
  // };
  // Función para agregar una parte
//   public func addPart(id: Id, tipo: Tipo, color: Color, calificacion: Nat, limpio: EstadoLimpieza) : async () {
//     let part = switch (tipo) {
//       case (#topPart) {
//         #topPart({
//           id = id;
//           tipo = tipo;
//           color = color;
//           calificacion = calificacion;
//           limpio = limpio;
//         });
//       };
//       case (#downPart) {
//         #downPart({
//           id = id;
//           tipo = tipo;
//           color = color;
//           calificacion = calificacion;
//           limpio = limpio;
//         });
//       };
//     };
//     partsMap.put(id, part);
//   };
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