GENERIC
   -- Tipo de los Elementos:
   TYPE Tipo_Elemento IS PRIVATE;
PACKAGE Colindex IS

   ------------------------------------------------------------------
   -- EFECTO: Paquete de Especificaci�n de tipos y operaciones para 
   --         manejo de colecciones indexadas de tama�o variable en 
   --         Ada. 
   -- AUTOR: Metodolog�a de la Programaci�n
   -- FECHA DE CREACI�N: 01/12/05
   -- ULTIMA MODIFICACI�N: 2/03/06
   ------------------------------------------------------------------

   -----------
   -- Tipos --
   -----------

   -- Tipo para declarar colecciones:
   TYPE Tipo IS PRIVATE;

   -- Tipo para la funci�n 'ColIndex_Cons':
   TYPE Tipo_Elementos IS ARRAY (Positive RANGE <>) OF Tipo_Elemento;

   ----------------------------------------------------------------------
   -- Funciones de manejo de colecciones indexadas de tama�o variable. --
   ----------------------------------------------------------------------

   PROCEDURE Vacia (
         Col :    OUT Tipo ); 
   -- PRE: cierto
   -- POST1: "Crear una colecci�n vac�a en 'Col'."
   -- POST2: Col^out = <>

   FUNCTION Longitud (
         Col : Tipo ) 
     RETURN Natural; 
   -- PRE: cierto
   -- POST: resultado = Longitud (Col)

   FUNCTION Esimo (
         Pos : Positive; 
         Col : Tipo      ) 
     RETURN Tipo_Elemento; 
   -- PRE: Pos <= Longitud (Col)
   -- POST: resultado = Col (Pos)

   PROCEDURE Asignar (
         Pos  : IN     Positive;      
         Elem : IN     Tipo_Elemento; 
         Col  : IN OUT Tipo           ); 
   -- PRE: Pos <= Longitud (Col)
   -- POST: "Actualizar el valor 'Col (Pos)' con 'Elem' "

   PROCEDURE Insertar (
         Pos  : IN     Positive;      
         Elem : IN     Tipo_Elemento; 
         Col  : IN OUT Tipo           ); 
   -- PRE: Pos <= Longitud (Col) + 1
   -- POST: "Insertar en la posici�n 'Pos' de 'Col' el elemento 
   --       'Elem' "

   PROCEDURE Quitar (
         Pos : IN     Positive; 
         Col : IN OUT Tipo      ); 
   -- PRE: Pos <= Longitud (Col)
   -- POST: "Elimina el elemento 'Col (Pos)' "

   ---------------------------------------------------------
   -- Funciones para definir constantes de tipo colecci�n --
   -- indexada de tama�o variable.                        --
   ---------------------------------------------------------

   FUNCTION Vacia RETURN Tipo; 
   -- PRE: cierto
   -- POST: resultado = <>

   FUNCTION Colindex_Cons (
         Elementos : Tipo_Elementos ) 
     RETURN Tipo; 
   --   Pre: Cierto
   --   Post: "Generar una lista formada por 'Elementos'."
   --   Post: Resultado = Elementos

   -----------------
   -- Excepciones --
   -----------------

   Posicion_Fuera_De_Rango_En_Esimo : EXCEPTION;
   Posicion_Fuera_De_Rango_En_Asignar : EXCEPTION;
   Posicion_Fuera_De_Rango_En_Insertar : EXCEPTION;
   Posicion_Fuera_De_Rango_En_Quitar : EXCEPTION;

   --------------------------
   -- Restricciones de Uso --
   --------------------------

   -- - Utilizar la funci�n 'Vacia' s�lo para definir 
   --   constantes de prueba.
   -- - Para copiar una colecci�n en operaciones de construcci�n
   --   de colecciones, no hacerlo NUNCA con la operaci�n de 
   --   asignaci�n ':=' entre variables de este tipo, sino con 
   --   los procedimientos 'Vacia' e 'Insertar'.

   -------------------
   -- Tipos ocultos --
   -------------------

PRIVATE
   TYPE Desc;
   TYPE Tipo IS ACCESS Desc;

END Colindex ;
