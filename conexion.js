const oracledb = require('oracledb');

async function conectarBaseDatos() {
    try {
        const connection = await oracledb.getConnection({
            user: "hr",
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
        const result = await connection.execute(`SELECT * FROM usuario`);
        const usuarios = result.rows; 
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

// crear facturas 

async function agregarFactura(id_factura, id_usuario, fecha_pago, total_pago, detalle) {
    let connection;
    try {
        connection = await conectarBaseDatos();
        await connection.beginTransaction();

        // Insertar en la tabla FACTURA
        await connection.execute(
            `INSERT INTO FACTURA (id_factura, id_usuario, fecha_pago, total_pago) VALUES (:id_factura, :id_usuario, TO_DATE(:fecha_pago, 'YYYY-MM-DD'), :total_pago)`,
            [id_factura, id_usuario, fecha_pago, total_pago]
        );

        // Insertar en la tabla detalle_factura
        for (const detalleItem of detalle) {
            await connection.execute(
                `INSERT INTO detalle_factura (id_factura, id_inventario, cantidad_vendida, n_linea, total_linea) VALUES (:id_factura, :id_inventario, :cantidad_vendida, :n_linea, :total_linea)`,
                [id_factura, detalleItem.id_inventario, detalleItem.cantidad_vendida, detalleItem.n_linea, detalleItem.total_linea]
            );
        }

        // Commit
        await connection.commit();
    } catch (error) {
        console.error('Error al agregar factura:', error);
        // Rollback en caso de error
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
        const result = await connection.execute(`SELECT * FROM factura`);
        const facturas = result.rows;
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

module.exports = { conectarBaseDatos, obtenerUsuarios, obtenerFacturas };
