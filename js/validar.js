function soloLetras(e) {
	var key = e.keyCode || e.which,
	tecla = String.fromCharCode(key).toLowerCase(),
	letras = " áéíóúabcdefghijklmnñopqrstuvwxyz",
	especiales = [8, 37, 39, 46],
	tecla_especial = false;

	for (var i in especiales) {
		if (key == especiales[i]) {
			tecla_especial = true;
			break;
		}
	}

	if (letras.indexOf(tecla) == -1 && !tecla_especial) {
		return false;
	}
}  

function limpia() {
	var val = document.getElementById("miInput").value;
	var tam = val.length;
	for(i = 0; i < tam; i++) {
		if(!isNaN(val[i]))
			document.getElementById("miInput").value = '';
	}
}

 // Funcion para limitar el numero de caracteres de un textarea o input
        // Tiene que recibir el evento, valor y número máximo de caracteres
        function limitar(e, contenido, caracteres)
        {
            // obtenemos la tecla pulsada
            var unicode=e.keyCode? e.keyCode : e.charCode;

            // Permitimos las siguientes teclas:
            // 8 backspace
            // 46 suprimir
            // 13 enter
            // 9 tabulador
            // 37 izquierda
            // 39 derecha
            // 38 subir
            // 40 bajar
            if(unicode==8 || unicode==46 || unicode==13 || unicode==9 || unicode==37 || unicode==39 || unicode==38 || unicode==40)
            	return true;

            // Si ha superado el limite de caracteres devolvemos false
            if(contenido.length>=caracteres)
            	return false;

            return true;
        }