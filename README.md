# PL/SQL Trabajo Bases de Datos II

## Orden de ejecución del los archivos para que todo funcione:

packageUtil --> tablesCreation --> coopInsertTrigger --> socioInsertTrigger
--> coopexsocioInsertTrigger --> deleteCoopTrigger --> deleteSocioTrigger
--> updateCoopTrigger --> firstProgram --> secondProgram
--> casosDePrueba (casos de prueba del enunciado)

### Archivos en este repositorio:

1. tablesCreation.sql: Instrucciones para la creacion de las tablas del enunciado
2. casosDePrueba.sql: Filas para simular el ejemplo del enunciado
3. packageUtil.sql: Instrucciones para creacion de paquete con tipos utilies para el trabajo
4. coopInsertTrigger.sql: Trigger de inserción tabla cooperativa c_acumulado = 0 (3%)
5. socioInsertTrigger.sql: Trigger de inserción tabla socio s_acumulado = 0 (3%)
6. coopexsocioInsertTrigger.sql: Trigger de inserción tabla coopexsocio sc_acumulado = 0 (3%)
7. updateCoopTrigger: Trigger de actualización sobre la tabla cooperativa (25%)
8. deleteCoopTrigger: Trigger de borrado sobre la tabla cooperativa (15%)
9. deleteSocioTrigger: Trigger de borrado sobre la tabla socio (10%)
10. firstProgram: Primer programa del enunciado (20%)
11. secondProgram: Segundo programa del enunciado (21%)
12. packageExtra: paquete extra con métodos útiles.