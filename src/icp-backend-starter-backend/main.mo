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
};
 