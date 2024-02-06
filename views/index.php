<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>JAFRA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <link rel="stylesheet" href="./assets/index.css">
</head>

<body>
    <nav class="navbar  fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="#"><img src="./assets/img/jafraLogo.jpg" alt="./assets/img/jafraLogo.jpg"></a>
            <button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbar"
                aria-controls="offcanvasNavbar" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasNavbar"
                aria-labelledby="offcanvasNavbarLabel">
                <div class="offcanvas-header">
                    <h5 class="offcanvas-title" id="offcanvasNavbarLabel">Offcanvas</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                </div>
                <div class="offcanvas-body">
                    <ul class="navbar-nav justify-content-end flex-grow-1 pe-3">
                        <li class="nav-item">
                            <a class="nav-link active" aria-current="page" href="#">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" aria-current="page" href="#">Inventario</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" aria-current="page" href="#">Usuarios</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" aria-current="page" href="#">Sucursales</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" aria-current="page" href="#">Avisos</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" aria-current="page" href="#">Ingresos</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" aria-current="page" href="#">Finanzas</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <main>
        <div class="container-cards">
            <div class="row row-cols-1 row-cols-md-2 g-4">
                <div class="col">
                    <div class="card">
                        <img src="https://www.acmonedero.com/wp-content/themes/yootheme/cache/45/img-caja-cambios-mecanica@2x-454e3d16.jpeg" class="card-img-top" id="imagenCard" alt="...">
                        <div class="card-body">
                            <h5 class="card-title">Caja de cambios</h5>
                            <p class="card-text">Componente crucial en un vehículo que permite variar la relación de velocidad entre el motor y las ruedas. </p>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card">
                        <img src="https://motor.elpais.com/wp-content/uploads/2022/09/alternador.jpg?v=1663843719" class="card-img-top"  id="imagenCard" alt="...">
                        <div class="card-body">
                            <h5 class="card-title">Alternador</h5>
                            <p class="card-text">Un alternador es un componente esencial en un vehículo que tiene la función de generar energía eléctrica para alimentar 
                                el sistema eléctrico del automóvil y recargar la batería.</p>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card">
                        <img src="..." class="card-img-top" alt="...">
                        <div class="card-body">
                            <h5 class="card-title">Card title</h5>
                            <p class="card-text">This is a longer card with supporting text below as a natural lead-in
                                to
                                additional content.</p>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card">
                        <img src="..." class="card-img-top" alt="...">
                        <div class="card-body">
                            <h5 class="card-title">Card title</h5>
                            <p class="card-text">This is a longer card with supporting text below as a natural lead-in
                                to
                                additional content. This content is a little bit longer.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div class="container-frase">
            <h4> Especialidad en motores, cajas de cambios y partes eléctricas. <br>
            Pruebas de distribuidores, igniter, bobinas, etc</h4>
        </div>
    </main>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
        crossorigin="anonymous"></script>
</body>

</html>