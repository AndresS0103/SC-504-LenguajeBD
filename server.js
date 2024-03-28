const express = require('express');
const path = require('path');
const app = express();
const { obtenerUsuarios } = require('./conexion');

app.use(express.static(path.join(__dirname, 'views')));

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


//crear facturas
app.post('/facturas', async (req, res) => {
    const { id_factura, id_usuario, fecha_pago, total_pago, detalle } = req.body;

    try {
        // Llamar a la función para agregar factura
        await agregarFactura(id_factura, id_usuario, fecha_pago, total_pago, detalle);
        res.status(201).send('Factura creada exitosamente');
    } catch (error) {
        console.error('Error al crear factura:', error);
        res.status(500).send('Error interno del servidor');
    }
});

// ver facturas
app.get('/facturas', async (req, res) => {
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