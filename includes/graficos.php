<?php 
include "../config/conexion.php";

//GRAFICA CHARTJS BARRAS
$sql_ = mysqli_query($conection,"SET lc_time_names = 'es_ES';");
$sql = "SELECT fecha as mes, totalfactura as total_registro from factura f GROUP BY mes ORDER BY mes DESC limit 0 , 15"; // Consulta SQL
$query = $conection->query($sql); // Ejecutar la consulta SQL
$data = array(); // Array donde vamos a guardar los datos
while($r = $query->fetch_object()){ // Recorrer los resultados de Ejecutar la consulta SQL
    $data[]=$r; // Guardar los resultados en la variable $data
}
//GRÁFICA CHARTJS BARRAS 2


$sql_4 = "SELECT MONTHNAME(f.fecha) as mes, sum(f.totalfactura) as total FROM factura f WHERE YEAR(f.fecha) = '2020' GROUP BY mes";
$query = $conection->query($sql_4);
$data4 = array();
while($r = $query->fetch_object()){ // Recorrer los resultados de Ejecutar la consulta SQL
    $data4[]=$r; // Guardar los resultados en la variable $data
}

$sql_eric = "SELECT MONTHNAME(f.fecha) as mes_nombre, MONTH(f.fecha) as mes_numero, sum(f.totalfactura) as total FROM factura f WHERE YEAR(f.fecha) = '2020' GROUP BY mes_numero";
$query = $conection->query($sql_eric);
$data_eric = array();
while($r = $query->fetch_object()){ // Recorrer los resultados de Ejecutar la consulta SQL
    $data_eric[]=$r; // Guardar los resultados en la variable $data
}

//GRAFICA CHARTJS DOUGHNUT
$sql = "SELECT MONTHNAME(f.fecha) as mes_nombre, MONTH(f.fecha) as mes_numero, COUNT(*) as total_registro FROM factura f WHERE YEAR(f.fecha) = '2020' GROUP BY mes_numero"; // Consulta SQL
$query = $conection->query($sql); // Ejecutar la consulta SQL

$data2 = array(); // Array donde vamos a guardar los datos
while($r = $query->fetch_object()){ // Recorrer los resultados de Ejecutar la consulta SQL
    $data2[]=$r; // Guardar los resultados en la variable $data
}
//GRAFICA CHARTJS BARRAS
$sql = "SELECT MONTHNAME(f.fecha) as mes, SUM(totalfactura) as total FROM factura f WHERE YEAR(f.fecha) = '2020' GROUP BY mes  "; // Consulta SQL
$query = $conection->query($sql); // Ejecutar la consulta SQL

$data3 = array(); // Array donde vamos a guardar los datos
while($r = $query->fetch_object()){ // Recorrer los resultados de Ejecutar la consulta SQL
    $data3[]=$r; // Guardar los resultados en la variable $data
}
//LISTADO USUARIOS
$sql_registe = mysqli_query($conection,"SELECT COUNT(*) as total_registro FROM usuario WHERE estatus = 1 ");
$result_register = mysqli_fetch_array($sql_registe);
$total_registro = $result_register['total_registro'];
//LISTADO CLIENTES
$sql_registe = mysqli_query($conection,"SELECT COUNT(*) as total_registro FROM cliente WHERE estatus = 1 ");
$result_register_cliente = mysqli_fetch_array($sql_registe);
$total_registro = $result_register_cliente['total_registro'];
//NUMERO DE VENTAS
$sql_registe = mysqli_query($conection,"SELECT COUNT(*) as total_registro FROM factura WHERE estatus != 2 ");
$result_register_venta = mysqli_fetch_array($sql_registe);
$total_registro = $result_register_venta['total_registro'];
//INGRESOS TOTALES DE LAS VENTAS
$sql_total_venta = mysqli_query($conection,"SELECT SUM(totalfactura) as total_venta FROM factura");
$result_registrar_totalventa = mysqli_fetch_array($sql_total_venta);
$total_registro_venta = $result_registrar_totalventa['total_venta'];
//Ingresos mensuales de las ventas
$sql_ = mysqli_query($conection,"SET lc_time_names = 'es_ES';");
$sql_mes = mysqli_query($conection,"SELECT MONTHNAME(f.fecha) as mes_nombre, MONTH(f.fecha) as mes_numero, SUM(f.totalfactura) as total FROM factura f WHERE YEAR(f.fecha) = '2020' GROUP BY mes_numero DESC");
$result_venta_mes = mysqli_fetch_array($sql_mes);
$mes_actual = $result_venta_mes['mes_nombre'];
$venta_x_mes = $result_venta_mes['total']; 
//NUMERO DE VENTAS AL MES
$sql_vm = mysqli_query($conection,"SET lc_time_names = 'es_ES';");
//$sqlvm = mysqli_query($conection,"SELECT UPPER(LEFT(mes,1))+LOWER(SUBSTRING(mes,2,LEN(mes))) FROM factura");
$sql_mes2 = mysqli_query($conection," SELECT MONTHNAME(f.fecha) as mes_nombre, MONTH(f.fecha) as mes_numero, COUNT(*) as total_registro FROM factura f WHERE YEAR(f.fecha) = '2020' GROUP BY mes_numero DESC");
$result_vm = mysqli_fetch_array($sql_mes2);


$mes_actual2 = $result_vm['mes_nombre'];
$venta_x_mes2 = $result_vm['total_registro'];


//Numero de factura al mes
$sql_fm = mysqli_query($conection,"SELECT COUNT(*) as total_registro FROM factura WHERE estatus != 10");
$result_fm = mysqli_fetch_array($sql_fm);
$factura_mes = $result_fm['total_registro'];



//VENTAS AL MES 23-09-2020
$sql_ventam = mysqli_query($conection,"SELECT SUM(f.totalfactura) AS Total,
		MONTHNAME(f.fecha) AS Mes
FROM factura f 
GROUP BY Mes DESC");
$resultado_ventam = mysqli_fetch_array($sql_ventam);
$venta_m = $resultado_ventam['Mes'];
$venta_m2 = $resultado_ventam['Total'];



//SELECT MONTHNAME(f.fecha) as mes, totalfactura as total from factura f

$sql_mas_vendido = "SELECT p.codproducto, p.descripcion, SUM(df.cantidad) as total FROM producto p INNER JOIN detallefactura df ON df.codproducto = p.codproducto GROUP BY descripcion DESC LIMIT 0,3 ";
$query = $conection->query($sql_mas_vendido);

$data_mv = array();

while ($r = $query->fetch_object()) {
	$data_mv[]=$r;

}


	

?>