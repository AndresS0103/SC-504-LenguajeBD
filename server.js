const express = require('express');
const oracledb = require('oracledb');
const path = require('path');
const app = express();

app.use(express.static(path.join(__dirname, 'views')));

app.get('/usuarios', async (req, res) => { 
    let connection;
    try {
        connection = await oracledb.getConnection({
            user: "hr",
            password: "Hola123456789",
            connectString: "localhost/orcl"
        });

        const result = await connection.execute(`SELECT * FROM usuario`);
        const usuarios = result.rows; 
        console.log(usuarios);
        res.json(usuarios); 
    } catch (error) {
        console.error('Error al obtener los usuarios:', error);
        res.status(500).json({ error: 'Error al obtener los usuarios' });
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error(err);
            }
        }
    }
});


app.listen(3000, () => {
    console.log('Servidor en el puerto 3000');
});