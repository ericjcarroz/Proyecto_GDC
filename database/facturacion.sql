-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 08-11-2020 a las 02:10:09
-- Versión del servidor: 10.3.16-MariaDB
-- Versión de PHP: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `facturacion`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_precio_producto` (`n_cantidad` INT, `n_precio` DECIMAL(10,2), `codigo` INT)  BEGIN
    	DECLARE nueva_existencia int;
        DECLARE nuevo_total decimal(10,2);
        DECLARE nuevo_precio decimal(10,2);
        
        DECLARE cant_actual int;
        DECLARE pre_actual decimal(10,2);
        
        DECLARE actual_existencia int;
        DECLARE actual_precio decimal(10,2);
        
        SELECT precio_existencia INTO actual_precio,actual_existencia FROM producto WHERE codproducto = codigo;
        
        SET nueva_existencia = actual_existencia + n_cantidad;
        SET nuevo_total = (actual_existencia * actual_precio) + (n_cantidad * n_precio);
        SET nuevo_precio = nuevo_total / nueva_existencia; 
        
        UPDATE producto SET existencia = nueva_existencia, precio = nuevo_precio WHERE codproducto = codigo;
        
        SELECT nueva_existencia,nuevo_precio;
        
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_precio_producto1` (`n_cantidad` INT, `n_precio` DECIMAL(10,2), `codigo` INT)  BEGIN
    	DECLARE nueva_existencia int;
        DECLARE nuevo_total  decimal(10,2);
        DECLARE nuevo_precio decimal(10,2);
        
        DECLARE cant_actual int;
        DECLARE pre_actual decimal(10,2);
        
        DECLARE actual_existencia int;
        DECLARE actual_precio decimal(10,2);
                
        SELECT precio,existencia INTO actual_precio,actual_existencia FROM producto WHERE codproducto = codigo;
        SET nueva_existencia = actual_existencia + n_cantidad;
        SET nuevo_total = (actual_existencia * actual_precio) + (n_cantidad * n_precio);
        SET nuevo_precio = nuevo_total / nueva_existencia;
        
        UPDATE producto SET existencia = nueva_existencia, precio = nuevo_precio WHERE codproducto = codigo;
        
        SELECT nueva_existencia,nuevo_precio;
        
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_detalle_temp` (IN `codigo` INT, IN `cantidad` INT, IN `token_user` VARCHAR(50))  BEGIN
    
    	DECLARE	precio_actual decimal(10,2);
        SELECT precio INTO precio_actual FROM producto WHERE codproducto = codigo;
        
        INSERT INTO detalle_temp(token_user,codproducto,cantidad,precio_venta) VALUES (token_user,codigo,cantidad,precio_actual);
        
        SELECT tmp.correlativo, tmp.codproducto,p.descripcion,tmp.cantidad,tmp.precio_venta FROM detalle_temp tmp
      	INNER JOIN producto p 
        ON tmp.codproducto = p.codproducto
        WHERE tmp.token_user = token_user;
        
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_detalle_temp1` (IN `add` INT)  NO SQL
BEGIN
    
    	DECLARE	precio_actual decimal(10,2);
        SELECT precio INTO precio_actual FROM producto WHERE codproducto = codigo;
        
        INSERT INTO detalle_temp(token_user,codproducto,modelo,cantidad,precio_venta) VALUES (token_user,codigo,modelo,cantidad,precio_actual);
        
        SELECT tmp.correlativo, tmp.codproducto,p.descripcion,p.modelo,tmp.cantidad,tmp.precio_venta FROM detalle_temp tmp
      	INNER JOIN producto p 
        ON tmp.codproducto = p.codproducto
        WHERE tmp.token_user = token_user;
        
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `anular_factura` (`no_factura` INT)  BEGIN
    	DECLARE existe_factura int;
        DECLARE registros int;
        DECLARE a int;
        
        DECLARE cod_producto int;
        DECLARE cant_producto int;
        DECLARE existencia_actual int;
        DECLARE nueva_existencia int;
        
    
    	SET existe_factura = (SELECT COUNT(*) FROM factura WHERE nofactura = no_factura and estatus = 1);
        IF existe_factura > 0 THEN
        	CREATE TEMPORARY TABLE tbl_tmp (
                id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                cod_prod BIGINT,
                cant_prod int);
                
                SET a = 1;
                
                SET registros = (SELECT COUNT(*) FROM detallefactura WHERE nofactura = no_factura);
        
        		IF registros > 0 THEN
                
                	INSERT INTO tbl_tmp(cod_prod,cant_prod) SELECT codproducto,cantidad FROM detallefactura WHERE nofactura = no_factura;
                    
                    WHILE a <= registros DO
                    	SELECT cod_prod,cant_prod INTO cod_producto,cant_producto FROM tbl_tmp WHERE id = a;
                        SELECT existencia INTO existencia_actual FROM producto WHERE codproducto = cod_producto;
                        SET nueva_existencia = existencia_actual + cant_producto;
                        UPDATE producto SET existencia = nueva_existencia WHERE codproducto = cod_producto;
                        SET a=a+1;
                        
                        
                    
                    END WHILE;
                    
                    UPDATE factura SET estatus = 2 WHERE nofactura = no_factura;
                    DROP TABLE tbl_tmp;
                    SELECT * FROM factura WHERE nofactura = no_factura;
                
                END IF;
        ELSE
        	SELECT 0 factura;
         END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `del_detalle_temp` (`id_detalle` INT, `token` VARCHAR(50))  BEGIN
    	DELETE FROM detalle_temp WHERE correlativo = id_detalle;
        
        SELECT tmp.correlativo, tmp.codproducto,p.descripcion,tmp.cantidad,tmp.precio_venta FROM detalle_temp tmp INNER JOIN producto p ON tmp.codproducto = p.codproducto
        WHERE tmp.token_user = token;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procesar_venta` (`cod_usuario` INT, `cod_cliente` INT, `token` VARCHAR(50))  BEGIN
    
    	DECLARE factura INT;
        
        DECLARE registros INT;
        
        DECLARE total DECIMAL(10,2);
        
        DECLARE nueva_existencia int;
        DECLARE existencia_actual int;
        
        DECLARE tmp_cod_producto int;
        DECLARE tmp_cant_producto int;
        DECLARE a INT;
        SET a = 1;
        
        CREATE TEMPORARY TABLE tbl_tmp_tokenuser (id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, cod_prod BIGINT, cant_prod int);
        
        SET registros = (SELECT COUNT(*) FROM detalle_temp WHERE token_user = token);
        
        IF registros > 0 THEN
        
        	INSERT INTO tbl_tmp_tokenuser(cod_prod,cant_prod) SELECT codproducto,cantidad FROM detalle_temp WHERE token_user = token;
            
            INSERT INTO factura(usuario,codcliente) VALUES (cod_usuario,cod_cliente);
            SET factura = LAST_INSERT_ID();
            
            INSERT INTO detallefactura(nofactura,codproducto,cantidad,precio_venta) SELECT (factura) as nofactura, codproducto, cantidad, precio_venta FROM detalle_temp WHERE token_user = token;
            
            WHILE a <= registros DO
            	SELECT cod_prod,cant_prod INTO tmp_cod_producto, tmp_cant_producto FROM tbl_tmp_tokenuser WHERE id = a;
                SELECT existencia INTO existencia_actual FROM producto WHERE codproducto = tmp_cod_producto;
                
                SET nueva_existencia = existencia_actual - tmp_cant_producto;
                UPDATE producto SET existencia = nueva_existencia WHERE codproducto = tmp_cod_producto;
                
                SET a=a+1;
            
            END WHILE;
            
            SET total = (SELECT SUM(cantidad * precio_venta) FROM detalle_temp WHERE token_user = token);
            UPDATE factura SET totalfactura = total WHERE nofactura = factura;
            
           	DELETE FROM detalle_temp WHERE token_user = token;
            TRUNCATE TABLE tbl_tmp_tokenuser;
            SELECT * FROM factura WHERE nofactura = factura;
            
        
        ELSE
        
        	SELECT 0;
        
        END IF;
    
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `id_categoria` int(11) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `estatus` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id_categoria`, `categoria`, `usuario_id`, `estatus`) VALUES
(9, 'Categoria de Prueba2', 1, 1),
(10, 'Cauchos', 1, 1),
(11, 'Baterias', 1, 1),
(12, 'Repuestos', 1, 0),
(13, 'Repuestos', 1, 0),
(14, 'Repuestos2', 1, 0),
(15, 'Repuestos', 1, 0),
(16, 'Repuestos', 1, 1),
(17, 'Repuestos2', 1, 0),
(18, 'Repuestos2', 1, 0),
(19, 'Aceites', 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `idcliente` int(11) NOT NULL,
  `cedula` int(11) DEFAULT NULL,
  `nombre` varchar(80) DEFAULT NULL,
  `telefono` double DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `dateadd` datetime NOT NULL DEFAULT current_timestamp(),
  `usuario_id` int(11) NOT NULL,
  `estatus` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idcliente`, `cedula`, `nombre`, `telefono`, `direccion`, `dateadd`, `usuario_id`, `estatus`) VALUES
(5, 30101126, 'Eric Carroz', 4246133105, 'Urb. La Pomona, Vereda 15.', '2020-07-26 14:21:29', 1, 1),
(6, 7606305, 'Elsa Martinez', 4146906041, 'Urb. Urdaneta', '2020-08-29 12:38:07', 1, 1),
(7, 20378547, 'Diana Beatriz Carroz', 4146643756, 'Urb. Urdaneta', '2020-08-29 12:43:40', 1, 0),
(8, 20378548, 'Diana Carroz', 4126643756, 'Urb. Altos del Sol Amada', '2020-08-29 13:42:28', 1, 0),
(9, 20378547, 'Adriana Carroz Martinez', 4126413419, 'Urb. Altos del Sol Amada', '2020-08-29 14:04:57', 1, 1),
(10, 20378548, 'Diana Carroz Martinez', 4126433419, 'Urb. La Milagrosa', '2020-08-29 14:09:48', 1, 0),
(11, 30101128, 'Jose Martinez Soler', 4262016689, 'La Pomona', '2020-08-29 14:20:09', 1, 0),
(12, 30101129, 'Antonio Silva Suarez', 4126643756, 'Urb. Altos del Sol Amada', '2020-08-29 14:34:16', 1, 0),
(13, 4751311, 'Eric José Carroz ', 4169631663, 'Urb. La Pomona', '2020-08-29 15:16:55', 1, 0),
(14, 20378548, 'Diana Beatriz Carroz', 4126643756, 'Urb. La Pomona', '2020-08-29 15:31:27', 1, 0),
(15, 20378548, 'Diana Carroz Martinez', 4126643756, 'Urb. El Naranjal', '2020-08-29 16:10:48', 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE `configuracion` (
  `id` bigint(20) NOT NULL,
  `rif` varchar(50) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `razon_social` varchar(100) NOT NULL,
  `telefono` bigint(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `direccion` text NOT NULL,
  `iva` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `configuracion`
--

INSERT INTO `configuracion` (`id`, `rif`, `nombre`, `razon_social`, `telefono`, `email`, `direccion`, `iva`) VALUES
(1, 'J-30906270-0', 'EL GALPÓN DEL CAUCHO C.A.', '', 1232131, 'galpondelcaucho@yahoo.com', 'SECTOR VERITAS, CALLE 90 CON AV. 8 #74-144', '12.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallefactura`
--

CREATE TABLE `detallefactura` (
  `correlativo` bigint(11) NOT NULL,
  `nofactura` bigint(11) DEFAULT NULL,
  `codproducto` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio_venta` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `detallefactura`
--

INSERT INTO `detallefactura` (`correlativo`, `nofactura`, `codproducto`, `cantidad`, `precio_venta`) VALUES
(21, 17, 15, 4, '84.00'),
(22, 18, 15, 4, '84.00'),
(23, 19, 15, 4, '84.00'),
(24, 20, 15, 4, '84.00'),
(25, 21, 21, 20, '1.00'),
(26, 22, 15, 4, '84.00'),
(27, 23, 19, 3, '55.00'),
(28, 24, 15, 2, '84.00'),
(29, 24, 19, 1, '55.00'),
(31, 25, 15, 10, '84.00'),
(32, 26, 15, 20, '84.00'),
(33, 27, 15, 10, '84.00'),
(34, 28, 15, 4, '84.00'),
(35, 29, 15, 1, '84.00'),
(36, 29, 15, 1, '84.00'),
(37, 30, 19, 1, '55.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_temp`
--

CREATE TABLE `detalle_temp` (
  `correlativo` int(11) NOT NULL,
  `token_user` varchar(50) NOT NULL,
  `codproducto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entradas`
--

CREATE TABLE `entradas` (
  `correlativo` int(11) NOT NULL,
  `codproducto` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `cantidad` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `usuario_id` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `entradas`
--

INSERT INTO `entradas` (`correlativo`, `codproducto`, `fecha`, `cantidad`, `precio`, `usuario_id`) VALUES
(102, 14, '2020-08-29 14:36:10', 100, '79.00', 1),
(103, 14, '2020-08-29 14:44:45', 10, '79.00', 1),
(104, 15, '2020-08-29 14:48:40', 100, '84.00', 1),
(105, 16, '2020-08-29 15:18:17', 100, '83.00', 1),
(106, 16, '2020-08-29 15:19:16', 20, '84.00', 1),
(107, 17, '2020-08-29 15:32:54', 100, '84.00', 1),
(108, 17, '2020-08-29 15:33:11', 20, '84.00', 1),
(109, 18, '2020-08-29 16:12:59', 100, '84.00', 1),
(110, 18, '2020-08-29 16:13:12', 10, '84.00', 1),
(111, 19, '2020-09-21 20:33:39', 24, '55.00', 1),
(112, 20, '2020-09-21 20:35:54', 30, '30.00', 1),
(113, 21, '2020-09-21 20:37:47', 100, '1.00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `nofactura` bigint(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `usuario` int(11) DEFAULT NULL,
  `codcliente` int(11) DEFAULT NULL,
  `totalfactura` decimal(10,2) DEFAULT NULL,
  `estatus` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `factura`
--

INSERT INTO `factura` (`nofactura`, `fecha`, `usuario`, `codcliente`, `totalfactura`, `estatus`) VALUES
(17, '2020-08-29 14:50:56', 1, 5, '336.00', 1),
(18, '2020-08-29 15:20:25', 1, 5, '336.00', 2),
(19, '2020-08-29 15:41:46', 1, 5, '336.00', 2),
(20, '2020-08-29 16:14:09', 1, 5, '336.00', 2),
(21, '2020-09-23 16:49:24', 1, 5, '20.00', 1),
(22, '2020-09-23 17:09:26', 1, 5, '336.00', 1),
(23, '2020-09-23 17:25:38', 1, 5, '165.00', 1),
(24, '2020-09-23 17:27:54', 1, 5, '223.00', 1),
(25, '2020-09-23 17:46:42', 1, 6, '840.00', 1),
(26, '2020-09-23 17:50:09', 1, 5, '1680.00', 1),
(27, '2020-10-04 22:10:11', 1, 5, '840.00', 1),
(28, '2020-10-05 15:50:00', 1, 5, '336.00', 1),
(29, '2020-10-05 21:13:02', 1, 5, '168.00', 1),
(30, '2020-11-07 21:06:48', 1, 5, '55.00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `codproducto` int(11) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `proveedor` int(11) DEFAULT NULL,
  `categoria` int(11) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `existencia` int(11) DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT current_timestamp(),
  `usuario_id` int(11) NOT NULL,
  `estatus` int(11) NOT NULL DEFAULT 1,
  `foto` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`codproducto`, `descripcion`, `proveedor`, `categoria`, `precio`, `existencia`, `date_add`, `usuario_id`, `estatus`, `foto`) VALUES
(14, '195/75/R14 Cooper', 6, 10, '79.00', 110, '2020-08-29 14:36:10', 1, 0, 'img_aed9121741cd11191b2280ab313258f5.jpg'),
(15, '195/75/R15 CHENGSHAN', 6, 10, '84.00', 44, '2020-08-29 14:48:40', 1, 1, 'img_producto.jpg'),
(16, '195/75/R14 Cooper XCX', 6, 11, '84.00', 120, '2020-08-29 15:18:17', 1, 0, 'img_e72ec9f1e15dc315e34fe8bd623b4118.jpg'),
(17, '195/75/R14 Cooper C-101', 16, 10, '84.00', 120, '2020-08-29 15:32:54', 1, 0, 'img_5d3ec35a85003b9453c4da9b7fa4b203.jpg'),
(18, '195/75/R15 Cooper C-XC', 6, 11, '84.00', 110, '2020-08-29 16:12:59', 1, 0, 'img_324acdc20290bb1f9dab076355f0239c.jpg'),
(19, 'ME70KI 600 AMP', 16, 11, '55.00', 19, '2020-09-21 20:33:39', 1, 1, 'img_producto.jpg'),
(20, 'Inca', 16, 19, '30.00', 30, '2020-09-21 20:35:54', 1, 1, 'img_producto.jpg'),
(21, 'Tuercas', 9, 16, '1.00', 80, '2020-09-21 20:37:47', 1, 1, 'img_producto.jpg');

--
-- Disparadores `producto`
--
DELIMITER $$
CREATE TRIGGER `entradas_A_I` AFTER INSERT ON `producto` FOR EACH ROW BEGIN
		INSERT INTO entradas(codproducto,cantidad,precio,usuario_id) 
		VALUES(new.codproducto,new.existencia,new.precio,new.usuario_id);    
	END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `codproveedor` int(11) NOT NULL,
  `proveedor` varchar(100) DEFAULT NULL,
  `contacto` varchar(100) DEFAULT NULL,
  `telefono` double NOT NULL,
  `direccion` text DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT current_timestamp(),
  `usuario_id` int(11) NOT NULL,
  `estatus` int(11) NOT NULL DEFAULT 1,
  `rif` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`codproveedor`, `proveedor`, `contacto`, `telefono`, `direccion`, `date_add`, `usuario_id`, `estatus`, `rif`) VALUES
(5, 'Proveedor de Prueba', 'Contacto de Prueba', 4126643756, 'Urb. La Pomona, Vereda 15.', '2020-07-26 14:20:56', 1, 0, 'RIF  de Prueba'),
(6, 'Proveedor', 'Contacto de Prueba', 4126643756, 'Sector Cecilio Acosta', '2020-08-29 12:33:13', 1, 1, '12345'),
(7, 'Proveedor Nuevo', 'Contacto de Prueba', 4126643756, 'La Pomona Parroquia Cristo de Aranza', '2020-08-29 12:36:55', 1, 0, '123456789'),
(8, 'Proveedor B', 'Andres Uzcategui', 4262016689, 'La Pomona ', '2020-08-29 12:42:29', 1, 0, '123456789'),
(9, 'Proveedor A C', 'Contacto de Prueba', 4146906041, 'Urb. La Pomona ', '2020-08-29 12:46:52', 1, 1, '123456789'),
(10, 'Proveedor abcd', 'Miguel Torres', 4126643756, 'La Pomona ', '2020-08-29 13:40:48', 1, 0, 'j-123456789'),
(11, 'Proveedor ABcde', 'Contacto de Prueba', 4126643756, 'La Pomona ', '2020-08-29 14:03:41', 1, 0, 'j-234567890'),
(12, 'Proveedor ABCDEFGhijk', 'Contacto de Prueba', 4126643756, 'La Pomona ', '2020-08-29 14:08:36', 1, 0, 'j-1234567890'),
(13, 'Proveedor ABCDEFGHIJKL', 'Contacto de Prueba', 4126643756, 'La Pomona ', '2020-08-29 14:18:50', 1, 0, 'J-123456789'),
(14, 'Proveedor ABCDEFHIJlmn', 'Raul Fuenmayor', 4126643756, 'La Pomona ', '2020-08-29 14:32:44', 1, 0, 'J-987654321'),
(15, 'Proveedor ABCDEFGHIJ', 'Contacto de Prueba', 4126643756, 'Urb. La Pomona ', '2020-08-29 15:15:30', 1, 0, 'J-987654321'),
(16, 'Proveedor de Prueba1', 'JosÃ© Gamez', 4126643756, 'Sector Veritas ', '2020-08-29 15:27:33', 1, 1, 'J-987654321'),
(17, 'Cauchos La Mundial', 'Jose Luzardo', 4126643756, 'Sector Veritas ', '2020-08-29 15:29:57', 1, 0, 'J-987654321'),
(18, 'Proveedor de Prueba2', 'Carlos Leon', 4126643756, 'La Pomona ', '2020-08-29 16:09:42', 1, 0, 'J-0987654321');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `idrol` int(11) NOT NULL,
  `rol` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`idrol`, `rol`) VALUES
(1, 'Administrador'),
(2, 'Supervisor'),
(3, 'Vendedor');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabla_prueba`
--

CREATE TABLE `tabla_prueba` (
  `cod_cp` int(11) NOT NULL,
  `campo_prueba` varchar(20) NOT NULL,
  `estatus` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tabla_prueba`
--

INSERT INTO `tabla_prueba` (`cod_cp`, `campo_prueba`, `estatus`) VALUES
(1, 'a', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idusuario` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `usuario` varchar(15) DEFAULT NULL,
  `clave` varchar(100) DEFAULT NULL,
  `rol` int(11) DEFAULT NULL,
  `estatus` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idusuario`, `nombre`, `correo`, `usuario`, `clave`, `rol`, `estatus`) VALUES
(1, 'Ericj', 'ericjosecm@gmail.com', 'admin', '202cb962ac59075b964b07152d234b70', 1, 1),
(2, 'José Martí­nez', 'ericjose97@hotmail.com', 'Jose', '202cb962ac59075b964b07152d234b70', 2, 1),
(3, 'Eric Carroz Martinez', 'ericjose123@gmail.com', 'eric', '25d55ad283aa400af464c76d713c07ad', 3, 0),
(4, 'Eric Carroz Martinez', 'eric12345@gmail.com', 'eric12345', '25d55ad283aa400af464c76d713c07ad', 3, 0),
(5, 'José Solarte Añez', 'jose1233456@gmail.com', 'jose12345', '4bbcea08d09eefd3faa6e2ee4c72fd7f', 1, 0),
(6, 'Elsa Margarita Soler', 'elsa-s@gmail.com', 'elsa123', '25d55ad283aa400af464c76d713c07ad', 1, 0),
(7, 'Eric José Carroz Martinez', 'ericj123@gmail.com', 'eric-12345', '25d55ad283aa400af464c76d713c07ad', 2, 0),
(8, 'elsa beatriz', 'elsa@gmail.com', 'elsa123', '25d55ad283aa400af464c76d713c07ad', 1, 0),
(9, 'Elsa Martinez Soler', 'elsa@gmail.com', 'elsa123', '25d55ad283aa400af464c76d713c07ad', 1, 0),
(10, 'Elsa Martinez Soler', 'elsa@gmail.com', 'elsa123', '25d55ad283aa400af464c76d713c07ad', 1, 0),
(11, 'Elsa Beatriz Martinez Soler', 'elsa123@gmail.com', 'elsa123', '25d55ad283aa400af464c76d713c07ad', 1, 0),
(12, 'Raul Fuenmayor Hurtado', 'raul@gmail.com', 'raul123', '25d55ad283aa400af464c76d713c07ad', 2, 0),
(13, 'Raul Fuenmayor Hurtado', 'raul@gmail.com', 'raul123', '25d55ad283aa400af464c76d713c07ad', 1, 0),
(14, 'Raul Fuenmayor Hurtado', 'raul@gmail.com', 'raul123', 'dd20ee80b5d99d33770e88fd871c4d1a', 2, 0),
(15, 'Raul Fuenmayor Hurtado', 'raul@gmail.com', 'raul123', 'dd20ee80b5d99d33770e88fd871c4d1a', 1, 0),
(16, 'Raul Fuenmayor Hurtado', 'raul@gmail.com', 'raul123', '25d55ad283aa400af464c76d713c07ad', 2, 0),
(17, 'Raul Fuenmayor Hurtado', 'raul@gmail.com', 'raul123', 'dd20ee80b5d99d33770e88fd871c4d1a', 1, 0),
(18, 'Raul Fuenmayor', 'raul@gmail.com', 'raul', '25d55ad283aa400af464c76d713c07ad', 3, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id_categoria`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idcliente`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `detallefactura`
--
ALTER TABLE `detallefactura`
  ADD PRIMARY KEY (`correlativo`),
  ADD KEY `codproducto` (`codproducto`),
  ADD KEY `nofactura` (`nofactura`);

--
-- Indices de la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  ADD PRIMARY KEY (`correlativo`),
  ADD KEY `nofactura` (`token_user`),
  ADD KEY `codproducto` (`codproducto`);

--
-- Indices de la tabla `entradas`
--
ALTER TABLE `entradas`
  ADD PRIMARY KEY (`correlativo`),
  ADD KEY `codproducto` (`codproducto`);

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`nofactura`),
  ADD KEY `usuario` (`usuario`),
  ADD KEY `codcliente` (`codcliente`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`codproducto`),
  ADD KEY `proveedor` (`proveedor`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `categoria` (`categoria`) USING BTREE;

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`codproveedor`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`idrol`);

--
-- Indices de la tabla `tabla_prueba`
--
ALTER TABLE `tabla_prueba`
  ADD PRIMARY KEY (`cod_cp`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idusuario`),
  ADD KEY `rol` (`rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idcliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `detallefactura`
--
ALTER TABLE `detallefactura`
  MODIFY `correlativo` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  MODIFY `correlativo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=543;

--
-- AUTO_INCREMENT de la tabla `entradas`
--
ALTER TABLE `entradas`
  MODIFY `correlativo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT de la tabla `factura`
--
ALTER TABLE `factura`
  MODIFY `nofactura` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `codproducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `codproveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tabla_prueba`
--
ALTER TABLE `tabla_prueba`
  MODIFY `cod_cp` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD CONSTRAINT `categoria_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`);

--
-- Filtros para la tabla `detallefactura`
--
ALTER TABLE `detallefactura`
  ADD CONSTRAINT `detallefactura_ibfk_2` FOREIGN KEY (`codproducto`) REFERENCES `producto` (`codproducto`),
  ADD CONSTRAINT `detallefactura_ibfk_3` FOREIGN KEY (`nofactura`) REFERENCES `factura` (`nofactura`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  ADD CONSTRAINT `detalle_temp_ibfk_2` FOREIGN KEY (`codproducto`) REFERENCES `producto` (`codproducto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `entradas`
--
ALTER TABLE `entradas`
  ADD CONSTRAINT `entradas_ibfk_1` FOREIGN KEY (`codproducto`) REFERENCES `producto` (`codproducto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `factura`
--
ALTER TABLE `factura`
  ADD CONSTRAINT `factura_ibfk_2` FOREIGN KEY (`codcliente`) REFERENCES `cliente` (`idcliente`),
  ADD CONSTRAINT `factura_ibfk_3` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `producto_categoria` FOREIGN KEY (`categoria`) REFERENCES `categoria` (`id_categoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`proveedor`) REFERENCES `proveedor` (`codproveedor`),
  ADD CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD CONSTRAINT `proveedor_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`rol`) REFERENCES `rol` (`idrol`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
