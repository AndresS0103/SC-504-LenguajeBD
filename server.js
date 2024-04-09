const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const oracledb = require('oracledb');
const app = express();
const { obtenerUsuarios } = require('./conexion');
const { insertarUsuario } = require('./conexion');
const { obtenerFacturas } = require('./conexion');


app.use(express.static(path.join(__dirname, 'views')));
app.use(bodyParser.json());

const dbConfig = {
    user: 'HR',
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
    const { nombre, prim_apellido, seg_apellido, cedula, rol, telefono_usuario, correo } = req.body;

    try {
        const connection = await oracledb.getConnection(dbConfig);
        const result = await connection.execute(
            `BEGIN paquete_usuarios.INSERTAR_USUARIO(:nombre, :prim_apellido, :seg_apellido, :cedula, :rol, :telefono_usuario, :correo); END;`,
            {
                nombre: nombre,
                prim_apellido: prim_apellido,
                seg_apellido: seg_apellido,
                cedula: cedula,
                rol: rol,
                telefono_usuario: telefono_usuario,
                correo: correo
            },
            { autoCommit: true }
        );

        connection.close();
        res.status(200).json({ message: 'Usuario agregado exitosamente' });
    } catch (error) {
        console.error('Error al insertar usuario:', error);
        res.status(500).json({ error: 'Error interno al insertar usuario' });
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


app.listen(3000, () => {
    console.log('Servidor en el puerto 3000');
});