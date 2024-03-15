$(document).ready(function() {
   
    $.ajax({
        url: '../controller/datosController.php', // El archivo PHP que obtiene los datos del modelo
        type: 'GET',
        dataType: 'json',
        success: function(data) {
           
            $('#cuerpo-tabla').empty();

     
            $.each(data, function(index, empleado) {
                $('#cuerpo-tabla').append(`
                    <tr>
                        <td>${empleado.EMPLOYEE_ID}</td>
                        <td>${empleado.FIRST_NAME}</td>
                        <td>${empleado.LAST_NAME}</td>
                        <td>${empleado.EMAIL}</td>
                        <td>${empleado.PHONE_NUMBER}</td>
                        <td>${empleado.HIRE_DATE}</td>
                        <td>${empleado.JOB_ID}</td>
                        <td>${empleado.SALARY}</td>
                        <td>${empleado.COMMISSION_PCT}</td>
                        <td>${empleado.MANAGER_ID}</td>
                        <td>${empleado.DEPARTMENT_ID}</td>
                    </tr>
                `);
            });
        },
        error: function(xhr, status, error) {
            console.error('Error al obtener los datos:', error);
        }
    });
});