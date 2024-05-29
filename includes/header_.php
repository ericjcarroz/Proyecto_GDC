<?php 

if(empty($_SESSION['active']))
{
	header('location: ../index.php');
}
?>
<nav class="main-nav shadow  navbar has-background-red-1 is-fixed-top  " role="navigation" aria-label="main navigation" style="">
	<!--<div class="container"> -->
		<div class="navbar-brand navbar-start">
			<a class="navbar-item" href="index.php" >
				<img src="../img/gdc-rbg.png" alt="">
				<b class="has-text-grey-lighter has-text-weight-bold is-bold is-size-6 is-text"><!--<i class="fas fa-car-crash"></i>-->EL GALPÓN DEL CAUCHO</b>
			</a>

			<a role="button" class="navbar-burger burger" aria-label="menu" aria-expanded="false" data-target="navbarBasicExample">
				<span aria-hidden="true"></span>
				<span aria-hidden="true"></span>
				<span aria-hidden="true"></span>
			</a>
		</div>

		<!--<div id="navbarBasicExample" class="navbar-menu">
			<div class="navbar-end">
				<a class="navbar-item r" href="../index.php">
					Inicio
				</a>

				
				
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

				

				
				<a class="navbar-item" href="../vista/lista_producto.php">
					Lista de Productos
				</a>


				
				


				
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

				</div>-->

				<div class="navbar-item has-dropdown is-hoverable">
					<a href="#" class="navbar-link has-text-weight-bold has-text-light"><!--Usuario: --> <?php echo $_SESSION['user'].' -'.$_SESSION['rol']; ?></a>
					<div class="navbar-dropdown">
						
						<a href="../config/salir.php" class="navbar-item has-text-primary has-text-weight-bold">Salir</a>
					</div>
				</div>


			</div>
			<!--</div>-->



		</div>

		<div class="modal">
			<div class="bodyModal">
			</div>
		</div>

	</div>
</div>
</nav>

<!-- Sidebar here-->



