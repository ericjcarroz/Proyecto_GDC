<?php 

if(empty($_SESSION['active']))
{
	header('location: ../');
}
?>


<nav class="navbar has-background-red-1 is-clearfix is-fixed-top   " id="navbar"  role="navigation" aria-label="main navigation" style="border: 1px solid #c0c0c0;">
	<!--<div class="container">-->
		<div class="navbar-brand navbar-start" style="">

			<a class="navbar-item" href="index.php"  style="">
				<img src="../img/gdc-rbg.png" alt="">
				<b class="has-text-grey-lighter has-text-weight-bold is-size-6 is-text" style=""><!--<i class="fas fa-car-crash"></i>-->EL GALPÓN DEL CAUCHO</b>
			</a>
			

			<a role="button" class="navbar-burger has-background-grey burger" aria-label="menu" aria-expanded="false" data-target="navbarBasicExample">
				<span aria-hidden="true"></span>
				<span aria-hidden="true"></span>
				<span aria-hidden="true"></span>
			</a>
		</div>

		<div id="navbarBasicExample" class="navbar-menu">
			<!--<div class="navbar-end">
				<a class="navbar-item r"" href="../index.php">
					Inicio
				</a>

				<?php 
				if($_SESSION['rol'] == 1){



					?>

					<div class="navbar-item has-dropdown is-hoverable">
						<a class="navbar-link" >
							Usuarios
						</a>

						<div class="navbar-dropdown">
							<a class="navbar-item" href="../vista/registro_usuario.php">
								Nuevo Usuario
							</a>
							<a class="navbar-item" href="../vista/lista_usuarios2.php">
								Lista de Usuarios
							</a>
						<?php }  ?>

					</div>
				</div>
				<?php
				if($_SESSION['rol'] == 1 || $_SESSION['rol'] == 2 ){
					?>
					<div class="navbar-item has-dropdown is-hoverable is-left">
						<a class="navbar-link">
							Proveedores
						</a>

						<div class="navbar-dropdown">
							<a class="navbar-item" href="../vista/registro_proveedor.php">
								Nuevo Proveedor
							</a>
							<a class="navbar-item" href="../vista/lista_proveedor.php">
								Lista de proveedores
							</a>
						<?php } ?>
					</div>
				</div>

				<div class="navbar-item has-dropdown is-hoverable r">
					<a class="navbar-link r">
						Clientes
					</a>

					<div class="navbar-dropdown">
						<a class="navbar-item" href="../vista/registro_cliente.php">
							Nuevo Cliente
						</a>
						<a class="navbar-item" href="../vista/lista_clientes.php">
							Lista de Clientes
						</a>
					</div>
				</div>

				<?php
				if($_SESSION['rol'] == 1 || $_SESSION['rol'] == 2 ){
					?>
					<div class="navbar-item has-dropdown is-hoverable">
						<a class="navbar-link">
							Productos
						</a>

						<div class="navbar-dropdown" >
							<a class="navbar-item" href="../vista/registro_producto.php">
								Nuevo Producto
							</a>
						<?php } ?>
						<a class="navbar-item" href="../vista/lista_producto.php">
							Lista de Productos
						</a>


					</div>
				</div>

				<div class="navbar-item has-dropdown is-hoverable">
					<a class="navbar-link">
						Ventas
					</a>

					<div class="navbar-dropdown">
						<a class="navbar-item" href="../vista/nueva_venta.php">
							Nueva Venta 
						</a>
						<a class="navbar-item" href="../vista/ventas.php">
							Lista de Ventas
						</a>

					</div>

				</div>
			-->
			<div class="navbar-end navbar-item has-dropdown is-hoverable ">
				<a href="#" class="navbar-link has-text-light has-text-weight-bold"><!--Usuario: --> <?php echo $_SESSION['user'].' -'.$_SESSION['rol']; ?></a>
				<div class="navbar-dropdown">
					
					<a href="../config/salir.php" class="navbar-item has-text-danger has-text-weight-bold">Salir</a>
					
				</div>

			</div>




		</div>


	</div>
	<!--</div>-->
</nav>

<!-- Sidebar here-->



<div class="modal">
	<div class="bodyModal">
		
	</div>
</div>


<!--<script type="text/javascript">
	$('.navbar-burger').click(function() {
		$('#navbarBasicExample, .navbar-burger').toggleClass('is-active');
	});
</script>-->

<script>	


</script>





