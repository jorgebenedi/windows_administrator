function  GetNameService {
    $nombreservicio = Read-Host "`t`t Ingrese el nombre del servicio" 
    return $nombreServicio
}

function listServices {
    Write-Host "Estados posibles: Running, Stopped, Paused, etc."
    [string]$estado=read-host "estado de los servicios que quieres filtrar"
    Get-Service | Where-Object {$_.Status -eq $estado }
    
}

function showDetailsOfService() { 
    $nombreservicio = GetNameService
    Get-Service -Name $nombreservicio | Format-List
}


function stopService {
    try {
        $nombreservicio = GetNameService
        Stop-service -name $nombreservicio
        Write-Host "El servicio '$nombreservicio' se ha parado correctamente."
    }
    catch {
        Write-Host "El servicio '$nombreservicio': $_ no fue parado"
    }


}


function startService {
    $nombreservicio = GetNameService
    try { 
    Start-Service -Name $nombreservicio 
    Write-Host "El servicio '$nombreservicio' se ha iniciado correctamente."
    } catch { Write-Host "Error al iniciar el servicio '$nombreservicio': $_" }
}


function createService {
    $nombreservicio = GetNameService
    write-host "Tipos de inicio"; Get-Service | Select-Object -ExpandProperty StartType -Unique 
    $tipoInicio = Read-Host("Introduce el tipo de inicio")
    $params = @{
    Name = "$nombreservicio"
    DisplayName = "Test Service"
    BinaryPathName = 'C:\WINDOWS\System32\svchost.exe -k netsvcs'
    StartupType = "$tipoInicio"
    DependsOn = "NetLogon"
}


try { New-Service @params -ErrorAction Stop; Write-Host "El servicio $nombreservicio ha sido creado correctamente" } 
catch {  Write-Host "El servicio con $nombreservicio no ha sido creado correctamente" }

}

function deleteService(){
    $nombreservicio = GetNameService
    sc.exe delete $nombreservicio
    Write-Host "$nombreservicio Borrado Con EXITO"

}



do{
    clear-host
    write-host -BackgroundColor Red -ForegroundColor Yellow "`t`t Administracions servicios"
    write-host -BackgroundColor Red -ForegroundColor Yellow "`t`t========================="
    Write-Host "`t`t 1.- Listar servicios por estado"
    Write-Host "`t`t 2.- Mostrar detalles servicio"
    Write-Host "`t`t 3.- Parar servicio"
    Write-Host "`t`t 4.- Arrancar servicio"
    Write-Host "`t`t 5.- Crear servicio" 
    Write-Host "`t`t 6.- Borrar servicio"
    Write-Host "`t`t 7. ---Salir---"
    [int]$opcion=Read-Host "`t`t `opcion"
    switch ($opcion){
    1 { listServices }
    2 { showDetailsoFService }
    3 { stopService }
    4 { startService }
    5 { createService }
    6 { deleteService }
    7 { Exit }
    }
    
     read-host "Pulse para continuar"
}while($opcion -ne 7)
