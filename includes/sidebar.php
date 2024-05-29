
<div class="sidebar " style="">
  <div class="sidebar-menu has-background-grey-1" style="border-right: 1px solid #fff;">
    <aside class="menu ">
      <p class="menu-label "></p>
      <ul class="menu-list"><br>
        <li><a href="../vista/index.php" class="has-text-dark has-text-weight-bold is-bold ">Inicio</a></li>
        
        <li class="treeview">
          <?php 
        if($_SESSION['rol'] == 1){



          ?>
          <a class="has-text-black has-text-weight-bold">Usuarios<span class="is-pulled-right"><i class="fa fa-angle-left"></i></span></a>
          <ul class="treeview-menu">
            <li><a href="../vista/registro_usuario.php " class="has-text-black has-text-weight-bold">Registro Usuario</a></li>
            <li><a href="../vista/lista_usuarios2.php" class="has-text-black has-text-weight-bold">Lista de Usuarios</a></li>



          </ul>
        </li>
        <?php }  ?>
        <li class="treeview">
          <a class="has-text-black has-text-weight-bold">Proveedores<span class="is-pulled-right"><i class="fa fa-angle-left"></i></span></a>
          <ul class="treeview-menu">
            <li><a href="../vista/registro_proveedor.php" class="has-text-black  has-text-weight-bold">Registro Proveedor</a></li>
            <li><a href="../vista/lista_proveedor.php" class="has-text-black  has-text-weight-bold">Lista de Proveedores</a></li>

          </ul>
        </li>

        <li class="treeview">
          <a class="has-text-black has-text-weight-bold">Clientes<span class="is-pulled-right"><i class="fa fa-angle-left"></i></span></a>
          <ul class="treeview-menu">
            <li><a href="../vista/registro_cliente.php" class="has-text-black has-text-weight-bold">Registro Cliente</a></li>
            <li><a href="../vista/lista_clientes.php" class="has-text-black has-text-weight-bold">Lista de Clientes</a></li>

          </ul>
        </li>
        <li class="treeview">
          <a class="has-text-black has-text-weight-bold"">Categorias<span class="is-pulled-right"><i class="fa fa-angle-left"></i></span></a>
          <ul class="treeview-menu">
            <li><a href="../vista/registro_categoria.php" class="has-text-black has-text-weight-bold"">Registro Categoría</a></li>
            <li><a href="../vista/lista_categorias.php" class="has-text-black has-text-weight-bold"">Lista de Categorías</a></li>
          </ul>
        </li>

        <li class="treeview">
          <a class="has-text-black has-text-weight-bold"">Productos<span class="is-pulled-right"><i class="fa fa-angle-left"></i></span></a>
          <ul class="treeview-menu">
            <li><a href="../vista/registro_producto.php" class="has-text-black has-text-weight-bold"">Registro Producto</a></li>
            <li><a href="../vista/lista_producto.php" class="has-text-black has-text-weight-bold"">Lista de Productos</a></li>

          </ul>
        </li>


        <li class="treeview">
          <a class="has-text-black has-text-weight-bold">Ventas<span class="is-pulled-right "><i class="fa fa-angle-left"></i></span></a>
          <ul class="treeview-menu">
            <li><a href="../vista/nueva_venta.php" class="has-text-black has-text-weight-bold"">Nueva Venta</a></li>
            <li><a href="../vista/ventas.php" class="has-text-black has-text-weight-bold"">Lista de Ventas</a></li>

          </ul>
        </li>

        <li><a href="../vista/estadisticas.php" class="has-text-dark has-text-weight-bold is-bold ">Estadísticas</a></li>
         
      </li>

    </ul>
    

  </aside>
</div>
</div>

<script>    

  const navBurger = document.querySelector(".navbar-burger");
  const sidebar = document.querySelector(".sidebar");
  navBurger.addEventListener("click", function () {
    navBurger.classList.toggle("is-active");
    sidebar.classList.toggle("active");
  });


</script>