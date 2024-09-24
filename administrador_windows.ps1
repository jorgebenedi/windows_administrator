 function arrancarProceso{
   [string]$nombre=Read-host "Nombre del proceso"
   Start-process $nombre

 }

 function pararProceso{
   [string]$nombre=Read-host "Nombre del proceso"
   Stop-Process -Name $nombre

 }


 function suspenderProceso{
   [string]$nombre=Read-host "Nombre del proceso"
   Wait-Process -Name $nombre
 }


function verEstadoHilosProceso {
    $nombreProceso = Read-Host "Nombre del proceso para saber estado de los hilos"
    $proceso = Get-Process -Name $nombreProceso -ErrorAction SilentlyContinue

    if ($proceso -eq $null) {
        Write-Host "Proceso no encontrado"
    } else {
        $cont = 0
        $proceso.Threads.ForEach({
            Write-Host "Hilo ${cont}: Estado - $($_.ThreadState), Razón de espera - $($_.WaitReason)"
            $cont++
        })
    }
}


 function cambiarPrioridadHilos{
    $nombreProceso = Read-Host "Nombre del proceso para cambiar prioridad de hilos"
    $proceso = Get-Process -Name $nombreProceso -ErrorAction SilentlyContinue

    if ($proceso -eq $null) {
        Write-Host "Proceso no encontrado"
    } else {
        $hilos = $proceso.Threads
        $hilos | ForEach-Object { Write-Host "Hilo ID: $($_.Id), Prioridad actual: $($_.PriorityLevel)" }
        
        $nuevaPrioridad = Read-Host "Nueva prioridad para los hilos (Lowest, BelowNormal, Normal, AboveNormal, Highest, TimeCritical)"
        
        $hilos | ForEach-Object { $_.PriorityLevel = $nuevaPrioridad }
        Write-Host "Prioridad de hilos cambiada exitosamente"
    }

 }

 # Cambia la prioridad del proceso completo, afectando a todos sus hilos
function cambiarPrioridadProcesosHilos {
    $nombreProceso = Read-Host "Introduce el nombre del proceso"
    
    $prioridad = Read-Host "Introduce la nueva prioridad (Normal, Idle, High, RealTime, BelowNormal, AboveNormal)"

    $proceso = Get-Process -Name $nombreProceso -ErrorAction SilentlyContinue
    if ($proceso) {
        Write-Output "La prioridad actual del proceso '$nombreProceso' es '$($proceso.PriorityClass)'."
        $proceso.PriorityClass = $prioridad
        Write-Output "La prioridad del proceso '$nombreProceso' se ha cambiado a '$prioridad'."
    } else {
        Write-Output "No se encontró ningún proceso con el nombre '$nombreProceso'."
    }
}
 


 [int]$opcion=0
 while($opcion -ne 7){
     clear-host
     write-host -backgroundcolor red -foregroundcolor yellow "`t`t Admin process/threads"
     write-host -backgroundcolor red -foregroundcolor yellow "`t`t ======================"
     write-host "`t`t 1-Arrancar proceso"
     write-host "`t`t 2-Parar proceso"
     write-host "`t`t 3-Suspender proceso"
     write-host "`t`t 4-Ver estado hilos de un proceso"
     write-host "`t`t 5-Cambiar prioridad de hilos de un proceso"
     write-host "`t`t 6-Cambiar prioridad de un proceso"
     write-host "`t`t 7-Salir"
     [int]$opcion=Read-Host "opcion"

        switch($opcion)
        {
           1 { ArrancarProceso }
           2 { pararProceso }
           3 { suspenderProceso }
           4 { verEstadoHilosProceso }
           5 { cambiarPrioridadHilos }
           6 { cambiarPrioridadProcesosHilos }
         }

        if ($opcion -ne 7) {
            [string]$tecla = read-host "Pulsa una tecla para continuar"
    }
}