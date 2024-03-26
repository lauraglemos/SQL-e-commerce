DROP PROCEDURE IF EXISTS CompraLocalidad;
DROP PROCEDURE IF EXISTS Quitar_oferta;
DROP PROCEDURE IF EXISTS Limitar_ventas;
DROP PROCEDURE IF EXISTS EliminarEntradaEvento;
DROP PROCEDURE IF EXISTS Limitar_usuarios;

CREATE PROCEDURE CompraLocalidad(
    in DNICliente varchar(9),
    in NombreCliente varchar(50),
    in FechaNacimientoCliente date,
    in IBANCliente varchar(24),
    in DNIAsistente varchar(9),
    in TipoUsuarioAsistente ENUM('Jubilado', 'Adulto', 'Infantil', 'Parado'),
    in recinto varchar(50),
    in grada varchar(30),
    in localidad varchar(50)
)
BEGIN   
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        IF EXISTS (SELECT * FROM Localidades WHERE
            EstadoLocalidad = 'Libre' AND
            UbicacionRecinto = recinto AND
            NombreGrada = grada AND 
            UbicacionLocalidad = localidad) THEN

            UPDATE Localidades SET EstadoLocalidad = 'Vendida' WHERE 
                UbicacionRecinto = recinto AND
                NombreGrada = grada AND
                UbicacionLocalidad = localidad;

            IF NOT EXISTS (SELECT * FROM Cliente WHERE 
                DNI = DNICliente AND
                Nombre = NombreCliente AND
                FechaNacimiento = FechaNacimientoCliente AND
                IBAN = IBANCliente)
            THEN   
                INSERT INTO Cliente(DNI, Nombre, FechaNacimiento, IBAN) VALUES
                    (DNICliente, NombreCliente, FechaNacimientoCliente, IBANCliente);
            END IF;

            CALL Quitar_oferta();

            IF NOT EXISTS (
            SELECT UbicacionRecinto, NombreGrada, UbicacionLocalidad FROM vendida WHERE
                UbicacionRecinto = recinto AND 
                NombreGrada = grada AND 
                UbicacionLocalidad = localidad)
            THEN  
            INSERT INTO vendida (DNICliente, TipoUsuarioAsistente, UbicacionRecinto, NombreGrada, UbicacionLocalidad) VALUES
                (DNICliente, TipoUsuarioAsistente, recinto, grada, localidad);
            END IF;
        END IF;    
    COMMIT;
END;


CREATE PROCEDURE Quitar_oferta()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE recinto varchar(50);
    DECLARE grada varchar(30);
    DECLARE localidad varchar(50);    

    DECLARE Localidades_vendida CURSOR FOR
        SELECT UbicacionRecinto, NombreGrada, UbicacionLocalidad
        FROM Localidades
        WHERE EstadoLocalidad = 'Vendida' OR 
              EstadoLocalidad = 'Deteriorada' OR
              EstadoLocalidad = 'Reservada';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    OPEN Localidades_vendida;

    read_loop: LOOP
        FETCH Localidades_vendida INTO recinto, grada, localidad;

        IF done THEN
            LEAVE read_loop;
        END IF;

        IF EXISTS (
        SELECT UbicacionRecinto, NombreGrada, UbicacionLocalidad 
        FROM oferta
        WHERE UbicacionRecinto = recinto AND 
        NombreGrada = grada AND 
        UbicacionLocalidad = localidad)

            THEN 
            DELETE FROM oferta 
            WHERE UbicacionRecinto = recinto AND 
            NombreGrada = grada AND 
            UbicacionLocalidad = localidad;
        END IF;        

    END LOOP read_loop;

    CLOSE Localidades_vendida;

    COMMIT;
END; 


CREATE PROCEDURE Limitar_ventas()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE recinto varchar(50);
    DECLARE grada varchar(30);
    DECLARE vendidas int;
    DECLARE total_loc int;

    DECLARE Cursor_Gradas CURSOR FOR
        SELECT UbicacionRecinto, NombreGrada
        FROM Gradas;   

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    OPEN Cursor_Gradas;

    read_loop: LOOP
        FETCH Cursor_Gradas INTO recinto, grada;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT COUNT(*) INTO vendidas FROM Localidades WHERE
            EstadoLocalidad = 'Vendida' AND
            NombreGrada = grada;

        IF vendidas >= (SELECT Max_Localidades FROM Gradas WHERE  
            NombreGrada = grada) THEN 
            DELETE FROM oferta 
            WHERE UbicacionRecinto = recinto AND 
            NombreGrada = grada;
        END IF;        

    END LOOP read_loop;

    CLOSE Cursor_Gradas;

    COMMIT;
END; 


CREATE PROCEDURE EliminarEntradaEvento()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE recinto varchar(50);
    DECLARE grada varchar(30);
    DECLARE localidad varchar(50); 
    DECLARE evento varchar(50);
    DECLARE fecha date;   

    DECLARE Localidades_disponibles CURSOR FOR
        SELECT UbicacionRecinto, NombreGrada, UbicacionLocalidad, NombreEvento, FechaEvento
        FROM pertenece
        WHERE NombreEvento IN (
            SELECT Nombre FROM Eventos WHERE    
                EstadoEvento = 'Finalizado' OR
                EstadoEvento = 'Cerrado'
        );

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    OPEN Localidades_disponibles;

    read_loop: LOOP
        FETCH Localidades_disponibles INTO recinto, grada, localidad, evento, fecha;

        IF done THEN
            LEAVE read_loop;
        END IF;

        IF EXISTS (
        SELECT UbicacionRecinto, NombreGrada, UbicacionLocalidad, NombreEvento, FechaEvento
        FROM pertenece
        WHERE UbicacionRecinto = recinto AND 
        NombreGrada = grada AND 
        UbicacionLocalidad = localidad AND
        NombreEvento = evento AND
        FechaEvento = fecha)

            THEN 
            DELETE FROM oferta 
            WHERE UbicacionRecinto = recinto AND 
            NombreGrada = grada AND 
            UbicacionLocalidad = localidad;
        END IF;        

    END LOOP read_loop;

    CLOSE Localidades_disponibles;

    COMMIT;
END;  

CREATE PROCEDURE Limitar_usuarios()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE evento varchar(50);
    DECLARE fecha date;
    DECLARE titulo varchar(80);
    DECLARE tipo varchar(40);
    DECLARE año int;
    DECLARE productor varchar(50);
    DECLARE usuario ENUM('Jubilado', 'Adulto', 'Infantil', 'Parado');
    DECLARE cantidad int;
    DECLARE vendidas int;

    DECLARE Cursor_Espectaculos CURSOR FOR
        SELECT NombreEvento, FechaEvento, TituloEspectaculo, TipoEspectaculo, AñoEspectaculo, ProductorEspectaculo, TipoUsuario, CantidadUsuario
        FROM tipo;   

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    OPEN Cursor_Espectaculos;

    read_loop: LOOP
        FETCH Cursor_Espectaculos INTO evento, fecha, titulo, tipo, año, productor, usuario, cantidad;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT COUNT(*) INTO vendidas FROM vendida v, pertenece p, Espectaculos e WHERE
            v.TipoUsuarioAsistente = usuario AND
            p.UbicacionLocalidad = v.UbicacionLocalidad AND
            p.NombreGrada = v.NombreGrada AND
            p.UbicacionRecinto = v.UbicacionRecinto AND
            e.NombreEvento = p.NombreEvento AND
            e.FechaEvento = p.FechaEvento AND
            e.Titulo = p.TituloEspectaculo AND
            e.Tipo = p.TipoEspectaculo AND
            e.Año = p.AñoEspectaculo AND
            e.Productor = p.ProductorEspectaculo AND
            e.NombreEvento = evento AND
            e.FechaEvento = fecha AND
            e.Titulo = titulo AND
            e.Tipo = tipo AND
            e.Año = año AND
            e.Productor = productor;  

        IF vendidas >= cantidad THEN 
            DELETE FROM oferta WHERE
                TipoUsuario = usuario AND
                UbicacionRecinto IN (SELECT DISTINCT p.UbicacionRecinto FROM pertenece p WHERE 
                                        p.NombreEvento = evento AND
                                        p.FechaEvento = fecha AND
                                        p.TituloEspectaculo = titulo AND
                                        p.TipoEspectaculo = tipo AND
                                        p.AñoEspectaculo = año AND
                                        p.ProductorEspectaculo = productor);
        END IF;        

    END LOOP read_loop;

    CLOSE Cursor_Espectaculos;

    COMMIT;
END;