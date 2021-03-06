/****** Script for DiynamicPivotNullForceExtraColumn  ******/


--Datos para el esenario

drop table fechacurp

GO

CREATE TABLE [dbo].[fechacurp](
       [fecha]   [nvarchar](50)   NULL,
       [curp]   [nvarchar](50)  NULL,

)
GO

INSERT   [dbo].[fechacurp]   ([curp],   [fecha])   VALUES (N'aaa', 20050101)
INSERT   [dbo].[fechacurp]   ([curp],   [fecha])  VALUES (N'aaa', 20050102)
INSERT   [dbo].[fechacurp]   ([curp],   [fecha])  VALUES (N'aaa', 20050103)
INSERT   [dbo].[fechacurp]   ([curp],   [fecha])  VALUES (N'aaa', 20050104)

INSERT   [dbo].[fechacurp]   ([curp],   [fecha])   VALUES (N'rasa', 20050101)
INSERT   [dbo].[fechacurp]   ([curp],   [fecha])  VALUES (N'rasj', 20050101)
INSERT   [dbo].[fechacurp]   ([curp],   [fecha])  VALUES (N'cosc', 20050101)
INSERT   [dbo].[fechacurp]   ([curp],   [fecha])   VALUES (N'rasj', 20050102)
INSERT   [dbo].[fechacurp]    ([curp],   [fecha])  VALUES (N'cosc', 20050102)
INSERT   [dbo].[fechacurp]   ([curp],   [fecha])  VALUES (N'rasj', 20050103)
INSERT   [dbo].[fechacurp]    ([curp],   [fecha])  VALUES (N'cosc', 20050103)



--Pivote dinamico

DECLARE @columnitasin AS NVARCHAR(MAX);
DECLARE @columnitas AS NVARCHAR(MAX);
DECLARE @PivoteDinamico AS NVARCHAR(MAX);
DECLARE @tablar AS TABLE(  
  curp nvarchar(50) ,
  fecha1 nvarchar(50),
  fecha2 nvarchar(50),
  fecha3 nvarchar(50),
  fecha4 nvarchar(50));

SELECT @Columnitasin = ISNULL(@Columnitasin + ',','') 
         + 'ISNULL(' + QUOTENAME(fecha) + ', 0) AS '
    + QUOTENAME(fecha)+' '
FROM (SELECT DISTINCT fecha FROM fechacurp) AS fechas

SELECT @Columnitas = ISNULL(@Columnitas + ',','')
+ QUOTENAME(fecha)
FROM (SELECT DISTINCT fecha FROM fechacurp) AS fechas
print 'SOL ISNULL'
print @columnitasin
PRINT 'COL'
print @columnitas

SET @PivoteDinamico = 
  N'SELECT curp as curp, ' + @Columnitasin + '
    FROM [dbo].[fechacurp]
    PIVOT	
	(
	max([fecha]) 
	
          FOR 
		  fecha
		  IN (' + @Columnitas + ')) AS P'
--Execute the Dynamic Pivot Query
print @PivoteDinamico

INSERT INTO @tablar EXECUTE sp_executesql @PivoteDinamico

--Borrando header usado para forzar cuarta column
DELETE FROM @tablar WHERE curp='aaa'
SELECT * FROM @tablar

