const oracledb = require('oracledb');

async function conectarBaseDatos() {
    try {
        const connection = await oracledb.getConnection({
            user: "HR",
            password: "12345",
            connectString: "localhost/orcl"
        });
        return connection;
    } catch (error) {
        console.error('Error al conectar con la base de datos:', error);
        throw error;
    }
}

//visualizar usuarios

async function obtenerUsuarios() {
    let connection;
    try {
        connection = await conectarBaseDatos();
        const result = await connection.execute(
            `BEGIN obtener_usuarios(:usuarios_cursor); END;`
            , { usuarios_cursor: { dir: oracledb.BIND_OUT, type: oracledb.CURSOR } }
        );

        const usuariosCursor = result.outBinds.usuarios_cursor;
        let usuarios = [];
        let row;
        while ((row = await usuariosCursor.getRow())) {
            usuarios.push(row);
        }
        await usuariosCursor.close();
        return usuarios;
    } catch (error) {
        console.error('Error al obtener los usuarios:', error);
        throw error;
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error('Error al cerrar la conexión:', err);
            }
        }
    }
}

//insertar usuario
async function insertarUsuario(id_usuario, nombre, prim_apellido, seg_apellido, cedula, rol, telefono_usuario, correo)
{
    let connection;
    try {
        connection = await conectarBaseDatos();
        await connection.beginTransaction();

        await connection.execute(
            `BEGIN paquete_usuarios.INSERTAR_USUARIO(:id_usuario, :nombre, :prim_apellido, :seg_apellido, :cedula, :rol, :telefono_usuario, :correo); END;`,
            {
                id_usuario: id_usuario,
                nombre: nombre,
                prim_apellido: prim_apellido,
                seg_apellido: seg_apellido,
                cedula: cedula,
                rol: rol,
                telefono_usuario: telefono_usuario,
                correo: correo
            }
        );

        console.log('Usuario insertado correctamente.');

    } catch (error) {
        console.error('Error al insertar usuario:', error);
        throw error;
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error('Error al cerrar la conexión:', err);
            }
        }
    }
}
module.exports = {conectarBaseDatos, insertarUsuario};



async function agregarFactura(id_usuario, fecha_pago, total_pago, detalle) {
    let connection;
    try {
        connection = await conectarBaseDatos();
        await connection.beginTransaction();

        const resultFactura = await connection.execute(
            `INSERT INTO FACTURA (id_usuario, fecha_pago, total_pago) VALUES (:id_usuario, TO_DATE(:fecha_pago, 'YYYY-MM-DD'), :total_pago) RETURNING id_factura INTO :id_factura`,
            { id_usuario, fecha_pago, total_pago, id_factura: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } }
        );

        const id_factura = resultFactura.outBinds.id_factura[0];

        for (const detalleItem of detalle) {
            await connection.execute(
                `INSERT INTO detalle_factura (id_factura, id_inventario, cantidad_vendida, n_linea, total_linea) VALUES (:id_factura, :id_inventario, :cantidad_vendida, :n_linea, :total_linea)`,
                [id_factura, detalleItem.id_inventario, detalleItem.cantidad_vendida, detalleItem.n_linea, detalleItem.total_linea]
            );
        }

        await connection.commit();
    } catch (error) {
        console.error('Error al agregar factura:', error);
        if (connection) {
            try {
                await connection.rollback();
            } catch (rollbackError) {
                console.error('Error al hacer rollback:', rollbackError);
            }
        }
        throw error;
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (error) {
                console.error('Error al cerrar la conexión:', error);
            }
        }
    }
}


    async function obtenerFacturas() {
        let connection;
        try {
            connection = await conectarBaseDatos();
            const result = await connection.execute(
                `BEGIN paquete_factuuras.ver_facturas(:facturas_cursor); END;`,
                { facturas_cursor: { dir: oracledb.BIND_OUT, type: oracledb.CURSOR } }
            );
    
            const facturasCursor = result.outBinds.facturas_cursor;
            let facturas = [];
            let row;
            while ((row = await facturasCursor.getRow())) {
                facturas.push(row);
            }
            await facturasCursor.close();
            return facturas;
        } catch (error) {
            console.error('Error al obtener las facturas:', error);
            throw error;
        } finally {
            if (connection) {
                try {
                    await connection.close();
                } catch (err) {
                    console.error('Error al cerrar la conexión:', err);
                }
            }
        }
    }
 // ver marcas
    async function obtenerMarcas() {
        let connection;
        try {
            connection = await conectarBaseDatos();
            const result = await connection.execute(
                `BEGIN paquete_marca.ver_marcas(:marcas_cursor); END;`,
                { marcas_cursor: { dir: oracledb.BIND_OUT, type: oracledb.CURSOR } }
            );
    
            const marcasCursor = result.outBinds.marcas_cursor;
            let marcas = [];
            let row;
            while ((row = await marcasCursor.getRow())) {
                marcas.push(row);
            }
            await marcasCursor.close();
            return marcas;
        } catch (error) {
            console.error('Error al obtener las marcas:', error);
            throw error;
        } finally {
            if (connection) {
                try {
                    await connection.close();
                } catch (err) {
                    console.error('Error al cerrar la conexión:', err);
                }
            }
        }
    }

// Ver modelos

async function obtenerModelos() {
    let connection;
    try {
        connection = await conectarBaseDatos();
        const result = await connection.execute(
            `BEGIN paquete_modelo.ver_modelo(:modelo_cursor); END;`,
            { modelo_cursor: { dir: oracledb.BIND_OUT, type: oracledb.CURSOR } }
        );

        const modeloCursor = result.outBinds.modelo_cursor;
        let modelos = [];
        let row;
        while ((row = await modeloCursor.getRow())) {
            modelos.push(row);
        }
        await modeloCursor.close();
        return modelos;
    } catch (error) {
        console.error('Error al obtener los modelos:', error);
        throw error;
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error('Error al cerrar la conexión:', err);
            }
        }
    }
}


    module.exports = { conectarBaseDatos, obtenerUsuarios, obtenerFacturas, obtenerMarcas, obtenerModelos };
