function backupTotal{

try{
$rutaPorDefecto="backup\total_"
$rutaOrigen= Read-host "Introduce la direccion de origen del que quieres hacer backup" # C:\Users\jorge\OneDrive\Documents
$nombreCarpeta=Split-Path $rutaOrigen -Leaf
$fechaActual=Get-date -Format "_dd_MMMM_yyyy"
$rutaDestino=Read-host "Introduce la direccion de destino donde se guardara el backup" # C:\Windows\Temp\

$destinoCompletado=$rutaDestino+$rutaPorDefecto+$fechaActual


if(!$(Test-Path -Path $destinoCompletado)){
            mkdir $destinoCompletado
            Copy-Item -path $rutaOrigen -Destination $destinoCompletado -Recurse
            write-host "Se ha creado una carpeta backup y se ha completado el backup en $destinoCompletado"
    }else{
            Copy-item -Path $rutaOrigen -Destination $destinoCompletado -Recurse
            write-host "Backup total en $destinoCompletado ha sido completado"
    }

    }catch{
        write-host "No se ha podido hacer el backup total"
    }
}



function backupIncremental{

try{
    $rutaPorDefecto="\Incremental_"
    $rutaOrigen=read-host "Introduce la direccion de origen del que quieres hacer el backup" #  C:\Windows\Temp\backup\total__07_marzo_2024 C:\Users\jorge\Documents #C:\Windows\Temp
    $nombreCarpeta=Split-Path $rutaOrigen -Leaf
    $fechaActual=Get-date -Format "_dd_MMMM_yyyy"

    $rutaBackupTotal = Read-host "Introduce la ruta del Backup total"
    $rutaDestino = read-host "Introduce la direccion de destino donde se guardara el backup"
    $destinoCompletado =$rutaDestino+$rutaPorDefecto+$nombreCarpeta+$fechaActual

    $ficherosOrigen = Get-ChildItem -Path $rutaOrigen
    $ficherosTotal = Get-ChildItem -Path $rutaBackupTotal

    $ficheros = Compare-Object -ReferenceObject $ficherosOrigen -DifferenceObject $ficherosTotal -Property Name, LastWriteTime | Where-Object { $_.SideIndicator -eq "<=" }
            foreach($fich in $ficheros){
                $ficherosCopiar="$rutaOrigen\"+$fich.Name
                Copy-item -Path "$ficherosCopiar" -Destination $destinoCompletado
            }
     write-host "Backup incremental en $destinoCompletado ha sido completado"
}catch{
     write-host "No se ha podido hacer el backup incremental"
      }
}


#region----------------MAIN---------------------------
do{
    clear-host
    Write-Host ""
    Write-Host "==ADMIN BACKUPS=="
    Write-Host "==========="
    Write-Host "1. Backup Total"
    Write-Host "2. Backup Incremental"
    Write-Host "3. Salir"
    $option=Read-Host "ELIGE UNA OPCION"

    switch($option){
    1{backupTotal;break;}
    2{backupIncremental;break;}
    3{break;}
    }
    [string]$tecla = read-host "Pulsa una tecla para continuar"
}while($option -ne 3);