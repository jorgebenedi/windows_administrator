function mostrarAlmacenes{
        Write-Host "Lista de almacenes"
        Write-Host "------------------"
        $listalogs=Get-CimInstance -ClassName Win32_NTEventlogFile | Select-Object -ExpandProperty filename # Muestra los almacenes de eventos, y luego selecciona la propiedad filename de cada objeto
        $listalogs
        [string]$nombre=read-host "Nombre del almacen(consumidor).evtx__"

        $obtenerprop=Get-CimInstance -ClassName Win32_NTEventlogFile -Filter "FileName='$nombre'" # Obtiene las propiedades
        $obtenerprop | Select-Object -Property MaxFileSize, FileSize, LastModified, NumberOfRecords, Sources, Path # muestra las propiedades

}

function BorrarAlmacenes{
    try{
       
        Write-Host "Lista de almacenes"
        Write-Host "------------------"
        $listalogs=Get-CimInstance -ClassName Win32_NTEventlogFile | Select-Object -ExpandProperty filename # Muestra los almacenes de eventos, y luego selecciona la propiedad filename de cada objeto
        $listalogs
        [string]$nombre=read-host "Nombre del almacen(consumidor).evtx__"

        $obtenerprop=Get-CimInstance -ClassName Win32_NTEventlogFile -Filter "FileName='$nombre'" # Obtiene las propiedades
        $obtenerprop | Select-Object -Property MaxFileSize, FileSize, LastModified, NumberOfRecords, Sources, Path # muestra las propiedades

        Invoke-CimMethod -InputObject $obtenerprop -MethodName "ClearEventLog" 
        # Borra todos los eventos de un almacen(archivo de eventos) pasado por el usuario
        Write-Host "Eventos borrados de $nombre"                       
    }catch{
        write-host "No se pudo borrar el almacen de eventos tal vez no exista"
    
    } 
}


do{

    Clear-Host
    Write-Host "=====Borrar-eventos-log====="
    Write-Host "1-Mostrar almacenes"
    Write-Host "2-Borrar almacenes"
    Write-Host "3-Salir"
    [int]$option = Read-Host "Introduce una opcion"
    switch ($option)
    {
        1{mostrarAlmacenes;break;}
        2{BorrarAlmacenes;break;}
        3{break;}
    }
    [string]$letra = read-host "Introduzca cualquier letra"
    }while($option -ne 3);                                                             
