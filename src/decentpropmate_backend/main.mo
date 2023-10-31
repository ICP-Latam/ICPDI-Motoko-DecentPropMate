import Text "mo:base/Text";
import RBTree "mo:base/RBTree";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";


actor {
  //Lo primero es obtener la pregunta para nuestro poll
  var question: Text = "En qué proyecto prefieres que la junta directiva del edificio invierta el próximo año?";

  //Para que nuestros tenants se puedan registrar, necesitamos guardar la informacion de los tenants creando un type Tenant
  public type Tenant = {
    fullName: Text;
    aptNumber: Nat;
    numPeople: Nat;
    hasPets: Bool;
  };

  //Para pedir serviciso necesitamos guardar esta informacion creando un type serviceRequest
  public type serviceRequest = {
    tenantName: Text;
    aptNumber: Nat;
    serviceType: Text;
    cost: Nat; //puede ser ICP o un token propio, la idea es crear la funcionalidad de pagos directos
  };

  //Este es al array o lista para guardar los resultados de la votacion
  var votes: RBTree.RBTree<Text, Nat> = RBTree.RBTree(Text.compare);


  //Este metodo nos muestra la pregunta que estamos resolviendo
  public query func getQuestion (): async Text {
    question
  };


  //Ahora necesitamos un metodo para ver los votos recividos
    public query func getVotes(): async [(Text, Nat)] {
      Iter.toArray(votes.entries())
    }; 


  //Ahora necesitamos un update query para recibir los votos
  public func vote(entry: Text) : async [(Text, Nat)] {
    
    //neceistamos verificar si la opcion ya recibio votos
    let votes_for_entry :?Nat = votes.get(entry);
    //ahora necesitamos saber que hacer cuando la respuesta es null or si tiene un numero
    let current_votes_for_entry : Nat = switch votes_for_entry {
      case null 0;
      case (?Nat) Nat;
    };
    
    //Una vez los votos son recibidos hay que entrarlos
    votes.put(entry, current_votes_for_entry + 1);
    //Ahora queremos ver el resultado que es como una diccionario o lista
    Iter.toArray(votes.entries())
  };

  //Por ultimo este metodo regresa todo a su estado original
    public func resetVotes() : async [(Text, Nat)] {

      votes.put("Modernizar los elevadores", 0);
      votes.put("Ampliar el gimnasio", 0);
      votes.put("Comprar nuevas camaras", 0);
      votes.put("Construir play room", 0);
      Iter.toArray(votes.entries())
    };

    //Ahora creamos una funcion para que los inquilinos se puedan registrar

    let tenants = Buffer.Buffer<Tenant>(0);

    public func registerTenant(newTenant: Tenant): async () {
      tenants.add(newTenant);
    };

    public func getTenants() : async [Tenant] {
      return Buffer.toArray<Tenant>(tenants);
    };

    //Ahora creamos una funcion para que los inquilinos puedan hacer pedir servicios y despues ver que pidieron

    let serviceRequests = Buffer.Buffer<serviceRequest>(5);

   // public func addServiceRequests(newRequest: serviceRequest): async () {
   //   serviceRequests.add(newRequest);
    //};

    public func getServiceRequets(): async [serviceRequest] {
      return Buffer.toArray<serviceRequest>(serviceRequests);
    };
    //daremos la oportunidad al inquilino de pedir mas de un servicio y ver su costo total
    
    public func calculateTotalCost(requests: [serviceRequest]) : async Nat {
        var totalCost: Nat = 0;
        for (req in requests.vals()) {
            totalCost := totalCost + req.cost;
            serviceRequests.add(req);
        };
        return totalCost;
    };

    public func getTotalCosts(): async Nat {
      let servicesArray = Buffer.toArray<serviceRequest>(serviceRequests);
      var totalCost: Nat = 0;
      for (service in servicesArray.vals()) {
        totalCost := totalCost + service.cost;
      };
      return totalCost;
    };





};
