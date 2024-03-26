--Prueba procedimiento Quitar_oferta()

UPDATE Localidades SET EstadoLocalidad = 'Vendida' WHERE
    UbicacionRecinto = '40.43618570541075, -3.5993493869409128' AND
    NombreGrada = 'Pista Zona Casters' AND
    UbicacionLocalidad = 'Fila 8, Asiento 92';

SELECT * FROM Localidades WHERE 
    UbicacionRecinto = '40.43618570541075, -3.5993493869409128' AND
    NombreGrada = 'Pista Zona Casters' AND
    UbicacionLocalidad = 'Fila 8, Asiento 92';  

SELECT * FROM oferta WHERE
    UbicacionRecinto = '40.43618570541075, -3.5993493869409128' AND
    NombreGrada = 'Pista Zona Casters' AND
    UbicacionLocalidad = 'Fila 8, Asiento 92';

CALL Quitar_oferta();    

SELECT * FROM oferta WHERE
    UbicacionRecinto = '40.43618570541075, -3.5993493869409128' AND
    NombreGrada = 'Pista Zona Casters' AND
    UbicacionLocalidad = 'Fila 8, Asiento 92';


--Prueba procedimiento CompraLocalidad()

SELECT * FROM Localidades WHERE 
    UbicacionRecinto = '40.43618570541075, -3.5993493869409128' AND
    NombreGrada = 'Pista Zona Casters' AND
    UbicacionLocalidad = 'Fila 8, Asiento 92'; 

SELECT * FROM oferta WHERE
    UbicacionRecinto = '40.43618570541075, -3.5993493869409128' AND
    NombreGrada = 'Pista Zona Casters' AND
    UbicacionLocalidad = 'Fila 8, Asiento 92';

SELECT * FROM Cliente WHERE
    DNI = '47823950R';   

SELECT * FROM vendida WHERE 
    DNICliente = '47823950R';             

CALL CompraLocalidad('47823950R', 'Francisco Molina Diaz', '1999-07-26', 'ES3456982307843910207655', '23764593A', 'Infantil', '40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 8, Asiento 92');        

SELECT * FROM Localidades WHERE 
    UbicacionRecinto = '40.43618570541075, -3.5993493869409128' AND
    NombreGrada = 'Pista Zona Casters' AND
    UbicacionLocalidad = 'Fila 8, Asiento 92'; 

SELECT * FROM oferta WHERE
    UbicacionRecinto = '40.43618570541075, -3.5993493869409128' AND
    NombreGrada = 'Pista Zona Casters' AND
    UbicacionLocalidad = 'Fila 8, Asiento 92';    

SELECT * FROM Cliente WHERE
    DNI = '47823950R'; 

SELECT * FROM vendida WHERE 
    DNICliente = '47823950R';  


--Prueba procedimiento EliminarEntradaEvento()

UPDATE Eventos SET EstadoEvento = 'Cerrado' WHERE
    Nombre = 'Velada del Año 3' AND
    Fecha = '2023-07-01';

SELECT * FROM Eventos WHERE 
    Nombre = 'Velada del Año 3' AND
    Fecha = '2023-07-01';

SELECT * FROM oferta WHERE
    UbicacionRecinto = '40.43618570541075, -3.5993493869409128'; 

CALL EliminarEntradaEvento();        

SELECT * FROM oferta WHERE
    UbicacionRecinto = '40.43618570541075, -3.5993493869409128'; 


--Prueba procedimiento Limitar_ventas()
        
SELECT * FROM Localidades WHERE 
    EstadoLocalidad = 'Vendida';

SELECT * FROM oferta WHERE 
    NombreGrada = 'Pista Zona Casters';

UPDATE Gradas SET Max_Localidades = 2 WHERE
    NombreGrada = 'Pista Zona Casters';

SELECT * FROM Gradas WHERE
    NombreGrada = 'Pista Zona Casters';

CALL Limitar_ventas(); 

SELECT * FROM oferta WHERE 
    NombreGrada = 'Pista Zona Casters';

UPDATE Localidades SET EstadoLocalidad = 'Vendida' WHERE
    UbicacionRecinto = '40.43618570541075, -3.5993493869409128' AND
    NombreGrada = 'Pista Zona Casters' AND
    UbicacionLocalidad = 'Fila 8, Asiento 92';

CALL Limitar_ventas(); 

SELECT * FROM oferta WHERE 
    NombreGrada = 'Pista Zona Casters';

SELECT * FROM oferta;


--Prueba procedimiento Limitar_usuarios()

SELECT * FROM vendida WHERE 
    TipoUsuarioAsistente = 'Adulto';

UPDATE tipo SET CantidadUsuario = 2 WHERE
    TipoUsuario = 'Adulto' AND
    NombreEvento = 'Velada del Año 3';    

SELECT * FROM tipo WHERE
    NombreEvento = 'Velada del Año 3';

CALL Limitar_usuarios();    

CALL CompraLocalidad('47823950R', 'Francisco Molina Diaz', '1999-07-26', 'ES3456982307843910207655', '23764593A', 'Adulto', '40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 8, Asiento 92');     

SELECT * FROM vendida WHERE 
    TipoUsuarioAsistente = 'Adulto';

CALL Limitar_usuarios();  

SELECT * FROM oferta;

SELECT COUNT(*) FROM vendida v, pertenece p, Espectaculos e WHERE
            v.TipoUsuarioAsistente = 'Adulto' AND
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