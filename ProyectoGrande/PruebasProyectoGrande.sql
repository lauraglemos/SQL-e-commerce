--Prueba procedimiento Quitar_oferta()

SELECT * FROM Localidades; 

SELECT * FROM oferta WHERE
    UbicacionRecinto = '-0.4165288, 31.3998995' AND
    NombreGrada = 'Palcos' AND
    UbicacionLocalidad = 'Fila 34, Asiento 11';

SELECT * FROM oferta WHERE
    UbicacionRecinto = '-0.45964, 100.590599' AND
    NombreGrada = 'Anfiteatro' AND
    UbicacionLocalidad = 'Fila 53, Asiento 40'; 

SELECT * FROM oferta WHERE
    UbicacionRecinto = '-0.789275, 113.921327' AND
    NombreGrada = 'Zona Preferente' AND
    UbicacionLocalidad = 'Fila 57, Asiento 51';          

CALL Quitar_oferta();    

SELECT * FROM oferta WHERE
    UbicacionRecinto = '-0.4165288, 31.3998995' AND
    NombreGrada = 'Palcos' AND
    UbicacionLocalidad = 'Fila 34, Asiento 11';

SELECT * FROM oferta WHERE
    UbicacionRecinto = '-0.45964, 100.590599' AND
    NombreGrada = 'Anfiteatro' AND
    UbicacionLocalidad = 'Fila 53, Asiento 40'; 

SELECT * FROM oferta WHERE
    UbicacionRecinto = '-0.789275, 113.921327' AND
    NombreGrada = 'Zona Preferente' AND
    UbicacionLocalidad = 'Fila 57, Asiento 51';     

SELECT * FROM oferta;

--Prueba procedimiento CompraLocalidad()

SELECT * FROM Localidades WHERE 
    UbicacionRecinto = '-10.0017, 124.4251' AND
    NombreGrada = 'Gran Tertulia' AND
    UbicacionLocalidad = 'Fila 53, Asiento 15'; 

SELECT * FROM oferta WHERE
    UbicacionRecinto = '-10.0017, 124.4251' AND
    NombreGrada = 'Gran Tertulia' AND
    UbicacionLocalidad = 'Fila 53, Asiento 15'; 

SELECT * FROM Cliente WHERE
    DNI = '47823950R';   

SELECT * FROM vendida WHERE 
    DNICliente = '47823950R';             

CALL CompraLocalidad('47823950R', 'Francisco Molina Diaz', '1999-07-26', 'ES3456982307843910207655', '23764593A', 'Infantil', '-10.0017, 124.4251', 'Gran Tertulia', 'Fila 53, Asiento 15');        

SELECT * FROM Localidades WHERE 
    UbicacionRecinto = '-10.0017, 124.4251' AND
    NombreGrada = 'Gran Tertulia' AND
    UbicacionLocalidad = 'Fila 53, Asiento 15'; 

SELECT * FROM oferta WHERE
    UbicacionRecinto = '-10.0017, 124.4251' AND
    NombreGrada = 'Gran Tertulia' AND
    UbicacionLocalidad = 'Fila 53, Asiento 15';     

SELECT * FROM Cliente WHERE
    DNI = '47823950R'; 

SELECT * FROM vendida WHERE 
    DNICliente = '47823950R';  


--Prueba procedimiento EliminarEntradaEvento()

SELECT * FROM Eventos WHERE 
    Nombre = 'Boombastic Festival' AND
    Fecha = '2023-07-21';

SELECT * FROM ocurre WHERE
    NombreEvento = 'Boombastic Festival' AND
    FechaEvento = '2023-07-21';     

SELECT * FROM oferta WHERE
    UbicacionRecinto = '43.438429878398765, -5.830045432782776'; 

SELECT * FROM Eventos WHERE 
    Nombre = 'Carrera de Autos' AND
    Fecha = '2023-04-14';

SELECT * FROM ocurre WHERE
    NombreEvento = 'Carrera de Autos' AND
    FechaEvento = '2023-04-14';  

SELECT * FROM oferta WHERE
    UbicacionRecinto = '32.654079, -5.9213829';    
      
CALL EliminarEntradaEvento();        

SELECT * FROM oferta WHERE
    UbicacionRecinto = '43.438429878398765, -5.830045432782776'; 

SELECT * FROM oferta WHERE
    UbicacionRecinto = '32.654079, -5.9213829';  

--Prueba procedimiento Limitar_ventas()
--Actualizar Datos

SELECT * FROM oferta WHERE 
    UbicacionRecinto = '-14.06355, 32.4382307' AND
    NombreGrada = 'Terraza';

        
SELECT * FROM Localidades WHERE 
    EstadoLocalidad = 'Vendida' AND
    UbicacionRecinto = '-14.06355, 32.4382307' AND
    NombreGrada = 'Terraza';  

SELECT * FROM oferta WHERE 
    UbicacionRecinto = '-14.06355, 32.4382307' AND
    NombreGrada = 'Terraza';

CALL Limitar_ventas();  

SELECT * FROM oferta WHERE 
    UbicacionRecinto = '-14.06355, 32.4382307' AND
    NombreGrada = 'Terraza';

UPDATE Gradas SET Max_Localidades = 1 WHERE
    UbicacionRecinto = '-14.06355, 32.4382307' AND
    NombreGrada = 'Terraza';

SELECT * FROM Gradas WHERE
    UbicacionRecinto = '-14.06355, 32.4382307' AND
    NombreGrada = 'Terraza';

CALL Limitar_ventas(); 

SELECT * FROM oferta WHERE 
    UbicacionRecinto = '-14.06355, 32.4382307' AND
    NombreGrada = 'Terraza';

SELECT * FROM oferta WHERE
    NombreGrada = 'Terraza';


--Prueba procedimiento Limitar_usuarios()
--Actualizar Datos

SELECT COUNT(*) FROM vendida v, pertenece p, Espectaculos e WHERE
            v.TipoUsuario = 'Adulto' AND
            p.UbicacionLocalidad = v.UbicacionLocalidad AND
            p.NombreGrada = v.NombreGrada AND
            p.UbicacionRecinto = v.UbicacionRecinto AND
            e.NombreEvento = p.NombreEvento AND
            e.FechaEvento = p.FechaEvento AND
            e.Titulo = p.TituloEspectaculo AND
            e.Tipo = p.TipoEspectaculo AND
            e.Año = p.AñoEspectaculo AND
            e.Productor = p.ProductorEspectaculo AND
            e.NombreEvento = 'Velada del Año 3' AND
            e.FechaEvento = '2023-07-01' AND
            e.Titulo = 'Viruzz vs Shelao' AND
            e.Tipo = 'Deportivo' AND
            e.Año = 2023 AND
            e.Productor = 'Ibai';  

SELECT * FROM tipo WHERE
    NombreEvento = 'Velada del Año 3' AND
    TituloEspectaculo = 'Viruzz vs Shelao';

CALL Limitar_usuarios();    

UPDATE tipo SET CantidadUsuario = 1 WHERE
    TipoUsuario = 'Adulto' AND
    NombreEvento = 'Velada del Año 3' AND
    TituloEspectaculo = 'Viruzz vs Shelao';  

SELECT * FROM tipo WHERE
    NombreEvento = 'Velada del Año 3' AND
    TituloEspectaculo = 'Viruzz vs Shelao';

SELECT e.Titulo, o.UbicacionRecinto, o.NombreGrada, o.UbicacionLocalidad, o.TipoUsuario, o.Precio FROM 
    oferta o, pertenece p, Espectaculos e WHERE
        o.UbicacionRecinto = p.UbicacionRecinto AND
        o.NombreGrada = p.NombreGrada AND
        o.UbicacionLocalidad = p.UbicacionLocalidad AND
        p.NombreEvento = e.NombreEvento AND
        p.FechaEvento = e.FechaEvento AND
        p.TituloEspectaculo = e.Titulo AND
        p.TipoEspectaculo = e.Tipo AND
        p.AñoEspectaculo = e.Año AND
        p.ProductorEspectaculo = e.Productor AND
        e.NombreEvento = 'Velada del Año 3' AND
        e.FechaEvento = '2023-07-01' AND
        e.Titulo = 'Viruzz vs Shelao' AND
        e.Tipo = 'Deportivo' AND
        e.Año = 2023 AND
        e.Productor = 'Ibai';    

CALL Limitar_usuarios();  

SELECT e.Titulo, o.UbicacionRecinto, o.NombreGrada, o.UbicacionLocalidad, o.TipoUsuario, o.Precio FROM 
    oferta o, pertenece p, Espectaculos e WHERE
        o.UbicacionRecinto = p.UbicacionRecinto AND
        o.NombreGrada = p.NombreGrada AND
        o.UbicacionLocalidad = p.UbicacionLocalidad AND
        p.NombreEvento = e.NombreEvento AND
        p.FechaEvento = e.FechaEvento AND
        p.TituloEspectaculo = e.Titulo AND
        p.TipoEspectaculo = e.Tipo AND
        p.AñoEspectaculo = e.Año AND
        p.ProductorEspectaculo = e.Productor AND
        e.NombreEvento = 'Velada del Año 3' AND
        e.FechaEvento = '2023-07-01' AND
        e.Titulo = 'Viruzz vs Shelao' AND
        e.Tipo = 'Deportivo' AND
        e.Año = 2023 AND
        e.Productor = 'Ibai';