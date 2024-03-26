DROP TABLE IF EXISTS ocurre;
DROP TABLE IF EXISTS vendida;
DROP TABLE IF EXISTS oferta;
DROP TABLE IF EXISTS tipo;
DROP TABLE IF EXISTS pertenece;
DROP TABLE IF EXISTS Usuarios;
DROP TABLE IF EXISTS Localidades;
DROP TABLE IF EXISTS Gradas;
DROP TABLE IF EXISTS Recintos;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Espectaculos;
DROP TABLE IF EXISTS Eventos;

CREATE TABLE Eventos (
	Nombre varchar(50) NOT NULL,
    Fecha date NOT NULL,
    EstadoEvento ENUM('Finalizado', 'Abierto', 'Cerrado') NOT NULL,
    Localidad varchar(50) NOT NULL,
    TiempoValidez int NOT NULL,
    PRIMARY KEY (Nombre, Fecha)
);

INSERT INTO Eventos (Nombre, Fecha, EstadoEvento, Localidad, TiempoValidez) VALUES
    ('Velada del Año 3', '2023-07-01', 'Abierto', 'Madrid', 10),
    ('Boombastic Festival', '2023-07-21', 'Abierto', 'Asturias', 15);      
    
CREATE TABLE Espectaculos (
	NombreEvento varchar(50) NOT NULL,
    FechaEvento date NOT NULL,
    Titulo varchar(80) NOT NULL,
    Tipo varchar(40) NOT NULL,
    Año int NOT NULL,
    Productor varchar(50) NOT NULL,
    Descripcion varchar(200) NOT NULL,
    PRIMARY KEY (NombreEvento, FechaEvento, Titulo, Tipo, Año, Productor),
    CONSTRAINT fk_realiza FOREIGN KEY (NombreEvento, FechaEvento) REFERENCES Eventos(Nombre, Fecha)
); 

INSERT INTO Espectaculos (NombreEvento, FechaEvento, Titulo, Tipo, Año, Productor, Descripcion) VALUES
    ('Velada del Año 3', '2023-07-01', 'Viruzz vs Shelao', 'Deportivo', 2023, 'Ibai', 'Combate de boxeo amateur entre creadores de contenido.'),
    ('Velada del Año 3', '2023-07-01', 'Concierto Quevedo', 'Musical', 2023, 'Ibai', 'Concierto del cantante canario Quevedo.'),
    ('Boombastic Festival', '2023-07-21', 'Concierto Quevedo', 'Musical', 2023, 'Boombastic', 'Concierto del cantante canario Quevedo');     

CREATE TABLE Recintos (
	Ubicacion varchar(50) NOT NULL,
    PRIMARY KEY (Ubicacion)
);

INSERT INTO Recintos (Ubicacion) VALUES
    ('40.43618570541075, -3.5993493869409128'),
    ('43.438429878398765, -5.830045432782776');   
    
CREATE TABLE Gradas (
	UbicacionRecinto varchar(50) NOT NULL,
    NombreGrada varchar(30) NOT NULL,
    Max_Localidades int NOT NULL,
    PRIMARY KEY (UbicacionRecinto, NombreGrada),
    CONSTRAINT fk_divide FOREIGN KEY (UbicacionRecinto) REFERENCES Recintos(Ubicacion)
); 

INSERT INTO Gradas (UbicacionRecinto, NombreGrada, Max_Localidades) VALUES
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 3000),
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Artistas', 2000),
    ('40.43618570541075, -3.5993493869409128', 'Grada Precio 8', 15000),
    ('43.438429878398765, -5.830045432782776', 'Abono General', 40000),
    ('43.438429878398765, -5.830045432782776', 'Abono VIP', 5000);
  
CREATE TABLE Localidades (
    UbicacionRecinto varchar(50) NOT NULL,
    NombreGrada varchar(30) NOT NULL,
	UbicacionLocalidad varchar(50) NOT NULL,
    EstadoLocalidad ENUM('Vendida', 'Reservada', 'Deteriorada', 'Libre') NOT NULL,
    PRIMARY KEY (UbicacionRecinto, NombreGrada, UbicacionLocalidad),
    CONSTRAINT fk_tiene FOREIGN KEY (UbicacionRecinto, NombreGrada) REFERENCES Gradas(UbicacionRecinto, NombreGrada)
);

INSERT INTO Localidades (UbicacionRecinto, NombreGrada, UbicacionLocalidad, EstadoLocalidad) VALUES
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 8, Asiento 92', 'Vendida'),
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 3, Asiento 40', 'Vendida'),
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Artistas', 'Fila 8, Asiento 92', 'Deteriorada'),
    ('40.43618570541075, -3.5993493869409128', 'Grada Precio 8', 'Fila 8, Asiento 92', 'Reservada'),
    ('43.438429878398765, -5.830045432782776', 'Abono General', 'Zona Genérica', 'Libre'),
    ('43.438429878398765, -5.830045432782776', 'Abono VIP', 'Zona Genérica y Espacios VIP', 'Vendida');   
    
CREATE TABLE Usuarios (
	Tipo ENUM('Jubilado', 'Adulto', 'Infantil', 'Parado') NOT NULL,
    PRIMARY KEY (Tipo)
);

INSERT INTO Usuarios (Tipo) VALUES
    ('Jubilado'),
    ('Adulto'),
    ('Infantil'),
    ('Parado');  
    
CREATE TABLE Cliente (
	DNI varchar(9) NOT NULL,
    Nombre varchar(50) NOT NULL,
    FechaNacimiento date NOT NULL,
    IBAN varchar(24) NOT NULL,
    PRIMARY KEY (DNI)
);

INSERT INTO Cliente (DNI, Nombre, FechaNacimiento, IBAN) VALUES
    ('35762832V', 'Pedro Gonzalez Fernandez', '2002-08-27', 'ES5434892398997423657612'),
    ('78659312H', 'Miguel Perez Fraga', '1987-01-02', 'ES7528394750983745793290');        
  
CREATE TABLE ocurre (
    NombreEvento varchar(50) NOT NULL,
    FechaEvento date NOT NULL,
    TituloEspectaculo varchar(80) NOT NULL,
    TipoEspectaculo varchar(40) NOT NULL,
    AñoEspectaculo int NOT NULL,
    ProductorEspectaculo varchar(50) NOT NULL,
    UbicacionRecinto varchar(50) NOT NULL,
    PRIMARY KEY (NombreEvento, FechaEvento, TituloEspectaculo, TipoEspectaculo, AñoEspectaculo, ProductorEspectaculo, UbicacionRecinto),
    CONSTRAINT fk_ocurre_espectaculo FOREIGN KEY (NombreEvento, FechaEvento, TituloEspectaculo, TipoEspectaculo, AñoEspectaculo, ProductorEspectaculo) REFERENCES Espectaculos(NombreEvento, FechaEvento, Titulo, Tipo, Año, Productor),
    CONSTRAINT fk_ocurre_recinto FOREIGN KEY (UbicacionRecinto) REFERENCES Recintos(Ubicacion)
);

INSERT INTO ocurre (NombreEvento, FechaEvento, TituloEspectaculo, TipoEspectaculo, AñoEspectaculo, ProductorEspectaculo, UbicacionRecinto) VALUES
    ('Velada del Año 3', '2023-07-01', 'Viruzz vs Shelao', 'Deportivo', 2023, 'Ibai', '40.43618570541075, -3.5993493869409128'),
    ('Velada del Año 3', '2023-07-01', 'Concierto Quevedo', 'Musical', 2023, 'Ibai', '40.43618570541075, -3.5993493869409128'),
    ('Boombastic Festival', '2023-07-21', 'Concierto Quevedo', 'Musical', 2023, 'Boombastic', '43.438429878398765, -5.830045432782776');

CREATE TABLE oferta (
    UbicacionRecinto varchar(50) NOT NULL,
    NombreGrada varchar(30) NOT NULL,
    UbicacionLocalidad varchar(50) NOT NULL,
    TipoUsuario ENUM('Jubilado', 'Adulto', 'Infantil', 'Parado') NOT NULL,
    Precio decimal(8,2) NOT NULL,
    PRIMARY KEY (UbicacionRecinto, NombreGrada, UbicacionLocalidad, TipoUsuario),
    CONSTRAINT fk_oferta_localidad FOREIGN KEY (UbicacionRecinto, NombreGrada, UbicacionLocalidad) REFERENCES Localidades(UbicacionRecinto, NombreGrada, UbicacionLocalidad),
    CONSTRAINT fk_oferta_usuario FOREIGN KEY (TipoUsuario) REFERENCES Usuarios(Tipo)
);

INSERT INTO oferta (UbicacionRecinto, NombreGrada, UbicacionLocalidad, TipoUsuario, Precio) VALUES
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 8, Asiento 92', 'Adulto', 142.86),
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 8, Asiento 92', 'Infantil', 103.45),
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 8, Asiento 92', 'Jubilado', 142.86),
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 8, Asiento 92', 'Parado', 142.86),
    ('43.438429878398765, -5.830045432782776', 'Abono General', 'Zona Genérica', 'Adulto', 119.90),
    ('43.438429878398765, -5.830045432782776', 'Abono General', 'Zona Genérica', 'Jubilado', 119.90),
    ('43.438429878398765, -5.830045432782776', 'Abono General', 'Zona Genérica', 'Parado', 119.90);

CREATE TABLE tipo (
    NombreEvento varchar(50) NOT NULL,
    FechaEvento date NOT NULL,
    TituloEspectaculo varchar(80) NOT NULL,
    TipoEspectaculo varchar(40) NOT NULL,
    AñoEspectaculo int NOT NULL,
    ProductorEspectaculo varchar(50) NOT NULL,
    TipoUsuario ENUM('Jubilado', 'Adulto', 'Infantil', 'Parado') NOT NULL,
    CantidadUsuario int NOT NULL,
    PRIMARY KEY (NombreEvento, FechaEvento, TituloEspectaculo, TipoEspectaculo, AñoEspectaculo, ProductorEspectaculo, TipoUsuario),
    CONSTRAINT fk_tipo_espectaculo FOREIGN KEY (NombreEvento, FechaEvento, TituloEspectaculo, TipoEspectaculo, AñoEspectaculo, ProductorEspectaculo) REFERENCES Espectaculos(NombreEvento, FechaEvento, Titulo, Tipo, Año, Productor),
    CONSTRAINT fk_tipo_usuario FOREIGN KEY (TipoUsuario) REFERENCES Usuarios(Tipo)
);

INSERT INTO tipo (NombreEvento, FechaEvento, TituloEspectaculo, TipoEspectaculo, AñoEspectaculo, ProductorEspectaculo, TipoUsuario, CantidadUsuario) VALUES
    ('Velada del Año 3', '2023-07-01', 'Viruzz vs Shelao', 'Deportivo', 2023, 'Ibai', 'Adulto', 68456),
    ('Velada del Año 3', '2023-07-01', 'Viruzz vs Shelao', 'Deportivo', 2023, 'Ibai', 'Infantil', 68456),
    ('Velada del Año 3', '2023-07-01', 'Viruzz vs Shelao', 'Deportivo', 2023, 'Ibai', 'Jubilado', 68456),
    ('Velada del Año 3', '2023-07-01', 'Viruzz vs Shelao', 'Deportivo', 2023, 'Ibai', 'Parado', 68456),
    ('Velada del Año 3', '2023-07-01', 'Concierto Quevedo', 'Musical', 2023, 'Ibai', 'Adulto', 68456),
    ('Velada del Año 3', '2023-07-01', 'Concierto Quevedo', 'Musical', 2023, 'Ibai', 'Infantil', 68456),
    ('Velada del Año 3', '2023-07-01', 'Concierto Quevedo', 'Musical', 2023, 'Ibai', 'Jubilado', 68456),
    ('Velada del Año 3', '2023-07-01', 'Concierto Quevedo', 'Musical', 2023, 'Ibai', 'Parado', 68456),
    ('Boombastic Festival', '2023-07-21', 'Concierto Quevedo', 'Musical', 2023, 'Boombastic', 'Adulto', 55000),
    ('Boombastic Festival', '2023-07-21', 'Concierto Quevedo', 'Musical', 2023, 'Boombastic', 'Infantil', 0),
    ('Boombastic Festival', '2023-07-21', 'Concierto Quevedo', 'Musical', 2023, 'Boombastic', 'Jubilado', 55000),
    ('Boombastic Festival', '2023-07-21', 'Concierto Quevedo', 'Musical', 2023, 'Boombastic', 'Parado', 55000);

CREATE TABLE vendida (
    DNICliente varchar(9) NOT NULL,
    TipoUsuario ENUM('Jubilado', 'Adulto', 'Infantil', 'Parado') NOT NULL,
    UbicacionRecinto varchar(50) NOT NULL,
    NombreGrada varchar(30) NOT NULL,
    UbicacionLocalidad varchar(50) NOT NULL,
    PRIMARY KEY (DNICliente, TipoUsuario, UbicacionRecinto, NombreGrada, UbicacionLocalidad),
    CONSTRAINT fk_vendida_cliente FOREIGN KEY (DNICliente) REFERENCES Cliente(DNI),
    CONSTRAINT fk_vendida_usuario FOREIGN KEY (TipoUsuario) REFERENCES Usuarios(Tipo),
    CONSTRAINT fk_vendida_localidad FOREIGN KEY (UbicacionRecinto, NombreGrada, UbicacionLocalidad) REFERENCES Localidades(UbicacionRecinto, NombreGrada, UbicacionLocalidad)
);

INSERT INTO vendida (DNICliente, TipoUsuario, UbicacionRecinto, NombreGrada, UbicacionLocalidad) VALUES
    ('35762832V', 'Adulto', '40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 3, Asiento 40'),
    ('78659312H', 'Parado', '43.438429878398765, -5.830045432782776', 'Abono VIP', 'Zona Genérica y Espacios VIP');

CREATE TABLE pertenece (
    UbicacionRecinto varchar(50) NOT NULL,
    NombreGrada varchar(30) NOT NULL,
    UbicacionLocalidad varchar(50) NOT NULL,
    NombreEvento varchar(50) NOT NULL,
    FechaEvento date NOT NULL,
    TituloEspectaculo varchar(80) NOT NULL,
    TipoEspectaculo varchar(40) NOT NULL,
    AñoEspectaculo int NOT NULL,
    ProductorEspectaculo varchar(50) NOT NULL,
    PRIMARY KEY (UbicacionRecinto, NombreGrada, UbicacionLocalidad, NombreEvento, FechaEvento, TituloEspectaculo, TipoEspectaculo, AñoEspectaculo, ProductorEspectaculo),
    CONSTRAINT fk_pertenece_localidad FOREIGN KEY (UbicacionRecinto, NombreGrada, UbicacionLocalidad) REFERENCES Localidades(UbicacionRecinto, NombreGrada, UbicacionLocalidad),
    CONSTRAINT fk_pertenece_espectaculo FOREIGN KEY (NombreEvento, FechaEvento, TituloEspectaculo, TipoEspectaculo, AñoEspectaculo, ProductorEspectaculo) REFERENCES Espectaculos(NombreEvento, FechaEvento, Titulo, Tipo, Año, Productor)
);

INSERT INTO pertenece (UbicacionRecinto, NombreGrada, UbicacionLocalidad, NombreEvento, FechaEvento, TituloEspectaculo, TipoEspectaculo, AñoEspectaculo, ProductorEspectaculo) VALUES
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 8, Asiento 92', 'Velada del Año 3', '2023-07-01', 'Viruzz vs Shelao', 'Deportivo', 2023, 'Ibai'),
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 8, Asiento 92', 'Velada del Año 3', '2023-07-01', 'Concierto Quevedo', 'Musical', 2023, 'Ibai'),
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 3, Asiento 40', 'Velada del Año 3', '2023-07-01', 'Viruzz vs Shelao', 'Deportivo', 2023, 'Ibai'),
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Casters', 'Fila 3, Asiento 40', 'Velada del Año 3', '2023-07-01', 'Concierto Quevedo', 'Musical', 2023, 'Ibai'),
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Artistas', 'Fila 8, Asiento 92', 'Velada del Año 3', '2023-07-01', 'Viruzz vs Shelao', 'Deportivo', 2023, 'Ibai'),
    ('40.43618570541075, -3.5993493869409128', 'Pista Zona Artistas', 'Fila 8, Asiento 92', 'Velada del Año 3', '2023-07-01', 'Concierto Quevedo', 'Musical', 2023, 'Ibai'),
    ('40.43618570541075, -3.5993493869409128', 'Grada Precio 8', 'Fila 8, Asiento 92', 'Velada del Año 3', '2023-07-01', 'Viruzz vs Shelao', 'Deportivo', 2023, 'Ibai'),
    ('40.43618570541075, -3.5993493869409128', 'Grada Precio 8', 'Fila 8, Asiento 92', 'Velada del Año 3', '2023-07-01', 'Concierto Quevedo', 'Musical', 2023, 'Ibai'),
    ('43.438429878398765, -5.830045432782776', 'Abono General', 'Zona Genérica', 'Boombastic Festival', '2023-07-21', 'Concierto Quevedo', 'Musical', 2023, 'Boombastic'),
    ('43.438429878398765, -5.830045432782776', 'Abono VIP', 'Zona Genérica y Espacios VIP', 'Boombastic Festival', '2023-07-21', 'Concierto Quevedo', 'Musical', 2023, 'Boombastic');