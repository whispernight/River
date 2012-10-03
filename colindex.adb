WITH Unchecked_Deallocation;

PACKAGE BODY Colindex IS

   ------------------------------------------------------------------
   -- EFECTO: Paquete de Implementación de tipos y operaciones para 
   --         manejo de colecciones indexadas en Ada. 
   -- AUTOR: Metodología de la Programación
   -- FECHA DE CREACIÓN: 01/12/05
   -- ULTIMA MODIFICACIÓN: 22/3/06
   ------------------------------------------------------------------

   TYPE Nodo;
   TYPE Tipolista IS ACCESS Nodo;
   TYPE Nodo IS
   RECORD
      Elemento  : Tipo_Elemento;
      Siguiente : Tipolista;
   END RECORD;

   TYPE Desc IS
   RECORD
      Longitud : Natural := 0;
      Lista : Tipolista;
   END RECORD;

   PROCEDURE Dispose IS 
   NEW Unchecked_Deallocation (Nodo,Tipolista);

   FUNCTION Vacia RETURN Tipo IS 
   BEGIN
      RETURN NEW Desc'(0,NULL);
   END Vacia;

   PROCEDURE Vacia (
         Col :    OUT Tipo ) IS 
   BEGIN
      Col := NEW Desc'(0,NULL);
   END Vacia;

   FUNCTION Es_Vacia (
         Col : Tipo ) 
     RETURN Boolean IS 
   BEGIN
      RETURN Col.ALL = (0,NULL);
   END Es_Vacia;

   FUNCTION Longitud (
         Col : Tipo ) 
     RETURN Natural IS 
   BEGIN
      RETURN Col.ALL.Longitud;
   END Longitud;

   FUNCTION Esimo (
         Pos : Positive; 
         Col : Tipo      ) 
     RETURN Tipo_Elemento IS 
      Aux : Tipolista := Col.
      ALL.Lista;
   BEGIN
      IF Pos > Col.ALL.Longitud THEN
         RAISE Posicion_Fuera_De_Rango_En_Esimo;
      ELSE
         FOR I IN 1..Pos-1 LOOP
            Aux := Aux.ALL.Siguiente;
         END LOOP;
         RETURN Aux.ALL.Elemento;
      END IF;
   END Esimo;

   PROCEDURE Asignar (
         Pos  : IN     Positive;      
         Elem : IN     Tipo_Elemento; 
         Col  : IN OUT Tipo           ) IS 
      Aux : Tipolista := Col.
      ALL.Lista;
   BEGIN
      IF Pos > Col.ALL.Longitud THEN
         RAISE Posicion_Fuera_De_Rango_En_Asignar;
      ELSE
         FOR I IN 1..Pos-1 LOOP
            Aux := Aux.ALL.Siguiente;
         END LOOP;
         Aux.ALL.Elemento := Elem;
      END IF;
   END Asignar ;

   PROCEDURE Insertar (
         Pos  : IN     Positive;      
         Elem : IN     Tipo_Elemento; 
         Col  : IN OUT Tipo           ) IS 
      Actual,  
      Anterior : Tipolista := Col.
      ALL.Lista;
      I : Natural := 1;  
   BEGIN
      IF Pos > (Col.ALL.Longitud + 1) THEN
         RAISE Posicion_Fuera_De_Rango_En_Insertar;
      ELSE
         WHILE (Actual /= NULL) AND (I < Pos) LOOP
            Anterior := Actual;
            Actual := Actual.ALL.Siguiente;
            I := I + 1;
         END LOOP;
         IF Anterior = Actual THEN       -- El primero
            Col.ALL.Lista := NEW Nodo'(Elem,Actual);
         ELSE
            Anterior.ALL.Siguiente := NEW Nodo'(Elem,Actual);
         END IF;
         Col.ALL.Longitud := Col.ALL.Longitud + 1;
      END IF;
   END Insertar;

   FUNCTION Copia (
         Col : Tipo ) 
     RETURN Tipo IS 
      Aux,  
      Nuevo : Tipolista := Col.
      ALL.Lista;
      Res : Tipo :=
      NEW Desc'(0,NULL);
   BEGIN
      IF NOT Es_Vacia (Col) THEN
         Res.ALL.Lista := NEW Nodo'(Aux.ALL.Elemento,NULL);
         Nuevo := Res.ALL.Lista;
         WHILE Aux.ALL.Siguiente /= NULL LOOP
            Aux := Aux.ALL.Siguiente;
            Nuevo.ALL.Siguiente := NEW Nodo'(Aux.ALL.Elemento,NULL);
            Nuevo := Nuevo.ALL.Siguiente;
         END LOOP;
      END IF;
      RETURN Res;
   END Copia;

   PROCEDURE Quitar (
         Pos : IN     Positive; 
         Col : IN OUT Tipo      ) IS 
      Actual,  
      Anterior : Tipolista := Col.
      ALL.Lista;
      I : Natural := 1;  
   BEGIN
      IF Pos > Longitud (Col) THEN
         RAISE Posicion_Fuera_De_Rango_En_Quitar;
      ELSE
         WHILE (Actual /= NULL) AND (I < Pos) LOOP
            Anterior := Actual;
            Actual := Actual.ALL.Siguiente;
            I := I + 1;
         END LOOP;
         IF Anterior /= NULL THEN
            IF Actual = Col.ALL.Lista THEN
               Col.ALL.Lista := Actual.ALL.Siguiente;
            ELSE
               Anterior.ALL.Siguiente := Actual.ALL.Siguiente;
            END IF;
            Col.ALL.Longitud := Col.ALL.Longitud - 1;
            Dispose (Actual);
         END IF;
      END IF;
   END Quitar;

   PROCEDURE Insertarfinal (
         E : IN     Tipo_Elemento; 
         L : IN OUT Tipolista      ) IS 
      Aux   : Tipolista := L;  
      Nuevo : Tipolista :=
      NEW Nodo'(E,NULL);
   BEGIN
      IF L = NULL THEN
         L := Nuevo;
      ELSE
         WHILE Aux.Siguiente /= NULL LOOP
            Aux := Aux.Siguiente;
         END LOOP;
         Aux.Siguiente := Nuevo;
      END IF;
   END Insertarfinal;

   FUNCTION Colindex_Cons (
         Elementos : Tipo_Elementos ) 
     RETURN Tipo IS 
      Res : Tipo := Vacia;  
   BEGIN
      FOR I IN Elementos'RANGE LOOP
         Insertarfinal (Elementos (I),Res.ALL.Lista);
         Res.ALL.Longitud := Res.ALL.Longitud + 1;
      END LOOP;
      RETURN Res;
   END Colindex_Cons;

END Colindex ;
