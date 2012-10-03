with colindex;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
procedure Prac22 is

--ALUMNO:Ángel Alférez Aroca
--GRUPO:11M ; MATRICULA:m050007
   Maxmeses:constant Natural :=12;
   subtype Tipoindicemeses is Natural range 1..Maxmeses;
  package Colnombre is new Colindex(Character);
   use Colnombre;
   subtype listanombre is colnombre.tipo;
     
   type tupla3 is record
      nombre:listanombre;
      mes:tipoindicemeses;
      precip:natural;
   end record;   

   package lalala is new colindex(tupla3);
   use lalala;
   subtype listatupla3 is lalala.tipo;
   
  
  
   
   type TuplaAfluente is record
      Nombre:listaNombre;
      Precipitaciones:Natural;
   end record; 
  
   package Listatuplas is new Colindex (Tuplaafluente);
   use Listatuplas;
   subtype listaafluentes is Listatuplas.tipo; 
  
   type tupla_mes_prec is record
      mes:tipoindicemeses;
      precip:Natural;
      end record;
  
   package mesyprecip is new Colindex (Tupla_mes_prec);
   use mesyprecip;
   subtype mes_precip is mesyprecip.tipo;


   procedure procesarnombre(Fich:in file_type;nombre:in out listanombre)IS
    --pre:EsCorrecto(fich)  
   Char:Character;
   indice:positive:=1;   
   begin
    nombre:=vacia;
       get(fich,Char);
         while not (Char=' ')and not end_of_line(fich) loop
           insertar(indice,char,nombre);
            indice:=indice +1;
           Get(Fich,Char);
      
      end loop; 
   end Procesarnombre;
   


   procedure Procesarpre(Fich:in File_Type;pre:out natural)is
      
      n:natural;
  
   begin
      pre:=0;
      while not End_Of_Line(Fich) loop
         Get(Fich,N);
         pre:=pre+N;
      end loop;
   end Procesarpre;
   

   procedure Procesarlinea(Fich:in File_Type;tupla:out tuplaafluente;mes:out natural)is
    
    
   begin
    
   while not(end_of_line(fich))LOOP
      Procesarnombre(Fich,Tupla.Nombre);
      --get(fich,char);--cojo blanco;
      Get(Fich,mes);
      --get(fich,char);--cojo blanco;
      Procesarpre(Fich,Tupla.Precipitaciones);
      end loop;
      end procesarlinea;
      
            
     PROCEDURE escribirlinea(fichero:in out file_type;tupla:in out Tupla_mes_prec)is
   
    BEGIN
      if tupla.mes<10 then
       Put(fichero,tupla.mes,0);
       Put(fichero," ");--Pongo blanco;
       Put(fichero," ");--Pongo blanco;
      else
       Put(fichero,tupla.mes,0);
       Put(fichero," ");--Pongo blanco;
     end if;
       Put(fichero,tupla.precip,0);
       new_line(fichero);
      end escribirlinea;
     
      PROCEDURE procesarfichero(fichero:in file_type;colaflu:out listaafluentes;colmeses:out mes_Precip;lista:out listatupla3)is
     indice:positive:=1;
     tupla:tuplaafluente;
     mes:tipoindicemeses;
     begin
      colaflu:=vacia;
      colmeses:=vacia;

      while not end_of_file(fichero) loop
         procesarlinea(fichero,tupla,mes);
         insertar(indice,tupla,colaflu);
         insertar(indice,(mes,tupla.precipitaciones),colmeses);
         insertar(indice,(tupla.nombre,mes,tupla.precipitaciones),lista);
         skip_line(fichero);
         indice:=indice+1;
         end loop;
      end procesarfichero;
      
      FUNCTION coincidenombre(nombre1:listanombre;nombre2:listanombre)return boolean is
      coincide:boolean:=false;
      long1:natural:=longitud(nombre1);
      long2:natural:=longitud(nombre2);
      BEGIN
      if long1/=long2 then
       coincide:=false;
      else
       FOR indice IN 1..long1 LOOP
        if esimo(indice,nombre1)=esimo(indice,nombre2) then
         coincide:=true;
        end if;
       end loop;
      end if;
      return coincide;
     end coincidenombre;

FUNCTION estatupla3(mes:tipoindicemeses;lista:listatupla3)return boolean is
esta:boolean:=FALSE;
      indice:positive:=1;
      long:natural:=longitud(lista);
      BEGIN
        if long=0 then
         esta:=false;
       else

         WHILE not(esta) and indice<=long LOOP
         if mes=esimo(indice,lista).mes then
            esta:=true;
         else
            indice:=indice+1;
         end if;
        end loop;
       end if;   
       Return esta;
     
end estatupla3;

PROCEDURE insertarsiguientetupla3(tupla:in tupla3;lista:in out listatupla3)is
      long:natural:=longitud(lista);
         begin
      
         insertar(long+1,tupla,lista);
      end insertarsiguientetupla3;



     
     PROCEDURE actualizartuplas3(lista:in listatupla3;listares:in out listatupla3)is

      precip:natural:=0;
      nombre:listanombre:=vacia;
      mes:natural;
      indice2:natural:=0;
      long:natural:=longitud(lista);
      begin
    if long=0 then
         listares:=vacia;
    else
      listares:=vacia;
      FOR indice IN 1..long LOOP
      precip:=esimo(indice,lista).precip;
      nombre:=esimo(indice,lista).nombre;
      mes:=esimo(indice,lista).mes;
       indice2:=indice+1;  
         WHILE indice2<=long LOOP
            if  coincidenombre(nombre,esimo(indice2,lista).nombre)then
              precip:=precip+esimo(indice2,lista).precip;
            end if;
           indice2:=indice2+1;
            
         end loop;
         
          insertarsiguientetupla3((nombre,mes,precip),listares); 
          
      end loop;
    end if;

end actualizartuplas3;

  

 






      PROCEDURE escribirfichero(fichero:in out file_type;lista:in out mes_precip)is
        long:natural:=longitud(lista);
        tupla:Tupla_mes_prec;
             
         BEGIN
        FOR indice IN 1..long LOOP
         tupla:=esimo(indice,lista);
         ---------------------------------------------------------------------
          escribirlinea(fichero,tupla);
         
         end loop;
         end escribirfichero;
         

      
      FUNCTION esta(mes:tipoindicemeses;lista:mes_precip)return boolean is
      esta:boolean:=FALSE;
      indice:positive:=1;
      long:natural:=longitud(lista);
      BEGIN
        if long=0 then
         esta:=false;
       else

         WHILE not(esta) and indice<=long LOOP
         if mes=esimo(indice,lista).mes then
            esta:=true;
         else
            indice:=indice+1;
         end if;
        end loop;
       end if;   
       Return esta;
     end esta;
 
      PROCEDURE insertarsiguiente(tupla:in tupla_mes_prec;lista:in out mes_precip)is
      long:natural:=longitud(lista);
         begin
      
         insertar(long+1,tupla,lista);
      end insertarsiguiente;



      PROCEDURE actualizar_mes_precip (lista:in mes_precip;listares:out mes_precip)is
     precip:natural:=0;
      mes:natural;
      indice2:natural:=0;
      long:natural:=longitud(lista);
      begin
    if long=0 then
         listares:=vacia;
    else
      listares:=vacia;
      FOR indice IN 1..long LOOP
      precip:=esimo(indice,lista).precip;
      mes:=esimo(indice,lista).mes;
       indice2:=indice+1;  
         WHILE indice2<=long LOOP
            if mes=esimo(indice2,lista).mes then
              precip:=precip+esimo(indice2,lista).precip;
            end if;
           indice2:=indice2+1;
            
         end loop;
         if not(esta(mes,listares)) then
          insertarsiguiente((mes,precip),listares); 
          end if;
      end loop;
    end if;
    end actualizar_mes_precip;
    
    
    PROCEDURE completar_lista(lista:in out mes_precip)is
    precip_ini:natural:=0;
    Tupla:Tupla_Mes_Prec;
    BEGIN
      FOR mes in 1..12 LOOP
         if not(esta(mes,lista)) then
         tupla:=(mes,precip_ini);
         insertarsiguiente(tupla,lista);
         end if;
        end loop;
     end completar_lista;

    PROCEDURE Burbuja(lista:in out mes_precip)is
      elem:Tupla_mes_prec;
      elem2:Tupla_mes_prec;
      long:natural:=longitud(lista);
      BEGIN
      FOR indice in 1..long LOOP
         FOR indice2 in reverse 1..long-1 Loop
            elem:=esimo(indice2,lista);
            elem2:=esimo(indice2+1,lista);
            if elem.precip<elem2.precip then
               asignar(indice2,elem2,lista);
               asignar(indice2+1,elem,lista);
             end if;
         end loop;
      end loop;
      end burbuja;
         
    PROCEDURE mayor_aflu (lista:in listatupla3;tupla:in out tupla3)is
      long:natural:=longitud(lista);   

    BEGIN
     tupla:=esimo(1,lista);
      FOR indice in 2..long loop
       if tupla.precip<esimo(indice,lista).precip then
        tupla:=esimo(indice,lista);
       end if;
      end loop;
    end mayor_aflu;
    
    PROCEDURE escribir_nombre(fichero:in out file_type;nombre:in listanombre)is
    long:natural:=longitud(nombre);
      BEGIN
    FOR indice in 1..long LOOP
       Put(fichero,esimo(indice,nombre));
      end loop;
     end escribir_nombre;


   PROCEDURE escribir_mayor (fichero:in out file_type;tupla:in tupla3)is
    BEGIN
    escribir_nombre(fichero,tupla.nombre);
    Put(fichero," ");--ESPACIO EN BLANCO--
    Put(fichero,tupla.precip,0);
    end escribir_mayor;
    






     lista2:listatupla3:=vacia;  
     lista:listatupla3:=vacia;    
     colaflu:listaafluentes:=vacia;
     coleccion:mes_precip:=vacia;
     coleccion2:mes_precip:=vacia;
     tupla:tupla3;
     fich:file_type; 
  BEGIN
  open(fich,in_file,"rio1.dat");
  procesarfichero(fich,colaflu,coleccion,lista);
  close(fich);
  actualizar_mes_precip(coleccion,coleccion2);
  burbuja(coleccion2);
  actualizartuplas3(lista,lista2);
  mayor_aflu(lista2,tupla);
  create(fich,out_file,"rio1.res");
  completar_lista(coleccion2);
  escribirfichero(fich,coleccion2);
  escribir_mayor(fich,tupla);
  close(fich);
  
  
  lista2:=vacia;  
  lista:=vacia;    
  colaflu:=vacia;
  coleccion:=vacia;
  coleccion2:=vacia;
     
  
  
  open(fich,in_file,"rio2.dat");
  procesarfichero(fich,colaflu,coleccion,lista);
  close(fich);
  actualizar_mes_precip(coleccion,coleccion2);
  burbuja(coleccion2);
  actualizartuplas3(lista,lista2);
  mayor_aflu(lista2,tupla);
  create(fich,out_file,"rio2.res");
  completar_lista(coleccion2);
  escribirfichero(fich,coleccion2);
  escribir_mayor(fich,tupla);
  close(fich);

end prac22;
  