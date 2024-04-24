const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const oracledb = require('oracledb');
const app = express();
const { obtenerUsuarios } = require('./conexion');
const { obtenerFacturas } = require('./conexion');
const { obtenerMarcas } = require('./conexion');
const { obtenerModelos } = require('./conexion');
const { obtenerInventarios } = require('./conexion');



/*
    Andres
    --
    editar contra
    modificar procedimiento editar en sql
    modificar en server.js
    agregar fila del form en html update
    agregar el usuario8 en llenar formulario

    hacer la presentacion de bd

    - hacer el diseno de la seccion de usuarios
    
    --

    - hacer el diseno de la seccion de usuarios
    - activar o inactivar usuarios
*/ 


app.use(express.static(path.join(__dirname, 'views')));
app.use(bodyParser.json());

const dbConfig = {
    user: 'USERSERVICE',
    password: '12345',
    connectString: 'localhost/orcl'
};

//ver usuarios
app.get('/usuarios', async (req, res) => {
    try {
        const usuarios = await obtenerUsuarios();
        res.json(usuarios);
    } catch (error) {
        console.error('Error al obtener los usuarios:', error);
        res.status(500).json({ error: 'Error al obtener los usuarios' });
    }
});

//insertar usuarios
app.post('/usuariosInsertar', async (req, res) => {
    const { nombre, prim_apellido, seg_apellido, cedula, rol, telefono_usuario, correo, contrasena } = req.body;

    try {
        const connection = await oracledb.getConnection(dbConfig);
        const result = await connection.execute(
            `BEGIN paquete_usuarios.INSERTAR_USUARIO(:nombre, :prim_apellido, :seg_apellido, :cedula, :rol, :telefono_usuario, :correo, :contrasena); END;`,
            {
                nombre: nombre,
                prim_apellido: prim_apellido,
                seg_apellido: seg_apellido,
                cedula: cedula,
                rol: rol,
                telefono_usuario: telefono_usuario,
                correo: correo,
                contrasena: contrasena
            }
        );

        connection.close();
        res.status(200).json({ message: 'Usuario agregado exitosamente' });
    } catch (error) {
        console.error('Error al insertar usuario:', error);
        res.status(500).json({ error: 'Error interno al insertar usuario' });
    }
});

//Editar Usuarios
app.post('/editarUsuario', async (req, res) => {

    const { id_usuario2, nombre2, prim_apellido2, seg_apellido2, cedula2, rol2, telefono_usuario2, correo2, contrasena2 } = req.body;

    try {
        const connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(
            `BEGIN 
                paquete_usuarios.EDITAR_USUARIO(:id_usuario2, :nombre2, :prim_apellido2, :seg_apellido2, :cedula2, :rol2, :telefono_usuario2, :correo2, :contrasena2); 
            END;`,
            {
                id_usuario2,
                nombre2,
                prim_apellido2,
                seg_apellido2,
                cedula2,
                rol2,
                telefono_usuario2,
                correo2,
                contrasena2
            }
        );

        await connection.commit();
        await connection.close();

        res.status(200).json({ message: 'Usuario actualizado exitosamente' });
    } catch (error) {
        console.error('Error al editar usuario:', error);
        res.status(500).json({ message: 'Error al editar usuario. Consulta la consola para más detalles.' });
    }
});

app.post('/iniciarSesion', async (req, res) => {
    const { correo, contrasena } = req.body;

    try {
        const connection = await oracledb.getConnection(dbConfig);
        const result = await connection.execute(
            `BEGIN iniciar_sesion(:correo_input, :contra_input, :numero); END;`,
            {
                correo_input: correo,
                contra_input: contrasena,
                numero: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
            }
        );

        const numero = result.outBinds.numero; 

        console.log(numero);

        if(numero == 1){
            res.status(200).json({ message: 'admin' });
        }else if(numero ==2){
            res.status(200).json({ message: 'normal' });
        }else{
            res.status(200).json({ message: 'Correo y Contraseña no validos' });
        }

        connection.close();

    } catch (error) {
        console.error('Error al iniciar sesión:', error);
        res.status(500).json({ error: 'Error interno al iniciar sesión' });
    }
});









//crear facturas
app.post('/facturas', async (req, res) => {
    const { id_usuario, fecha_pago, total_pago, id_inventario, cantidad_vendida, n_linea, total_linea } = req.body;

    try {
        const connection = await oracledb.getConnection(dbConfig);
        const result = await connection.execute(
            `BEGIN paquetee_facturas.INSERTAR_FACTURA(:id_usuario, TO_DATE(:fecha_pago, 'YYYY-MM-DD'), :total_pago, :id_inventario, :cantidad_vendida, :n_linea, :total_linea); END;`,
            {
                id_usuario: id_usuario,
                fecha_pago: fecha_pago,
                total_pago: total_pago,
                id_inventario: id_inventario,
                cantidad_vendida: cantidad_vendida,
                n_linea: n_linea,
                total_linea: total_linea

            },
            { autoCommit: true }
        );

        connection.close();
        res.status(200).json({ message: 'Factura agregada exitosamente' });
    } catch (error) {
        console.error('Error al insertar factura:', error);
        res.status(500).json({ error: 'Error interno al insertar factura' });
    }
});


// ver facturas
app.get('/verFacturas', async (req, res) => {
    try {
        const facturas = await obtenerFacturas();
        res.json(facturas);
    } catch (error) {
        console.error('Error al obtener las facturas:', error);
        res.status(500).send('Error interno del servidor');
    }
});

// Crear marcas
app.post('/marcas', async (req, res) => {
    const { nombre, nacionalidad } = req.body;

    try {
        const connection = await oracledb.getConnection(dbConfig);
        const result = await connection.execute(
            `BEGIN paquete_marca.insertar_marca(:nombre, :nacionalidad); END;`,
            {
                nombre: nombre,
                nacionalidad: nacionalidad
            },
            { autoCommit: true }
        );

        connection.close();
        res.status(200).json({ message: 'Marca agregada exitosamente' });
    } catch (error) {
        console.error('Error al insertar marca:', error);
        res.status(500).json({ error: 'Error interno al insertar marca' });
    }
});

// Ver marcas
app.get('/verMarcas', async (req, res) => {
    try {
        const marcas = await obtenerMarcas();
        res.json(marcas);
    } catch (error) {
        console.error('Error al obtener las marcas:', error);
        res.status(500).send('Error interno del servidor');
    }
});

// Crear modelo
app.post('/modelos', async (req, res) => {
    const { id_marca, nombre_modelo, num_puertas, anio } = req.body;

    try {
        const connection = await oracledb.getConnection(dbConfig);
        const result = await connection.execute(
            `BEGIN paquete_modelo.insertar_modelo(:id_marca, :nombre_modelo, :num_puertas, :anio); END;`,
            {
                id_marca: id_marca,
                nombre_modelo: nombre_modelo,
                num_puertas: num_puertas,
                anio: anio
            },
            { autoCommit: true }
        );

        connection.close();
        res.status(200).json({ message: 'Modelo agregado exitosamente' });
    } catch (error) {
        console.error('Error al agregar modelo:', error);
        res.status(500).json({ error: 'Error interno al agregar modelo' });
    }
});



// Ver modelos
app.get('/verModelos', async (req, res) => {
    try {
        const modelos = await obtenerModelos();
        res.json(modelos);
    } catch (error) {
        console.error('Error al obtener los modelos:', error);
        res.status(500).send('Error interno del servidor');
    }
});

app.get('/inventarios', async (req, res) => {
    try {
        const inventarios = await obtenerInventarios();
        res.json(inventarios);
    } catch (error) {
        console.error('Error al obtener los inventarios:', error);
        res.status(500).send('Error interno del servidor');
    }
});

app.post('/inventarioInsertar', async (req, res) => {
    const {id_modelo, nombre_inv, precio_unidad, stock, sucursal_disponible, disponible, url_imagen} = req.body;
    try{
        const connection = await oracledb.getConnection(dbConfig);
        const result = await connection.execute(
            `BEGIN paquete_inventario.INSERTAR_INVENTARIO(:id_modelo, :nombre_inv, :precio_unidad, :stock, :sucursal_disponible, :disponible, :url_imagen); END;`,
            {
                id_modelo: id_modelo,
                nombre_inv: nombre_inv,
                precio_unidad: precio_unidad,
                stock: stock,
                sucursal_disponible: sucursal_disponible,
                disponible: disponible,
                url_imagen: url_imagen
            },{ autoCommit: true }
        );
        connection.close();
        res.status(200).json({ message: 'Inventario agregado exitosamente' });
    }
    catch(error){
        console.error('Error al insertar inventario:', error);
        res.status(500).json({ error: 'Error interno al insertar inventario' });
    }
});



app.post('/editarInventario', async (req, res) => {
    const {id_inventario2, id_modelo2, nombre_inv2, precio_unidad2, stock2, sucursal_disponible2, disponible2, url_imagen2} = req.body;
    try{
        const connection = await oracledb.getConnection(dbConfig);
        const result = await connection.execute(
            `BEGIN paquete_inventario.EDITAR_INVENTARIO(:id_inventario2 ,:id_modelo2, :nombre_inv2, :precio_unidad2, :stock2, :sucursal_disponible2, :disponible2, :url_imagen2); END;`,
            {
                id_inventario2,
                id_modelo2,
                nombre_inv2,
                precio_unidad2,
                stock2,
                sucursal_disponible2,
                disponible2,
                url_imagen2
            },{ autoCommit: true }
        );
        await connection.commit();
        connection.close();
        res.status(200).json({ message: 'Inventario editado exitosamente' });
    }
    catch(error){
        console.error('Error al editar inventario:', error);
        res.status(500).json({ error: 'Error interno al editar inventario' });
    }
});


app.listen(3000, () => {
    console.log('Servidor en el puerto 3000');
});