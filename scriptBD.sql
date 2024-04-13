
/*FINANZAS*/
CREATE TABLE FINANZAS(
    id_finanzas NUMBER NOT NULL,
    fecha_finanzas DATE,
    caja_inicio_dia NUMBER,
    caja_final_dia NUMBER,
    detalle VARCHAR2(100)
);

/*MARCA*/
CREATE TABLE MARCA(
    id_marca NUMBER NOT NULL,
    nombre VARCHAR2(30),
    nacionalidad VARCHAR2(30)
);

/* MODELO*/
CREATE TABLE MODELO(
    id_modelo NUMBER NOT NULL,
    id_marca NUMBER NOT NULL,
    nombre_modelo VARCHAR2(50),
    num_puertas NUMBER,
    anio NUMBER
);

/* INGRESOS*/
CREATE TABLE INGRESOS(
    id_ingreso NUMBER NOT NULL,
    id_proveedor NUMBER NOT NULL,
    fecha_ingreso DATE,
    total_pago NUMBER,
    cantidad NUMBER
);

CREATE TABLE detalle_ingreso(
	id_ingreso number not null,
    id_inventario NUMBER NOT NULL,
    cantidad_vendida number,
    total_linea number,
    nLinea number
);

/*PROVEEDOR*/
CREATE TABLE PROVEEDOR(
    id_proveedor NUMBER NOT NULL,
    num_tel_prov VARCHAR2(10),
    sucursal VARCHAR2(20),
    nombre_prov VARCHAR2(50),
    email VARCHAR2(50)
);

/*INVENTARIO*/
CREATE TABLE INVENTARIO(
    id_inventario NUMBER NOT NULL,
    id_modelo NUMBER NOT NULL,
    precio_unidad NUMBER,
    nombre_inv VARCHAR2(50),
    stock NUMBER,
    sucursal_disponible VARCHAR2(30),
    disponible VARCHAR2(5)
);

ALTER TABLE INVENTARIO
ADD url_imagen VARCHAR2(100);


/*USUARIO*/
CREATE TABLE USUARIO(
    id_usuario NUMBER NOT NULL,
    nombre VARCHAR2(20),
    prim_apellido VARCHAR2(20),
    seg_apellido VARCHAR2(20),
    cedula number,
    rol VARCHAR2(20),
    telefono_usuario VARCHAR2(10),
    correo VARCHAR2(50)
);

/*FACTURA*/
CREATE TABLE FACTURA(
    id_factura NUMBER NOT NULL,
    id_usuario NUMBER NOT NULL,
    fecha_pago DATE,
    total_pago NUMBER
);

/* DETALLE FACTURA*/
CREATE TABLE detalle_factura(
    id_factura NUMBER NOT NULL,
    id_inventario NUMBER NOT NULL,
    cantidad_vendida NUMBER,
    n_linea NUMBER,
    total_linea NUMBER
);

/*PRIMARY KEYS*/
--Modelo
ALTER TABLE MODELO
ADD CONSTRAINT pk_modelo PRIMARY KEY (id_modelo);

--Marca
ALTER TABLE MARCA
ADD CONSTRAINT pk_marca PRIMARY KEY (id_marca);

--Inventario
ALTER TABLE INVENTARIO
ADD CONSTRAINT pk_inventario PRIMARY KEY (id_inventario);

--Proveedor
ALTER TABLE PROVEEDOR
ADD CONSTRAINT pk_proveedor PRIMARY KEY (id_proveedor);

--Usuario
ALTER TABLE USUARIO
ADD CONSTRAINT pk_usuario PRIMARY KEY (id_usuario);

--Factura
ALTER TABLE FACTURA
ADD CONSTRAINT pk_factura PRIMARY KEY (id_factura);

--Detalle Factura
ALTER TABLE detalle_factura
ADD CONSTRAINT pk_detalle_factura PRIMARY KEY (id_factura, n_linea);

/*FOREIGN KEYS*/
--Modelo
ALTER TABLE MODELO
ADD CONSTRAINT fk_modelo_marca FOREIGN KEY (id_marca) REFERENCES MARCA(id_marca);

--Ingresos
ALTER TABLE INGRESOS
ADD CONSTRAINT fk_ingresos_proovedor FOREIGN KEY (id_proveedor) REFERENCES PROVEEDOR(id_proveedor);

--detalle ingreso
ALTER TABLE detalle_ingreso
ADD CONSTRAINT fk_ingreso_inventario FOREIGN KEY (id_inventario) REFERENCES INVENTARIO(id_inventario);

ALTER TABLE detalle_ingreso
ADD CONSTRAINT fk_detalle_ingreso FOREIGN KEY (id_ingreso) REFERENCES INGRESOS(id_ingreso);


--Inventario
ALTER TABLE INVENTARIO
ADD CONSTRAINT fk_inventario_modelo FOREIGN KEY (id_modelo) REFERENCES MODELO(id_modelo);

--Factura
ALTER TABLE FACTURA
ADD CONSTRAINT fk_factura_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario);

--Detalle Factura
ALTER TABLE detalle_factura
ADD CONSTRAINT fk_detalle_factura_factura FOREIGN KEY (id_factura) REFERENCES FACTURA(id_factura);

ALTER TABLE detalle_factura
ADD CONSTRAINT fk_detalle_factura_inventario FOREIGN KEY (id_inventario) REFERENCES INVENTARIO(id_inventario);


/*Paquete inventario*/
CREATE OR REPLACE PACKAGE USERSERVICE.paquete_inventario IS
    procedure INSERTAR_INVENTARIO(
	id_inventario IN NUMBER,
    id_modelo IN NUMBER,
    precio_unidad IN NUMBER,
    nombre_inv IN VARCHAR2,
    stock IN NUMBER,
    sucursal_disponible IN VARCHAR2,
    disponible IN VARCHAR2
    );
    
    procedure EDITAR_INVENTARIO(
	id_inventario IN NUMBER,
    id_modelo IN NUMBER,
    precio_unidad IN NUMBER,
    nombre_inv IN VARCHAR2,
    stock IN NUMBER,
    sucursal_disponible IN VARCHAR2,
    disponible IN VARCHAR2
    );

    FUNCTION COMPARAR_NOMBRE_INV(
        nombre_inventario IN VARCHAR2
    ) RETURN SYS_REFCURSOR;
    
    
end;

CREATE OR REPLACE PACKAGE BODY USERSERVICE.paquete_inventario IS
PROCEDURE INSERTAR_INVENTARIO(
    id_inventario IN NUMBER,
    id_modelo IN NUMBER,
    precio_unidad IN NUMBER,
    nombre_inv IN VARCHAR2,
    stock IN NUMBER,
    sucursal_disponible IN VARCHAR2,
    disponible IN VARCHAR2
)IS
    BEGIN
        INSERT INTO USERSERVICE.inventario (
            id_inventario,
            id_modelo,
            precio_unidad,
            nombre_inv,
            stock,
            sucursal_disponible,
            disponible
        ) VALUES (
            id_inventario,
            id_modelo,
            precio_unidad,
            nombre_inv,
            stock,
            sucursal_disponible,
            disponible
        );
        
    END INSERTAR_INVENTARIO;
    
PROCEDURE EDITAR_INVENTARIO(
        id_inventario IN NUMBER,
        id_modelo IN NUMBER,
        precio_unidad IN NUMBER,
        nombre_inv IN VARCHAR2,
        stock IN NUMBER,
        sucursal_disponible IN VARCHAR2,
        disponible IN VARCHAR2
    )IS
        BEGIN
            UPDATE USERSERVICE.inventario SET 
                id_modelo = id_modelo,
                precio_unidad = precio_unidad,
                nombre_inv = nombre_inv,
                stock = stock,
                sucursal_disponible = sucursal_disponible,
                disponible = disponible
            WHERE id_inventario = id_inventario;
            
            
        END EDITAR_INVENTARIO;
        
    FUNCTION COMPARAR_NOMBRE_INV(
        nombre_inventario IN VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        cur SYS_REFCURSOR;
    BEGIN
        OPEN cur FOR
            SELECT *
            FROM inventario
            WHERE REGEXP_LIKE(nombre_inv, nombre_inv);
        
        RETURN cur;
    END COMPARAR_NOMBRE_INV;
END paquete_inventario;

--Paquete usuario
CREATE OR REPLACE PACKAGE hr.paquete_usuarios IS
    TYPE usuario_cursor IS REF CURSOR;
    
    PROCEDURE BUSCAR_USUARIO(
        nombre_usuario IN VARCHAR2,
        apellido_usuario IN VARCHAR2,
        usuarios OUT usuario_cursor
    );
    procedure INSERTAR_USUARIO(
        nombre IN VARCHAR2,
        prim_apellido IN VARCHAR2,
        seg_apellido IN VARCHAR2,
        cedula IN NUMBER,
        rol IN VARCHAR2,
        telefono_usuario IN VARCHAR2,
        correo IN VARCHAR2
    );
    procedure EDITAR_USUARIO(
	    id_usuario2 IN NUMBER,
        nombre2 IN VARCHAR2,
        prim_apellido2 IN VARCHAR2,
        seg_apellido2 IN VARCHAR2,
        cedula2 IN NUMBER,
        rol2 IN VARCHAR2,
        telefono_usuario2 IN VARCHAR2,
        correo2 IN VARCHAR2
    );
    
    PROCEDURE BUSCAR_USUARIO_POR_ID(
        p_id_usuario IN hr.USUARIO.id_usuario%TYPE,
        p_nombre OUT VARCHAR2,
        p_prim_apellido OUT VARCHAR2,
        p_seg_apellido OUT VARCHAR2,
        p_cedula OUT NUMBER,
        p_rol OUT VARCHAR2,
        p_telefono_usuario OUT VARCHAR2,
        p_correo OUT VARCHAR2
    );
    
END paquete_usuarios;



CREATE OR REPLACE PACKAGE BODY hr.paquete_usuarios IS
    --PROCEDIMIENTO INSERTAR USUARIO
    PROCEDURE INSERTAR_USUARIO(
        nombre IN VARCHAR2,
        prim_apellido IN VARCHAR2,
        seg_apellido IN VARCHAR2,
        cedula IN NUMBER,
        rol IN VARCHAR2,
        telefono_usuario IN VARCHAR2,
        correo IN VARCHAR2
    )IS
    BEGIN
        INSERT INTO hr.USUARIO (
            nombre,
            prim_apellido,
            seg_apellido,
            cedula,
            rol,
            telefono_usuario,
            correo
        ) VALUES (
            nombre,
            prim_apellido,
            seg_apellido,
            cedula,
            rol,
            telefono_usuario,
            correo
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al insertar el usuario: ' || SQLERRM);
    END INSERTAR_USUARIO;

    --PROCEDIMIENTO BUSCAR USUARIO
    PROCEDURE BUSCAR_USUARIO(
        nombre_usuario IN VARCHAR2,
        apellido_usuario IN VARCHAR2,
        usuarios OUT usuario_cursor
    ) IS
        v_usuarios usuario_cursor;
    BEGIN
        OPEN v_usuarios FOR
            SELECT * 
            FROM USUARIO 
            WHERE nombre = nombre_usuario 
            AND (prim_apellido = apellido_usuario OR seg_apellido = apellido_usuario);
        
        usuarios := v_usuarios;
    END BUSCAR_USUARIO;
    
    --PROCEDIMIENTO EDITAR USUARIO
    PROCEDURE EDITAR_USUARIO(
    id_usuario2 IN NUMBER,
    nombre2 IN VARCHAR2,
    prim_apellido2 IN VARCHAR2,
    seg_apellido2 IN VARCHAR2,
    cedula2 IN NUMBER,
    rol2 IN VARCHAR2,
    telefono_usuario2 IN VARCHAR2,
    correo2 IN VARCHAR2
) IS
BEGIN
    UPDATE hr.USUARIO SET 
        nombre = nombre2,
        prim_apellido = prim_apellido2,
        seg_apellido = seg_apellido2,
        cedula = cedula2,
        rol = rol2,
        telefono_usuario = telefono_usuario2,
        correo = correo2
    WHERE id_usuario = id_usuario2; 
    
    COMMIT;
END EDITAR_USUARIO;

    
    --PROCEDIMIENTO BUSCAR USUARIO POR ID PARA LUEGO EDITAR
    PROCEDURE BUSCAR_USUARIO_POR_ID(
        p_id_usuario IN hr.USUARIO.id_usuario%TYPE,
        p_nombre OUT VARCHAR2,
        p_prim_apellido OUT VARCHAR2,
        p_seg_apellido OUT VARCHAR2,
        p_cedula OUT NUMBER,
        p_rol OUT VARCHAR2,
        p_telefono_usuario OUT VARCHAR2,
        p_correo OUT VARCHAR2
    ) IS
    BEGIN
        SELECT
            nombre,
            prim_apellido,
            seg_apellido, 
            cedula, 
            rol, 
            telefono_usuario, 
            correo
        INTO 
            p_nombre, 
            p_prim_apellido, 
            p_seg_apellido, 
            p_cedula, p_rol, 
            p_telefono_usuario, 
            p_correo
        FROM 
            hr.USUARIO
        WHERE 
            id_usuario = p_id_usuario;

        -- Si no se encuentra ningún usuario con el ID ingresado
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No se encontró ningún usuario con el ID proporcionado.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al buscar el usuario: ' || SQLERRM);
    END BUSCAR_USUARIO_POR_ID;

END paquete_usuarios;


CREATE OR REPLACE PACKAGE BODY paquetee_facturas IS
    
    PROCEDURE insertar_factura(
        p_id_usuario IN NUMBER,
        p_fecha_pago IN DATE,
        p_total_pago IN NUMBER,
        p_id_inventario IN NUMBER,
        p_cantidad_vendida IN NUMBER,
        p_n_linea IN NUMBER,
        p_total_linea IN NUMBER
    ) IS
        v_id_factura NUMBER;
    BEGIN
        
        INSERT INTO factura (id_usuario, fecha_pago, total_pago)
        VALUES (p_id_usuario, p_fecha_pago, p_total_pago)
        RETURNING id_factura INTO v_id_factura;

        INSERT INTO detalle_factura (id_factura, id_inventario, cantidad_vendida, n_linea, total_linea)
        VALUES (v_id_factura, p_id_inventario, p_cantidad_vendida, p_n_linea, p_total_linea);
        
 
        COMMIT;
    END insertar_factura;
END paquetee_facturas;

select * from factura;




-- Paquete facturas

CREATE OR REPLACE PACKAGE paquetee_facturas IS
    TYPE factura_cursor IS REF CURSOR;
    procedure INSERTAR_FACTURA(
        id_usuario NUMBER,
        fecha_pago DATE,
        total_pago NUMBER
    );

END paquetee_facturas;




CREATE OR REPLACE PACKAGE BODY paquetee_facturas IS
    PROCEDURE INSERTAR_FACTURA(
        id_usuario NUMBER,
        fecha_pago DATE,
        total_pago NUMBER
)IS
    BEGIN
        INSERT INTO FACTURA (
            id_usuario,
            fecha_pago,
            total_pago 
        ) VALUES (
            id_usuario,
            fecha_pago,
            total_pago
        );
        
    END INSERTAR_FACTURA;
    
END paquetee_facturas;


--Auditoria
ALTER TABLE FINANZAS
ADD (CREATED_BY VARCHAR2(50),
     UPDATED_BY VARCHAR2(50),
     ESTADO VARCHAR2(20));

ALTER TABLE MARCA
ADD (CREATED_BY VARCHAR2(50),
     UPDATED_BY VARCHAR2(50),
     ESTADO VARCHAR2(20));

ALTER TABLE MODELO
ADD (CREATED_BY VARCHAR2(50),
     UPDATED_BY VARCHAR2(50),
     ESTADO VARCHAR2(20));

ALTER TABLE INGRESOS
ADD (CREATED_BY VARCHAR2(50),
     UPDATED_BY VARCHAR2(50),
     ESTADO VARCHAR2(20));

ALTER TABLE detalle_ingreso
ADD (CREATED_BY VARCHAR2(50),
     UPDATED_BY VARCHAR2(50),
     ESTADO VARCHAR2(20));

ALTER TABLE PROVEEDOR
ADD (CREATED_BY VARCHAR2(50),
     UPDATED_BY VARCHAR2(50),
     ESTADO VARCHAR2(20));

ALTER TABLE INVENTARIO
ADD (CREATED_BY VARCHAR2(50),
     UPDATED_BY VARCHAR2(50),
     ESTADO VARCHAR2(20));

ALTER TABLE USUARIO
ADD (CREATED_BY VARCHAR2(50),
     UPDATED_BY VARCHAR2(50),
     ESTADO VARCHAR2(20));

ALTER TABLE FACTURA
ADD (CREATED_BY VARCHAR2(50),
     UPDATED_BY VARCHAR2(50),
     ESTADO VARCHAR2(20));

ALTER TABLE detalle_factura
ADD (CREATED_BY VARCHAR2(50),
     UPDATED_BY VARCHAR2(50),
     ESTADO VARCHAR2(20));

--Auditoria Usuario
CREATE OR REPLACE TRIGGER TRG_CREATE_BY_USUARIO
BEFORE INSERT ON USUARIO
for each row
Begin
    :NEW.CREATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_UPDATED_BY_USUARIO
BEFORE UPDATE ON USUARIO
for each row
Begin
    :NEW.UPDATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_ESTADO_USUARIO
BEFORE INSERT OR UPDATE ON USUARIO
for each row
Begin
    IF INSERTING THEN
         :NEW.ESTADO := 'INSERT';
    ELSIF UPDATING THEN
        :NEW.ESTADO := 'UPDATE';
    END IF;
END;

--Auditoria finanzas
CREATE OR REPLACE TRIGGER TRG_CREATE_BY_FINANZAS
BEFORE INSERT ON FINANZAS
for each row
Begin
    :NEW.CREATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_UPDATED_BY_FINANZAS
BEFORE UPDATE ON FINANZAS
for each row
Begin
    :NEW.UPDATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_ESTADO_FINANZAS
BEFORE INSERT OR UPDATE ON FINANZAS
for each row
Begin
    IF INSERTING THEN
         :NEW.ESTADO := 'INSERT';
    ELSIF UPDATING THEN
        :NEW.ESTADO := 'UPDATE';
    END IF;
END;

--Auditoria marca
CREATE OR REPLACE TRIGGER TRG_CREATE_BY_MARCA
BEFORE INSERT ON MARCA
for each row
Begin
    :NEW.CREATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_UPDATED_BY_MARCA
BEFORE UPDATE ON MARCA
for each row
Begin
    :NEW.UPDATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_ESTADO_MARCA
BEFORE INSERT OR UPDATE ON MARCA
for each row
Begin
    IF INSERTING THEN
         :NEW.ESTADO := 'INSERT';
    ELSIF UPDATING THEN
        :NEW.ESTADO := 'UPDATE';
    END IF;
END;

--Auditoria modelo
CREATE OR REPLACE TRIGGER TRG_CREATE_BY_MODELO
BEFORE INSERT ON MODELO
for each row
Begin
    :NEW.CREATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_UPDATED_BY_MODELO
BEFORE UPDATE ON MODELO
for each row
Begin
    :NEW.UPDATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_ESTADO_MODELO
BEFORE INSERT OR UPDATE ON MODELO
for each row
Begin
    IF INSERTING THEN
         :NEW.ESTADO := 'INSERT';
    ELSIF UPDATING THEN
        :NEW.ESTADO := 'UPDATE';
    END IF;
END;

--Auditoria INGRESOS
CREATE OR REPLACE TRIGGER TRG_CREATE_BY_INGRESOS
BEFORE INSERT ON INGRESOS
for each row
Begin
    :NEW.CREATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_UPDATED_BY_INGRESOS
BEFORE UPDATE ON INGRESOS
for each row
Begin
    :NEW.UPDATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_ESTADO_INGRESOS
BEFORE INSERT OR UPDATE ON INGRESOS
for each row
Begin
    IF INSERTING THEN
         :NEW.ESTADO := 'INSERT';
    ELSIF UPDATING THEN
        :NEW.ESTADO := 'UPDATE';
    END IF;
END;

--Auditoria DETALLE_INGRESO

CREATE OR REPLACE TRIGGER TRG_CREATE_BY_DETALLE_INGRESO
BEFORE INSERT ON detalle_ingreso
for each row
Begin
    :NEW.CREATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_UPDATED_BY_DETALLE_INGRESO
BEFORE UPDATE ON DETALLE_INGRESO
for each row
Begin
    :NEW.UPDATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_ESTADO_DETALLE_INGRESO
BEFORE INSERT OR UPDATE ON detalle_ingreso
for each row
Begin
    IF INSERTING THEN
         :NEW.ESTADO := 'INSERT';
    ELSIF UPDATING THEN
        :NEW.ESTADO := 'UPDATE';
    END IF;
END;

--Auditoria proveedor
CREATE OR REPLACE TRIGGER TRG_CREATE_BY_PROVEEDOR
BEFORE INSERT ON PROVEEDOR
for each row
Begin
    :NEW.CREATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_UPDATED_BY_PROVEEDOR
BEFORE UPDATE ON PROVEEDOR
for each row
Begin
    :NEW.UPDATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_ESTADO_PROVEEDOR
BEFORE INSERT OR UPDATE ON PROVEEDOR
for each row
Begin
    IF INSERTING THEN
         :NEW.ESTADO := 'INSERT';
    ELSIF UPDATING THEN
        :NEW.ESTADO := 'UPDATE';
    END IF;
END;

--Auditoria inventario
CREATE OR REPLACE TRIGGER TRG_CREATE_BY_INVENTARIO
BEFORE INSERT ON INVENTARIO
for each row
Begin
    :NEW.CREATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_UPDATED_BY_INVENTARIO
BEFORE UPDATE ON INVENTARIO
for each row
Begin
    :NEW.UPDATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_ESTADO_INVENTARIO
BEFORE INSERT OR UPDATE ON INVENTARIO
for each row
Begin
    IF INSERTING THEN
         :NEW.ESTADO := 'INSERT';
    ELSIF UPDATING THEN
        :NEW.ESTADO := 'UPDATE';
    END IF;
END;

--Auditoria factura
CREATE OR REPLACE TRIGGER TRG_CREATE_BY_FACTURA
BEFORE INSERT ON FACTURA
for each row
Begin
    :NEW.CREATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_UPDATED_BY_FACTURA
BEFORE UPDATE ON FACTURA
for each row
Begin
    :NEW.UPDATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_ESTADO_FACTURA
BEFORE INSERT OR UPDATE ON FACTURA
for each row
Begin
    IF INSERTING THEN
         :NEW.ESTADO := 'INSERT';
    ELSIF UPDATING THEN
        :NEW.ESTADO := 'UPDATE';
    END IF;
END;

--Auditoria detalle_factura
CREATE OR REPLACE TRIGGER TRG_CREATE_BY_DETALLE_FACTURA
BEFORE INSERT ON detalle_factura
for each row
Begin
    :NEW.CREATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_UPDATED_BY_DETALLE_FACTURA
BEFORE UPDATE ON detalle_factura
for each row
Begin
    :NEW.UPDATED_BY:= USER;
END;

CREATE OR REPLACE TRIGGER TRG_ESTADO_DETALLE_FACTURA
BEFORE INSERT OR UPDATE ON detalle_factura
for each row
Begin
    IF INSERTING THEN
         :NEW.ESTADO := 'INSERT';
    ELSIF UPDATING THEN
        :NEW.ESTADO := 'UPDATE';
    END IF;
END;

CREATE OR REPLACE PROCEDURE obtener_usuarios(
    usuarios_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN usuarios_cursor FOR
        SELECT * FROM usuario;
END obtener_usuarios;


--Nuevos cambios

ALTER TABLE INVENTARIO
ADD url_imagen VARCHAR2(100);

--Secuencia autoincrement id
--Importante: Se debe eliminar el ID del proceso de insertar en el paquete de usuarios para que funcione bien a la hora
--de insertar un nuevo usuario por medio del crud.

CREATE SEQUENCE SEQ_USUARIO_ID
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE TRIGGER TRG_GENERAR_SEQ_USUA_ID
BEFORE INSERT ON USUARIO
FOR EACH ROW
BEGIN
  :NEW.id_usuario := SEQ_USUARIO_ID.NEXTVAL;
END;


