$(document).ready(function(){

    //--------------------- SELECCIONAR FOTO PRODUCTO ---------------------
    $("#foto").on("change",function(){
    	var uploadFoto = document.getElementById("foto").value;
        var foto       = document.getElementById("foto").files;
        var nav = window.URL || window.webkitURL;
        var contactAlert = document.getElementById('form_alert');
        
        if(uploadFoto !='')
        {
            var type = foto[0].type;
            var name = foto[0].name;
            if(type != 'image/jpeg' && type != 'image/jpg' && type != 'image/png')
            {
                contactAlert.innerHTML = '<p class="errorArchivo">El archivo no es válido.</p>';                        
                $("#img").remove();
                $(".delPhoto").addClass('notBlock');
                $('#foto').val('');
                return false;
            }else{  
                contactAlert.innerHTML='';
                $("#img").remove();
                $(".delPhoto").removeClass('notBlock');
                var objeto_url = nav.createObjectURL(this.files[0]);
                $(".prevPhoto").append("<img id='img' src="+objeto_url+">");
                $(".upimg label").remove();

            }
        }else{
         alert("No selecciono foto");
         $("#img").remove();
     }              
 });

    $('.delPhoto').click(function(){
    	$('#foto').val('');
    	$(".delPhoto").addClass('notBlock');
    	$("#img").remove();

        if ($("#foto_actual") && $("#foto_remove")) {
            $("#foto_remove").val('img_producto.png');
        }

    });

    // Modal Form ADD PRODUCT

    $('.add_product').click(function(e){
        e.preventDefault();
        var producto = $(this).attr('product');
        var action = 'infoProducto';

        $.ajax({
            url: '../includes/ajax.php',
            type: 'POST',
            async: true,
            data: {action:action,producto:producto},

            success: function(response){
                console.log(response);

                if (response != 'error') {

                    var info = JSON.parse(response);
                    console.log(info);

                    //$('#producto_id').val(info.codproducto);
                    //$('.nameProducto').html(info.descripcion);

                    $('.bodyModal').html('<form action="" class="" method="POST" name="form_add_product" id="form_add_product" onsubmit="event.preventDefault(); EnviarProducto(); ">'+
                        '<h1 class="title">Agregar Producto</h1>'+
                        '<h2 class="nameProducto title has-text-link">'+info.descripcion+'</h2><br>'+
                        '<div class="field">'+
                        '<label class="label" for="foto">cantidad</label>'+
                        '<input type="number" class="input is-black" name="cantidad" id="txtCantidad" placeholder="Cantidad del producto" required><br>'+
                        '</div>'+
                        '<label for="precio" class="label">Precio del Producto</label>'+
                        '<input type="text" class="input is-black" name="precio" id="txtPrecio" placeholder="Precio del producto" required><br>'+
                        '<input type="hidden" name="producto_id" id="producto_id" value="'+info.codproducto+'" required>'+
                        '<input type="hidden" name="action" value="addProduct" required>'+
                        '<br>'+
                        '<div class="alert alertAddProduct"></div>'+
                        '<button type="submit" class="btn_new button is-success">Agregar</button>'+
                        '<a href="#" class="btn_ok button is-rounded closeModal" onclick="coloseModal();">Cerrar</a>'+
                        '</form>'
                        );
                }
            },

            error: function(error){
                console.log(error);
            }

        });







        $('.modal').fadeIn();
    });

    $('.del_product').click(function(e){
        e.preventDefault();
        var producto = $(this).attr('product');
        var action = 'infoProducto';

        $.ajax({
            url: '../includes/ajax.php',
            type: 'POST',
            async: true,
            data: {action:action,producto:producto},

            success: function(response){
                console.log(response);

                if (response != 'error') {

                    var info = JSON.parse(response);
                    console.log(info);

                    //$('#producto_id').val(info.codproducto);
                    //$('.nameProducto').html(info.descripcion);

                    $('.bodyModal').html('<form action="" method="POST" name="form_del_product" id="form_del_product" onsubmit="event.preventDefault(); EliminarProducto(); ">'+
                        '<h1 class="title">Eliminar Producto</h1>'+

                        '<p class="subtitle">¿Está seguro de eliminar el siguiente registro?</p>'+



                        '<h2 class="nameProducto title has-text-success">'+info.descripcion+'</h2><br>'+
               
                        '<input type="hidden" name="producto_id" id="producto_id" value="'+info.codproducto+'" required>'+
                        '<input type="hidden" name="action" value="delProduct" required>'+
                        '<div class="alert alertAddProduct"></div>'+
                        '<div class="level is-centered">'+
                        '<a href="#" class="btn_cancel button is-link" onclick="coloseModal();">Cerrar</a>'+
                        '<input type="submit" value="Eliminar" class="btn_ok button is-primary">'+
                        '</div>'+

                        '</form>');
                }
            },

            error: function(error){
                console.log(error);
            }

        });







        $('.modal').fadeIn();
    });

    $('#search_proveedor').change(function(e){
        e.preventDefault();
        var procesos = getUrl();
        
        location.href = procesos+'../procesos/buscar_productos.php?proveedor='+$(this).val();
    });

    //Activar campos para registrar cliente
    $('.btn_new_cliente').click(function(e){
        e.preventDefault();
        $('#nom_cliente').removeAttr('disabled');
        $('#tel_cliente').removeAttr('disabled');
        $('#dir_cliente').removeAttr('disabled');

        $('#div_registro_cliente').slideDown();
    });

    // Buscar Cliente
    $('#cedula_cliente').keyup(function(e){
        e.preventDefault();

        var cl = $(this).val();
        var action = 'searchCliente';

        $.ajax({
            url: '../includes/ajax.php',
            type: "POST",
            async: true,
            data: {action:action,cliente:cl},

            success: function(response)
            {


                if (response == 0) {
                    $('#idcliente').val('');
                    $('#nom_cliente').val('');
                    $('#tel_cliente').val('');
                    $('#dir_cliente').val('');
                        //Mostrar boton agregar
                        $('.btn_new_cliente').slideDown();
                    }else{
                        var data = $.parseJSON(response);
                        $('#idcliente').val(data.idcliente);
                        $('#nom_cliente').val(data.nombre);
                        $('#tel_cliente').val(data.telefono);
                        $('#dir_cliente').val(data.direccion);
                    //Ocultar boton agregar
                    $('.btn_new_cliente').slideUp();

                    //Bloque campos
                    $('#nom_cliente').attr('disabled','disabled');
                    $('#tel_cliente').attr('disabled','disabled');
                    $('#dir_cliente').attr('disabled','disabled');

                    //Oculta boton guardar
                    $('#div_registro_cliente').slideUp();
                }
            },
            error: function(error) {

            }
        });
    });

    //Crear Cliente - Ventas
    $('#form_new_cliente_venta').submit(function(e){
        e.preventDefault();

        $.ajax({
            url: '../includes/ajax.php',
            type: "POST",
            async: true,
            data: $('#form_new_cliente_venta').serialize(),

            success: function(response)
            {

                if (response != 'error') {
                    //Agregar id a input hidden
                    $('#idcliente').val(response);
                    //Bloquear campos
                    $('#nom_cliente').attr('disabled','disabled');
                    $('#tel_cliente').attr('disabled','disabled');
                    $('#dir_cliente').attr('disabled','disabled');

                    //Oculta boton agregar
                    $('.btn_new_cliente').slideUp();
                    //Oculta boton guardar
                    $('#div_registro_cliente').slideUp();
                }
                
                
            },
            error: function(error) {
            }
        });
    });

    //Buscar producto - Ventas
    $('#txt_cod_producto').keyup(function(e){
        e.preventDefault();

        var producto = $(this).val();
        var action = 'infoProducto';

        if (producto != '') {

            $.ajax({
                url: '../includes/ajax.php',
                type: "POST",
                async: true,
                data: {action:action,producto:producto},

                success: function(response)
                {

                    if(response != 'error'){

                        var info = JSON.parse(response);
                        $('#txt_descripcion').html(info.descripcion);
                        $('#txt_existencia').html(info.existencia);
                        $('#txt_modelo').html(info.modelo);
                        $('#txt_cant_producto').val('1');
                        $('#txt_precio').html(info.precio);
                        $('#txt_precio_total').html(info.precio);

                        //Activar cantidad
                        $('#txt_cant_producto').removeAttr('disabled');

                        //Mostrar botón agregar
                        $('#add_product_venta').slideDown();
                    }else{
                        $('#txt_descripcion').html('-');
                        $('#txt_existencia').html('-');
                        $('#txt_cant_producto').val('0');
                        $('#txt_precio').html('0.00');
                        $('#txt_precio_total').html('0.00');

                        //Bloquear Cantidad
                        $('#txt_cant_producto').attr('disabled','disabled');

                        //Ocultar botón agregar
                        $('#add_product_venta').slideUp();
                    }

                },
                error: function(error) {
                }
            });
            
        }

    });

    //Validar Cantidad del producto antes de agregar
    $('#txt_cant_producto').keyup(function(e){
        e.preventDefault();
        var precio_total = $(this).val() * $('#txt_precio').html();
        var existencia = parseInt($('#txt_existencia').html());
        $('#txt_precio_total').html(precio_total);

        //Oculta el boton agregar si la cantidad es menor que 1
        if (  ($(this).val() < 1  || isNaN($(this).val())) || ( $(this).val() > existencia) ) {
            $('#add_product_venta').slideUp();
        }else{
            $('#add_product_venta').slideDown();
        }
    });


    //Agregar Producto al detalle
    $('#add_product_venta').click(function(e){
        e.preventDefault();


        if ($('#txt_cant_producto').val() > 0) {

            var codproducto = $('#txt_cod_producto').val();
            var cantidad = $('#txt_cant_producto').val();
            var action = 'addProductoDetalle';

            $.ajax({
                url: '../includes/ajax.php',
                type: "POST",
                async: true,
                data: {action:action,producto:codproducto,cantidad:cantidad},

                success: function(response){

                   if (response != 'error') {

                    var info = JSON.parse(response);
                    $('#detalle_venta').html(info.detalle);
                    $('#detalle_totales').html(info.totales);

                    $('#txt_cod_producto').val('');
                    $('#txt_descripcion').html('-');
                    $('#txt_modelo').html('-');
                    $('#txt_existencia').html('-');
                    $('#txt_cant_producto').val('0');
                    $('#txt_precio').html('0.00');
                    $('#txt_precio_total').html('0.00');

                    //Bloquear Cantidad
                    $('#txt_cant_producto').attr('disabled','disabled');

                    //Ocultar boton agregar
                    $('#add_product_venta').slideUp();

                }else{
                    console.log('no-data');
                }
                viewProcesar();
            },
            error: function(error){

            }
        });
        }
    });


//Anular Venta
$('#btn_anular_venta').click(function(e){
    e.preventDefault();

    var rows = $('#detalle_venta tr').length;

    if (rows > 0) {

        var action = 'anularVenta';

        $.ajax({
            url: '../includes/ajax.php',
            type: "POST",
            async: true,
            data: {action:action},

            success: function(response){

                if (response != 'error') {
                    location.reload();
                }
            },
            error: function(error){

            }
        });
    }
});

//Procesar/Facturar Venta
$('#btn_facturar_venta').click(function(e){
    e.preventDefault();

    var rows = $('#detalle_venta tr').length;

    if (rows > 0) {

        var action = 'procesarVenta';
        var codcliente = $('#idcliente').val();

        $.ajax({
            url: '../includes/ajax.php',
            type: "POST",
            async: true,
            data: {action:action,codcliente:codcliente},

            success: function(response){



                if (response != 'error') {

                    var info = JSON.parse(response);
                    //console.log(info);

                    generarPDF(info.codcliente,info.nofactura);

                    location.reload();
                }else{
                    console.log('no data');
                }
            },
            error: function(error){

            }
        });
    }
});
    //Modal From Anular Factura

    $('.anular_factura').click(function(e){
        e.preventDefault();
        var nofactura = $(this).attr('fac');
        var action = 'infoFactura';

        $.ajax({
            url: '../includes/ajax.php',
            type: 'POST',
            async: true,
            data: {action:action,nofactura:nofactura},

            success: function(response){
                console.log(response);

                if (response != 'error') {

                    var info = JSON.parse(response);
                    

                    

                    $('.bodyModal').html('<form action="" method="POST" name="form_anular_factura" id="form_anular_factura" onsubmit="event.preventDefault(); anularFactura(); ">'+
                        '<h1 class="title">Anular Factura</h1>'+

                        '<p class="subtitle">¿Realmente está seguro de anular la factura?</p>'+


                        '<p class="subtitle has-text-link">No.'+info.nofactura+'</p>'+
                        '<p class="subtitle has-text-link">Monto. $.'+info.totalfactura+'</p>'+
                        '<p class="subtitle has-text-link">Fecha.'+info.fecha+'</p>'+
                       '<input type="hidden" name="action" value="anularFactura" />'+
                       '<input type="hidden" name="no_factura" id="no_factura" value="'+info.nofactura+'" />'+
                        '<div class="alert alertAddProduct"></div>'+
                        '<div class="level is-centered">'+
                        '<a href="#" class="btn_cancel button is-link" onclick="coloseModal();">Cerrar</a>'+
                        '<input type="submit" value="Anular" class="btn_ok button is-primary">'+
                        '</div>'+

                        '</form>');
                }
            },

            error: function(error){
                console.log(error);
            }

        });







        $('.modal').fadeIn();
    });


    //Ver Factura
    $('.view_factura').click(function(e){
        e.preventDefault();
        //Creamos la variable codCliente y con this accedemos a ése elemento al darle click y con attr extraemos lo que tenga como valor el atributo cl
        var codCliente = $(this).attr('cl');
        var noFactura = $(this).attr('f');
        generarPDF(codCliente,noFactura);
    });


}); //End Ready


//Anular Factura 
function anularFactura(){
    var noFactura = $('#no_factura').val();
    var action = 'anularFactura';

    $.ajax({
        url: '../includes/ajax.php',
        type: "POST",
        async: true,
        data: {action:action,noFactura:noFactura},

        success: function(response)
        {
           if (response == 'error') {
            $('.alertAddProduct').html('<p class="has-text-primary">Error al anular la factura.</p>');

           }else{
                $('#row_'+noFactura+' .estado').html('<span class="has-text-primary">Anulada</span>');
                $('#form_anular_factura .btn_ok').remove();


                $('#row_'+noFactura+' .div_factura').html('<button type="button" class="button has-background-grey is-small has-text-white  ">ANULADA</button>');
                $('.alertAddProduct').html('<p class="has-text-centered  has-text-primary">Factura anulada.</p>');

           }
        },
        error: function(error){

        }
    });
}

//Funcion para generar Factura
function generarPDF(cliente,factura){
    var ancho = 1000;
    var alto = 800;
    //Calcular posicion x,y para centrar la ventana
    var x = parseInt((window.screen.width/2) - (ancho / 2));
    var y = parseInt((window.screen.height/2) - (alto / 2));

    $url = 'factura/generaFactura.php?cl='+cliente+'&f='+factura;
    window.open($url,"Factura","left="+x+",top="+y+",height="+alto+",width="+ancho+",scrollbar=si,location=no,resizable=si,menubar=no");

}

//Funcion para borrar productos del detalle temporal
function del_product_detalle(correlativo){
   var action = 'delProductoDetalle';
   var id_detalle = correlativo;

   $.ajax({
    url: '../includes/ajax.php',
    type: "POST",
    async: true,
    data: {action:action,id_detalle:id_detalle},

    success: function(response){

        if (response != 'error') {

            var info = JSON.parse(response);

            $('#detalle_venta').html(info.detalle);
            $('#detalle_totales').html(info.totales);

            $('#txt_cod_producto').val('');
            $('#txt_descripcion').html('-');
            $('#txt_existencia').html('-');
            $('#txt_cant_producto').val('0');
            $('#txt_precio').html('0.00');
            $('#txt_precio_total').html('0.00');

                    //Bloquear Cantidad
                    $('#txt_cant_producto').attr('disabled','disabled');

                    //Ocultar boton agregar
                    $('#add_product_venta').slideUp();

                }else{

                    $('#detalle_venta').html('');
                    $('#detalle_totales').html('');

                }
                viewProcesar();
            },
            error: function(error){

            }
        });
}

//Mostrar/Ocultar boton procesar
function viewProcesar(){
    if ($('#detalle_venta tr').length > 0) {

        $('#btn_facturar_venta').show();
    }else{
        $('#btn_facturar_venta').hide();
    }
}

function searchForDetalle(id){
    var action = 'searchForDetalle';
    var user = id;

    $.ajax({
        url: '../includes/ajax.php',
        type: "POST",
        async: true,
        data: {action:action,user:user},

        success: function(response){

            if (response != 'error') {

                var info = JSON.parse(response);
                $('#detalle_venta').html(info.detalle);
                $('#detalle_totales').html(info.totales);


            }else{
                console.log('no-data');
            }
            viewProcesar();
        },
        error: function(error){

        }
    });
}


function getUrl(){
    var loc = window.location;
    var pathName = loc.pathname.substring(0, loc.pathname.lastIndexOf('/') + 1);
    return loc.href.substring(0, loc.href.length - ((loc.pathname + loc.search + loc.hash).length - pathName.length));
}


function EnviarProducto(){

    $('.alertAddProduct').html('');

    $.ajax({
        url: '../includes/ajax.php',
        type: 'POST',
        async: true,
        data: $('#form_add_product').serialize(),

        success: function(response){
         if (response == 'error') {
            $('.alertAddProduct').html('<p style="color: red;">Error al agregar el producto</p>');
        }else{
            var info = JSON.parse(response);
            $('.row'+info.producto_id+' .celPrecio').html(info.nuevo_precio);
            $('.row'+info.producto_id+' .celExistencia').html(info.nueva_existencia);
            $('#txtCantidad').val('');
            $('#txtPrecio').val('');
            $('.alertAddProduct').html('<p>Producto guardado correctamente</p>');


        }



    },

    error: function(error){
        console.log(error);
    }

});

}

function EliminarProducto(){

    var pr = $('#producto_id').val();
    $('.alertAddProduct').html('');

    $.ajax({
        url: '../includes/ajax.php',
        type: 'POST',
        async: true,
        data: $('#form_del_product').serialize(),

        success: function(response){

            console.log(response);


            if (response == 'error') {
                $('.alertAddProduct').html('<p style="color: red;">Error al eliminar el producto</p>');
            }else{

                $('.row'+pr).remove();
                $('#form_del_product .btn_ok').remove();
                $('.alertAddProduct').html('<p >Producto eliminado correctamente</p>');


            }



        },

        error: function(error){
            console.log(error);
        }

    });

}

function coloseModal(){
    $('.alertAddProduct').html('');
    $('#txtCantidad').val('');
    $('#txtPrecio').val('');
    $('.modal').fadeOut();
}