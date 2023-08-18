

$(document).ready(function () {
    

   

    $('#liHistorial').click(function(event) {
        event.preventDefault(); // Evita que el enlace realice su acción por defecto
        $('#divPrincipal').hide(); 
        $('#divHistorial').show(); 
        consultarHistorialCuestionario();
    });

    $('#liCuestionario').click(function(event) {
        event.preventDefault(); // Evita que el enlace realice su acción por defecto
        $('#divHistorial').hide(); 
        $('#divPrincipal').show(); 
 
    });

    $('#btnSalir').click(function(event) {
        var confirmacion = confirm("¿Desea salir de la aplicación?");
        if (confirmacion) {
          cerrarSession();
        }
    });



    let tiempoTotal; 
    let tiempoRestante;
    let intervalo;

    function actualizarTemporizador() {
        let minutos = Math.floor(tiempoRestante / 60);
        let segundos = tiempoRestante % 60;
        $('#tiempoRestante').text("Tiempo restante: "+minutos + ":" + (segundos < 10 ? "0" : "") + segundos).
        css({
            
            'font-weight': 'bold',
            'color': '#9f0e3f',
            'border': '2px solid #d9534f',
            'padding': '10px 20px',
            'border-radius': '5px',
            'background-color': '#f9f9f9',
            'box-shadow': '0 4px 8px rgba(0, 0, 0, 0.1)',
            'margin': '10px 0',
            'display': 'inline-block'
        });
    }

    cargarCuestionarios();



    $('#divCuestionarios').on('click', '.btnIniciar', function() {
        var idCuestionario = $(this).data('id_cuestionario');
        tiempoRestante = $(this).data('tiempo_limite') * 60; 
        tiempoTotal = tiempoRestante;
        cargarPreguntas(idCuestionario);


        // Oculta todos los divs de cuestionario
        $('.card').hide();

        // Encuentra el div del cuestionario específico y muéstralo
        var cuestionarioDiv = $(this).closest('.card');
        cuestionarioDiv.show();


        // Modifica los botones dentro de ese div específico
        cuestionarioDiv.find(".btnEnviar").show();
        $(this).prop('disabled', true); // Desactiva el botón que fue presionado
        cuestionarioDiv.find(".btnCancelar").show();

        intervalo = setInterval(function() {
            tiempoRestante--;
            actualizarTemporizador();

            if (tiempoRestante <= 0) {
                clearInterval(intervalo);
                alert('El tiempo ha terminado!');
                

                cuestionarioDiv.find(".btnIniciar").prop('disabled', false);
                cuestionarioDiv.find(".btnEnviar").hide();
                cuestionarioDiv.find(".btnCancelar").hide();
                $("#tiempoRestante").html('')
                .removeAttr('style');
                obtenerRespuestas(true);
                $("#divPreguntas").html('');
                cargarCuestionarios();
            }
        }, 1000);

        actualizarTemporizador();
        
    });


  


    $('#divCuestionarios').on('click', '.btnEnviar', function() {
       
        if(obtenerRespuestas()){
            clearInterval(intervalo); 
            tiempoRestante = 0; 
            actualizarTemporizador(); 
            $("#tiempoRestante").html('')
            .removeAttr('style');
        }
        

        
    });


    $('#divCuestionarios').on('click', '.btnCancelar', function() {
        $("#divPreguntas").html('');
        var cuestionarioDiv = $(this).closest('.card');
        cuestionarioDiv.find(".btnIniciar").prop('disabled', false);
        cuestionarioDiv.find(".btnEnviar").hide();
        cuestionarioDiv.find(".btnCancelar").hide();

       

        cargarCuestionarios();
        clearInterval(intervalo); 
        tiempoRestante = 0; 
        actualizarTemporizador(); 
        $("#tiempoRestante").html('')
        .removeAttr('style'); 
      
    });



});


function cargarPreguntas(idCuestionario) {
    $.ajax({
      url: "../Controlador/CuestionarioControlador.php",
      data: { accion: "mostrarPreguntas", idCuestionario:idCuestionario},
      type: "post",
      dataType: "json",
      cache: false,
      success: function (json) {
        if (json.datos != null) {

            let preguntasAgrupadas = {};
            let contador = 1;

          
           
            // Agrupar opciones por pregunta
            $.each(json.datos, function(index, item) {
                if (!preguntasAgrupadas[item.id_preguntas]) {
                    preguntasAgrupadas[item.id_preguntas] = {
                        contenido: item.contenido,
                        tipo: item.tipo_pregunta,
                        idCuestionario: item.id_cuestionarios,
                        opciones: []
                    };
                }
                preguntasAgrupadas[item.id_preguntas].opciones.push(
                    {contenido:item.opcion,idOpcion:item.id_opciones}
                    );
            });

            //
            $.each(preguntasAgrupadas, function(id, pregunta) {
                let opcionesHtml = pregunta.opciones.map(opcion => {
                    if (pregunta.tipo === 'UNICA') {
                        return `
                        <div class="form-check">
                            <input class="form-check-input" data-id_opcion="${opcion.idOpcion}" type="radio" name="pregunta${id}" value="${opcion.idOpcion}" id="opcion${opcion.idOpcion}">
                            <label class="form-check-label" for="opcion${opcion.idOpcion}">
                                ${opcion.contenido}
                            </label>
                        </div>
                    `;
                    }else{
                        return `
                        <div class="form-check">
                            <input class="form-check-input" data-id_opcion="${opcion.idOpcion}" type="checkbox" value="${opcion.idOpcion}" id="opcion${opcion.idOpcion}">
                            <label class="form-check-label" for="opcion${opcion.idOpcion}">
                                ${opcion.contenido}
                            </label>
                        </div>
                    `;
                    }
                }).join('');
                let card = `
                    <div class="card mb-3 pregunta"  data-id_cuestionario="${pregunta.idCuestionario}" data-indice="${contador}"  data-tipo="${pregunta.tipo}" data-id_pregunta="${id}">
                        <div class="card-body">
                            <h5 class="card-title">Pregunta # ${contador}</h5>
                            <p class="card-text " >${pregunta.contenido}</p>
                            <ul>${opcionesHtml}</ul>
                        </div>
                    </div>
                `;
                contador++;
                $('#divPreguntas').append(card);
            });
        }
      },
      error: function (ex) {
        console.log(ex.responseText);
      },
    });
}


function enviarCuestionario(data){
    $.ajax({
        url: "../Controlador/HistorialCuestionarioControlador.php",
        type: "POST",
        data: {
          accion: "adicionar",
          respuestas: JSON.stringify(data)
        },
        dataType: "json",
        success: function (json) {
            mostrarResultados(json);

            $("#divPreguntas").html('');
            cargarCuestionarios();
            envioCuestionario = true;
        },
        error: function () {
          console.log("Error al guardar");
        },
      });
  }

function obtenerRespuestas(tiempoFinalizado = false) {
    let respuestas = [];
    let validacionExitosa = true;

    $('.pregunta').each(function() {
        let tipoPregunta = $(this).data('tipo');
        let idPregunta = $(this).data('id_pregunta');
        let idCuestionario = $(this).data('id_cuestionario');
        let indicePregunta = $(this).data('indice');
        let opcionesSeleccionadas = 0;

        $(this).find('input[type="checkbox"], input[type="radio"]').each(function() {
            let idOpcion = $(this).data('id_opcion');
            let seleccionado = $(this).prop('checked');

            if (seleccionado) {
                opcionesSeleccionadas++;
            }

            if(seleccionado){
                respuestas.push({
                    idCuestionario:idCuestionario,
                    idPregunta: idPregunta,
                    idOpcion: idOpcion,
                    seleccionado: seleccionado
                });
            }
           
        });

        if(tiempoFinalizado === false){
            if ((tipoPregunta === 'UNICA' && opcionesSeleccionadas !== 1) || (tipoPregunta === 'MULTIPLE' && opcionesSeleccionadas === 0)) {
                alert('Por favor, selecciona al menos una opción para la pregunta ' + indicePregunta);
                validacionExitosa = false;
                return false; 
            }
        }
       
    });

    if (validacionExitosa || tiempoFinalizado === true) {
        //console.log(respuestas);
        enviarCuestionario(respuestas);
    }
    return validacionExitosa;
}

function mostrarResultados(data) {
    // Llenar la lista de respuestas correctas
    $('#listaRespuestasCorrectas').empty();
    data.repuestasCorrectas.forEach(item => {
        let respuestas = item.respuestas_correctas.map(r => r.contenido).join(', ');
        $('#listaRespuestasCorrectas').append(`<li><strong>${item.pregunta}</strong>: ${respuestas}</li>`);
    });
    $("#resultadoModalLabel").text( `Resultado del Cuestionario: ${data.repuestasCorrectas[0].tituloCuestionario}`);
    // Mostrar el puntaje final
    $('#puntajeFinal').text(`Tu puntaje es: ${data.puntaje}`);

    // Mostrar el modal
    $('#resultadoModal').modal('show');
}

function cargarCuestionarios(){
    $.ajax({
        url: "../Controlador/CuestionarioControlador.php",
        type: "POST",
        data: {
          accion: "mostrarCuestionarios"
        },
        dataType: "json",
        success: function (json) {
            let html = '';
            if (json.datos && json.datos.length > 0) {
                $.each(json.datos, function(index, cuestionario) {
                    html += '<div class="card mt-5">';
                    html += '  <div class="card-body">';
                    html += '    <h5 class="card-title">' + cuestionario.titulo + '</h5>';
                    html +=      cuestionario.descripcion;
                    html += '  </div>';
                    html += '  <div class="card-footer">';
                    html += '    <button type="button"  data-tiempo_limite="' + cuestionario.tiempo_limite + '"  data-id_cuestionario="' + cuestionario.id_cuestionarios + '"  class="btn btn-primary btnIniciar">Empezar</button>';
                    html += '    <button type="button"   style="display: none;" data-id_cuestionario="' + cuestionario.id_cuestionarios + '" class="btn btn-primary btnEnviar">Enviar cuestionario</button>';
                    html += '    <button type="button"   style="display: none;"  data-id_cuestionario="' + cuestionario.id_cuestionarios + '" class="btn btn-danger btnCancelar">Cancelar cuestionario</button>';
                    html += '  </div>';
                    html += '</div>';
                });
            } else {
                html = '<p>No hay cuestionarios disponibles.</p>';
            }
            $("#spnUsuario").html('usuario: '+json.usuario);
            $('#divCuestionarios').html(html);
        },
        error: function () {
          console.log("Error al mostrar");
        },
      });
}



function consultarHistorialCuestionario(){
    $.ajax({
        url: "../Controlador/HistorialCuestionarioControlador.php",
        type: "POST",
        data: {
          accion: "mostrar"
        },
        dataType: "json",
        success: function (json) {
            if(json.datos != null){
                $('#tblHistorialCuestionario').html('');
                
                var tabla = $('<table>').addClass('table table-striped');
                var thead = $('<thead >');
                var tbody = $('<tbody>');
                var encabezados = ['Puntaje', 'Cuestionario', 'Nombre usuario', 'Fecha creación'];
            
                // Agregar encabezados
                var filaEncabezado = $('<tr>');
                $.each(encabezados, function(index, encabezado) {
                    filaEncabezado.append($('<th>').text(encabezado));
                });
                thead.append(filaEncabezado);
                tabla.append(thead);
                $.each(json.datos, function(index, item) {
                    var fila = $('<tr>');
                    fila.append($('<td>').text(item.puntaje));
                    fila.append($('<td>').text(item.titulo));
                    fila.append($('<td>').text(item.nombre));
                    fila.append($('<td>').text(item.fecha_creacion));
                    tbody.append(fila);
                });
            
                tabla.append(tbody);
                $('#tblHistorialCuestionario').html(tabla);
                $('#tblHistorialCuestionario th').css({
                    'background-color': '#1c2544',
                    'font-weight' :'bold',
                    'color': '#ffff'
                });
            }
         
        },
        error: function () {
          console.log("Error al guardar");
        },
      });
  }

  function cerrarSession(){
    $.ajax({
        url: "../Controlador/CierreSesionControlador.php",
        type: "POST",
        data: {},
        dataType: "json",
        success: function (json) {
          window.location.href = json.datos.rutaLogin;
        },
        error: function () {
          console.log("Error al cerrar session");
        },
      });
  }

