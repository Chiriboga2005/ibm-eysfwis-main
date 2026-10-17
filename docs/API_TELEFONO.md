# API de telefonos

Autor: Kevin Quintero
Rama: aporte-telefono-kevin

## Alcance

Backend en CodeIgniter para listar, consultar, crear, actualizar
y eliminar telefonos asociados a una persona.

Este aporte no incluye la interfaz movil en Flutter.

## Archivos

- sql/crear_telefono.sql: estructura de la tabla.
- app/Models/TelefonoModel.php: acceso a datos y validaciones.
- app/Controllers/Telefono.php: operaciones de la API.
- app/Config/Routes.php: rutas HTTP.

## Preparacion del entorno local

1. Instalar PHP y las extensiones requeridas por composer.json.
2. Instalar Composer y MySQL o MariaDB.
3. Ejecutar composer install desde la carpeta del proyecto.
4. Preparar una base de datos de pruebas con las tablas del proyecto.
   La tabla persona debe existir antes de crear telefono.
5. Ejecutar sql/crear_telefono.sql en esa base de datos una sola vez.
6. Configurar localmente la conexion a la base de datos en .env.
   No incluir credenciales personales en los commits.
7. Ejecutar php spark serve para iniciar el servidor local.

URL local habitual: http://localhost:8080

## Rutas

| Metodo | Ruta | Operacion |
|---|---|---|
| GET | /api/telefonos | Listar telefonos |
| GET | /api/telefonos/{id} | Consultar un telefono |
| POST | /api/telefonos | Crear telefono |
| PUT o PATCH | /api/telefonos/{id} | Actualizar campos enviados |
| DELETE | /api/telefonos/{id} | Eliminar telefono |

Sustituir {id} por el identificador del telefono.

## Crear un telefono

Enviar POST /api/telefonos con:
Content-Type: application/json

Ejemplo de cuerpo JSON:

    {
        "idpersona": 1,
        "numero": "0991234567",
        "tipo": "Celular"
    }

El idpersona es ilustrativo: debe corresponder a una persona existente.
Si se omite tipo al crear, se utiliza Celular.
La respuesta exitosa devuelve HTTP 201 con el registro creado.

## Actualizar un telefono

Enviar PATCH /api/telefonos/{id} con:
Content-Type: application/json

Ejemplo de cuerpo JSON:

    {
        "numero": "0987654321",
        "tipo": "Trabajo"
    }

Los campos omitidos conservan su valor.
PUT tambien utiliza esta actualizacion parcial.
Debe enviarse al menos uno de estos campos: idpersona, numero o tipo.

## Validaciones

- idpersona: entero positivo que exista en persona.
- numero: texto con entre 7 y 15 digitos y hasta 20 caracteres totales.
- Se permiten espacios, parentesis, guiones y un signo + inicial.
- tipo: Celular, Fijo, Trabajo u Otro.
- Los identificadores de telefono deben ser positivos.
- Un telefono inexistente devuelve HTTP 404.
- Los datos invalidos devuelven una respuesta de error de validacion.
- Eliminar una persona elimina sus telefonos por la clave foranea.

## Comprobaciones pendientes

En un entorno local preparado, ejecutar:

    php -l app/Models/TelefonoModel.php
    php -l app/Controllers/Telefono.php
    php -l app/Config/Routes.php
    php spark routes

Luego probar en una base de datos de pruebas:

1. Crear un telefono para una persona existente y guardar el ID devuelto.
2. Consultar ese ID y comprobar que aparece en el listado.
3. Actualizar su numero y consultar para verificar el cambio.
4. Intentar registrar solo guiones como numero: debe rechazarse.
5. Intentar registrar un telefono para una persona inexistente: debe rechazarse.
6. Eliminar el telefono creado para la prueba.
7. Consultar el ID eliminado: debe devolver 404.

## Estado de verificacion

Pruebas de ejecucion pendientes: PHP no fue encontrado en la terminal
ni en las carpetas habituales revisadas, y falta vendor/autoload.php.
El codigo subido a GitHub no implica que las pruebas hayan pasado.

La integracion con Flutter y la revision del equipo siguen pendientes.
Estas rutas no incorporan autenticacion ni autorizacion; su uso fuera
del entorno de pruebas requiere definir esos controles.