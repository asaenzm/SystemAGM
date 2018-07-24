Use Master
Go
If(db_id('DemoPractica')Is Not Null)
Drop DataBase DemoPractica
Create DataBase DemoPractica
Go

Use DemoPractica
Go

Create Table Categoria
(IdCategoria Int Identity Primary Key,
Descripcion Varchar(50) Not Null
)
Go

Create Table Producto
(IdProducto Int Identity Primary Key,
IdCategoria Int Not Null References Categoria,
Nombre Varchar(50) Not Null,
Marca Varchar(80),
Stock Int Not Null,
PrecioCompra Decimal(6,2) Not Null,
PrecioVenta Decimal(6,2) Not Null,
FechaVencimiento Date
)
Go

Create Table Cliente
(IdCliente Int Identity Primary Key,
DNI Char(8) Not Null,
Apellidos Varchar(50) Not Null,
Nombres Varchar(50) Not Null,
Direccion Varchar(100) Not Null,
Telefono Varchar(12)
)
go

Insert Cliente Values('47660746','Vásquez Ventura','Juan','Urb. Santa Rosa','996687349')
Go

Create Table Cargo
(IdCargo Int Identity Primary Key,
Descripcion Varchar(30) Not Null
)
Go

Create Table Empleado
(IdEmpleado Int Identity Primary Key,
IdCargo Int Not Null References Cargo,
Dni Char(8) Not Null,
Apellidos Varchar(30) Not Null,
Nombres Varchar(30) Not Null,
Sexo Char(1) Not Null,
FechaNac Date Not Null,
Direccion Varchar(80) Not Null,
EstadoCivil Char(1) Not Null
)
Go

Create Table Venta
(IdVenta Int Identity Primary Key,
IdEmpleado Int Not Null References Empleado,
IdCliente Int Not Null References Cliente,
Serie Char(5) Not Null,
NroDocumento Char(7) Not Null,
TipoDocumento Varchar(7) Check(TipoDocumento In('Boleta','Factura')),
FechaVenta Date Not Null,
Total Money Not Null
)
go

Create Table DetalleVenta
(IdDetalleVenta Int Identity Primary Key,
IdProducto Int Not Null References Producto,
IdVenta Int Not Null References Venta,
Cantidad Int Not Null,
PrecioUnitario Decimal(6,2) Not Null,
Igv Money Not Null,
SubTotal Money Not Null
)
Go


Insert Categoria Values('Bebidas'),('Carnes'),('Verduras')
Go


--PROCEDIMIENTOS ALMACENADOS EN SQL SERVER 2012

Create Proc ListarClientes
As Begin
	Select IdCliente,DNI,Apellidos,Nombres,Direccion,Telefono From Cliente 
   End
Go

Create Proc RegistrarCliente
(@DNI char(8),
@Apellidos Varchar(50),
@Nombres Varchar(50),
@Direccion Varchar(100),
@Telefono Varchar(12),
@Mensaje Varchar(50) Output
)
As Begin
	If(Exists(Select * From Cliente Where Dni=@DNI))
		Set @Mensaje='Los Datos del Cliente ya Existen.'
	Else Begin
		Insert Cliente Values(@DNI,@Apellidos,@Nombres,@Direccion,@Telefono)
		Set @Mensaje='Registrado Correctamente.'
		End
	End
Go

Create Proc ActualizarCliente
(@DNI Char(8),
@Apellidos Varchar(50),
@Nombres Varchar(50),
@Direccion Varchar(100),
@Telefono Varchar(12),
@Mensaje Varchar(50) Output
)
As Begin
	If(Not Exists(Select * From Cliente Where Dni=@DNI))
		Set @Mensaje='Los Datos del Cliente no Existen.'
	Else Begin
		Update Cliente Set Apellidos=@Apellidos,Nombres=@Nombres,Direccion=@Direccion,Telefono=@Telefono 
		Where DNI=@DNI
		Set @Mensaje='Registro Actualizado Correctamente.'
		End
	End
Go

Create Proc FiltrarDatosCliente
@Datos Varchar(80)
As Begin
	Select IdCliente,DNI,Apellidos,Nombres,Direccion,Telefono 
	From Cliente Where Apellidos+' '+ Nombres=@Datos or Apellidos=@Datos or Nombres=@Datos
End
Go

Create Proc FiltrarDatosProducto
@Datos Varchar(50)
As Begin
	Select IdProducto,IdCategoria,Nombre,Marca,PrecioCompra,PrecioVenta,Stock,FechaVencimiento 
	From Producto where Nombre=@Datos or Marca=@Datos or Nombre+' '+Marca=@Datos
End
Go
--FiltrarDatosProducto 'G'
Create Proc ListadoProductos
As Begin
	Select IdProducto,IdCategoria,Nombre,Marca,PrecioCompra,PrecioVenta,Stock,FechaVencimiento 
	From Producto
End
go

Create Proc ListarCategoria
As Begin
	Select * From Categoria
End
Go

Insert Producto Values(1,'Gaseosa','Pepsi',5,4.90,5.90,'12/12/2013')
Go

Create proc RegistrarCategoria
@Descripcion Varchar(50),
@Mensaje Varchar(50)  Out
As Begin
	If(Exists(Select * From Categoria Where Descripcion=@Descripcion))
		Set @Mensaje='Categoria ya se encuentra Registrada.'
	Else Begin
		Insert Categoria Values(@Descripcion)
		Set @Mensaje='Registrado Correctamente.'
	End
End
Go

Create proc ActualizarCategoria
@IdC Int,
@Descripcion Varchar(50),
@Mensaje Varchar(50)  Out
As Begin
	If(Not Exists(Select * From Categoria Where IdCategoria=@IdC))
		Set @Mensaje='Categoria no se encuentra Registrada.'
	Else Begin
		Update Categoria Set Descripcion=@Descripcion Where IdCategoria=@IdC
		Set @Mensaje='Se ha Actualizado los Datos Correctamente.'
	End
End
Go

Create Proc BuscarCategoria
@Datos Varchar(50)
As Begin
	Select * From Categoria Where Descripcion=@Datos
End
Go

Create Proc RegistrarProducto
@IdCategoria Int,
@Nombre Varchar(50),
@Marca Varchar(80),
@Stock Int,
@PrecioCompra Decimal(6,2),
@PrecioVenta Decimal(6,2),
@FechaVencimiento Date,
@Mensaje varchar(50) Out
As Begin
	If(Exists(Select * From Producto Where Nombre=@Nombre And Marca=@Marca))
		Set @Mensaje='Este Producto ya ha sido Registrado.'
	Else Begin
		Insert Producto Values(@IdCategoria,@Nombre,@Marca,@Stock,@PrecioCompra,@PrecioVenta,@FechaVencimiento)
		Set @Mensaje='Registrado Correctamente.'
	End
End
Go

Create Proc ActualizarProducto
@IdProducto Int,
@IdCategoria Int,
@Nombre Varchar(50),
@Marca Varchar(80),
@Stock Int,
@PrecioCompra Decimal(6,2),
@PrecioVenta Decimal(6,2),
@FechaVencimiento Date,
@Mensaje varchar(50) Out
As Begin
	If(Not Exists(Select * From Producto Where IdProducto=@IdProducto))
		Set @Mensaje='Producto no se encuentra Registrado.'
	Else Begin
		Update Producto Set IdCategoria=@IdCategoria,Nombre=@Nombre,Marca=@Marca,Stock=@Stock,
		PrecioCompra=@PrecioCompra,PrecioVenta=@PrecioVenta,FechaVencimiento=@FechaVencimiento 
		Where IdProducto=@IdProducto
	Set @Mensaje='Registro Actualizado Correctamente.'
	End
End
Go


Create Proc ListarCargo
As Begin
	Select * From Cargo
	End
Go

Create Proc RegistrarCargo
@Descripcion Varchar(30),
@Mensaje Varchar(50) Out
As Begin
	If(Exists(Select * From Cargo Where Descripcion=@Descripcion))
		Set @Mensaje='El Cargo ya se Encuentra Registrado.'
	Else Begin
		Insert Cargo values(@Descripcion)
		Set @Mensaje='Registrado Correctamente.'
	End
End
Go

Create Proc ActualizarCargo
@IdCargo Int,
@Descripcion Varchar(30),
@Mensaje Varchar(100) Out
As Begin
	If(Exists(Select * From Cargo Where Descripcion=@Descripcion))
		Set @Mensaje='No se ha Podido Actualizar los Datos porque ya Existe el cargo. '+@Descripcion
	Else Begin
		If(Not Exists(Select * From Cargo Where IdCargo=@IdCargo))
			Set @Mensaje='El Cargo no se Encuentra Registrado.'
		Else Begin
		Update Cargo Set Descripcion=@Descripcion Where IdCargo=@IdCargo
			Set @Mensaje='Los datos se han Actualizado Correctamente.'
			End
		End
	End
Go


Create Proc BuscarCargo
@Descripcion varchar(30)
as begin
	Select * From Cargo Where Descripcion=@Descripcion
End
Go

Create Proc [Serie Documento]
@Serie char(5) out
as begin
Set @Serie='00001'
end
go

Create Procedure [Numero Correlativo]
@TipoDocumento Varchar(7),
@NroCorrelativo Char(7)Out
As Begin
	Declare @Cant Int
	If(@TipoDocumento='Factura')
	Begin
	Select @Cant=Count(*)+1 From Venta where TipoDocumento='Factura'
		If @Cant<10
			Set @NroCorrelativo='000000'+Ltrim(Str(@Cant))
		Else
			If @Cant<100
				Set @NroCorrelativo='00000'+Ltrim(Str(@Cant))
			Else
				If @Cant<1000
					Set @NroCorrelativo='0000'+Ltrim(Str(@Cant))
				Else
					If(@Cant<10000)
						Set @NroCorrelativo='000'+LTRIM(STR(@Cant))
					Else
						If(@Cant<100000)
							Set @NroCorrelativo='00'+LTRIM(STR(@Cant))
						Else
							If(@Cant<1000000)
								Set @NroCorrelativo='0'+LTRIM(str(@Cant))
							Else
								If(@Cant<10000000)
									Set @NroCorrelativo=LTRIM(str(@Cant))
	End
	if(@TipoDocumento='Boleta')
	begin
		Select @Cant=Count(*)+1 From Venta where TipoDocumento='Boleta'
		If @Cant<10
			Set @NroCorrelativo='000000'+Ltrim(Str(@Cant))
		Else
			If @Cant<100
				Set @NroCorrelativo='00000'+Ltrim(Str(@Cant))
			Else
				If @Cant<1000
					Set @NroCorrelativo='0000'+Ltrim(Str(@Cant))
				Else
					If(@Cant<10000)
						Set @NroCorrelativo='000'+LTRIM(STR(@Cant))
					Else
						If(@Cant<100000)
							Set @NroCorrelativo='00'+LTRIM(STR(@Cant))
						Else
							If(@Cant<1000000)
								Set @NroCorrelativo='0'+LTRIM(str(@Cant))
							Else
								If(@Cant<10000000)
									Set @NroCorrelativo=LTRIM(STR(@Cant))
			End
	End
Go
 
Create Table Usuario
(IdUsuario Int Identity Primary Key,
IdEmpleado Int Not Null References Empleado,
Usuario Varchar(20) Not Null,
Contraseña Varchar(12) Not Null
)
Go

Create Proc RegistrarUsuario
@IdEmpleado Int,
@Usuario Varchar(20),
@Contraseña Varchar(12),
@Mensaje Varchar(50) Out
As Begin
	If(Not Exists(Select * From Empleado Where IdEmpleado=@IdEmpleado))
		Set @Mensaje='Empleado no Registrado Ok.'
	Else Begin
		If(Exists(Select * From Usuario Where IdEmpleado=@IdEmpleado))
			Set @Mensaje='Este Empleado Ya Tiene una Cuenta de Usuario.'
		Else Begin
			If(Exists(Select * From Usuario Where Usuario=@Usuario))
				Set @Mensaje='El Usuario: '+@Usuario+' No está Disponible.'
			Else Begin
				Insert Usuario Values(@IdEmpleado,@Usuario,@Contraseña)
					Set @Mensaje='Usuario Registrado Correctamente.'
				 End
			 End
		 End
   End
Go

Create Proc IniciarSesion
@Usuario Varchar(20),
@Contraseña Varchar(12),
@Mensaje Varchar(50) Out
As Begin
	Declare @Empleado Varchar(50)
	If(Not Exists(Select Usuario From Usuario Where Usuario=@Usuario))
		Set @Mensaje='El Nombre de Usuario no Existe.'
		Else Begin
			If(Not Exists(Select Contraseña From Usuario Where Contraseña=@Contraseña))
				Set @Mensaje='Su Contraseña es Incorrecta.'
				Else Begin
					Set @Empleado=(Select E.Nombres+', '+E.Apellidos From Empleado E Inner Join Usuario U 
								   On E.IdEmpleado=U.IdEmpleado Where U.Usuario=@Usuario)
					    Begin
					Select Usuario,Contraseña From Usuario Where Usuario=@Usuario And Contraseña=@Contraseña
							Set @Mensaje='Bienvenido Sr(a): '+@Empleado+'.'
						End
				  End
		   End
   End
Go

Create Proc DevolverDatosSesion
@Usuario Varchar(20),
@Contraseña Varchar(12)
As Begin
	Select E.IdEmpleado,E.Apellidos+', '+E.Nombres 
	From Empleado E Inner Join Usuario U On E.IdEmpleado=U.IdEmpleado 
	Where U.Usuario=@Usuario And U.Contraseña=@Contraseña
	End
Go

Create Proc MantenimientoEmpleados
@IdEmpleado Int,
@IdCargo Int,
@Dni Char(8),
@Apellidos Varchar(30),
@Nombres Varchar(30),
@Sexo Char(1),
@FechaNac Date,
@Direccion Varchar(80),
@EstadoCivil Char(1),
@Mensaje Varchar(100) Out
As Begin
	If(Not Exists(Select * From Empleado Where Dni=@Dni))
		Begin
		Insert Empleado Values(@IdCargo,@Dni,@Apellidos,@Nombres,@Sexo,@FechaNac,@Direccion,@EstadoCivil)
			Set @Mensaje='Registrado Correctamente Ok.'
		End
	Else Begin
	If(Exists(Select * From Empleado Where Dni=@Dni))
		Begin
		Update Empleado Set IdCargo=@IdCargo,Dni=@Dni,Apellidos=@Apellidos,Nombres=@Nombres,Sexo=@Sexo,
		FechaNac=@FechaNac,Direccion=@Direccion,EstadoCivil=@EstadoCivil Where IdEmpleado=@IdEmpleado
			Set @Mensaje='Se Actualizaron los Datos Correctamente Ok.'
		End
	End
End
Go

Create Proc ListadoEmpleados
As Begin
	Select E.*,C.Descripcion From Cargo C Inner Join Empleado E On C.IdCargo=E.IdCargo
End
Go

Create Proc GenerarIdEmpleado
@IdEmpleado Int Out
As Begin
	Declare @Cant As Int
	If(Not Exists(Select IdEmpleado From Empleado))
		Set @IdEmpleado=1
	Else Begin
		Set @IdEmpleado=(Select Max(IdEmpleado)+1 FROM Empleado)
		End
	End
Go

Create proc Buscar_Empleado(
@Datos Varchar(50)
)
As Begin
		Select E.*,C.Descripcion From Cargo C Inner Join Empleado E On C.IdCargo=E.IdCargo
		where E.Nombres like @Datos +'%' or E.Apellidos like @Datos +'%'
End
go

Create Proc GenerarIdVenta
@IdVenta Int Out
As Begin
	If(Not Exists(Select IdVenta From Venta))
		Set @IdVenta=1
	Else Begin
		Set @IdVenta=(Select Max(IdVenta)+1 FROM Venta)
		End
	End
Go

Create Proc RegistrarVenta
@IdEmpleado Int,
@IdCliente Int,
@Serie Char(5),
@NroDocumento Char(7),
@TipoDocumento Varchar(7),
@FechaVenta Date,
@Total Money,
@Mensaje Varchar(100) Out
As Begin
	Insert Venta Values(@IdEmpleado,@IdCliente,@Serie,@NroDocumento,@TipoDocumento,@FechaVenta,@Total)
		Set @Mensaje='La Venta se ha Generado Correctamente.'
	End
Go

Create Proc RegistrarDetalleVenta
@IdProducto Int,
@IdVenta Int,
@Cantidad Int,
@PrecioUnitario Decimal(6,2),
@Igv Money,
@SubTotal Money,
@Mensaje Varchar(100) Out
As Begin
	Declare @Stock As Int
	Set @Stock=(Select Stock From Producto Where IdProducto=@IdProducto)
	Begin
		Insert DetalleVenta Values(@IdProducto,@IdVenta,@Cantidad,@PrecioUnitario,@Igv,@SubTotal)
			Set @Mensaje='Registrado Correctamente.'
	End
		Update Producto Set Stock=@Stock-@Cantidad Where IdProducto=@IdProducto
End
Go

Insert Cargo Values('Administrador')
Go
Insert Empleado Values(1,'34004387','Silva Terrones','Miguel','M','11/01/1990','Urb. Santa Rosa','S')
Go
Insert Usuario Values(1,'Miguelito','123456')
Go

Select * From Usuario
select * from Empleado
Go