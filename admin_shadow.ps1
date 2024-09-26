# Definir los tipos de restauración posibles usando un diccionario
$RestoreTypes = @{
    APPLICATION_INSTALL = "APPLICATION_INSTALL"
    APPLICATION_UNINSTALL = "APPLICATION_UNINSTALL"
    CANCELED_OPERATING = "CANCELLED_OPERATION"
    MODIFY_SETTING = "MODIFY_SETTINGS"
    DEVICE_DRIVER_INSTALL = "DEVICE_DRIVER_INSTALL"
}

# Función para mostrar los puntos de restauración
function MostrarShadow { 
    try {
        $vssService = Get-Service -Name "VSS" -ErrorAction SilentlyContinue

        # Mostrar los puntos de restauración
        Get-ComputerRestorePoint        
    }
    catch {
        Write-Host "Error al intentar mostrar puntos de restauración. ¿Está el servicio VSS corriendo?"
    }
}

# Función para crear un punto de restauración
function crearShadow {
    try {
        # Verificar el estado del servicio VSS
        $vssService = Get-Service -Name "VSS" -ErrorAction SilentlyContinue
        if ($vssService.Status -ne 'Running') {
            Start-Service -Name "VSS"
            Write-Host "Servicio VSS arrancado"
        }
        
        # Solicitar la unidad y descripción
        [string]$unidad = Read-Host "Introduce el volumen del que quieres hacer el punto de restauración e.g: C:"
        [string]$descripcion = Read-Host "Descripción del por qué haces un punto de restauración"

        if ($descripcion -eq "") { 
            throw "No se admite descripción en blanco"  
        }

        # Mostrar y seleccionar tipo de restauración
        Write-Host "Tipos de posibles puntos de restauración:"
        $RestoreTypes.Keys | ForEach-Object { Write-Host $_ }
        
        [string]$tipoRestore = Read-Host "Tipo de restore point (por favor, elige uno de los tipos anteriores): "
        
        if (-not $RestoreTypes.ContainsKey($tipoRestore)) {
            throw "Tipo de restauración no válido"
        }

        Enable-ComputerRestore -Drive $unidad # Habilitar puntos de restauración en el volumen
        Checkpoint-Computer -Description $descripcion -RestorePointType $RestoreTypes[$tipoRestore] # Crear el punto de restauración

        # Mostrar los puntos de restauración después de crearlo
        Get-ComputerRestorePoint  
        Write-Host "Se ha creado un punto de restauración correctamente en el volumen $unidad."

    } catch {
        Write-Host "Error al intentar crear un punto de restauración: $_"
    }
}

# Función para restaurar un punto de restauración
function volcarPuntoRestauracion {
    try {
        # Mostrar los puntos de restauración
        Get-ComputerRestorePoint | Select-Object -Property SequenceNumber, Description, CreationTime | Format-Table
        [string]$sequenceNumber = Read-Host "Introduce el SequenceNumber del punto de restauración que deseas aplicar"

        # Aplicar la restauración
        Restore-Computer -RestorePoint $sequenceNumber
        Write-Host "El ordenador será restaurado al punto de restauración con SequenceNumber $sequenceNumber."
    }
    catch {
        Write-Host "No es posible restaurar el punto de restauración."
    }
}

# Función para borrar puntos de restauración
function borrarPunto {
    try {
        Write-Host "1. Borrar todos los puntos de restauración"
        Write-Host "2. Borrar puntos de restauración uno por uno"
        [int]$option = Read-Host "Elige una opción"

        switch ($option) {
            1 {
                $tecla = Read-Host "Escribe 'ok' para continuar"
                if ($tecla -eq "ok") {
                    Get-WmiObject -Class Win32_ShadowCopy | ForEach-Object {
                        $_.Delete()
                    }
                    Write-Host "Todos los puntos de restauración han sido eliminados."
                }
            }
            2 {
                Get-ComputerRestorePoint | Select-Object -Property SequenceNumber, Description, CreationTime | Format-Table
                [string]$sequenceNumber = Read-Host "Introduce el SequenceNumber"
                Remove-CimInstance -Query "SELECT * FROM win32_shadowcopy WHERE ID='$sequenceNumber'"
                Write-Host "El punto de restauración con SequenceNumber $sequenceNumber ha sido eliminado."
            }
        }
    }
    catch {
        Write-Host "No se ha borrado el punto de restauración. Razón: $_"
    }
}

# Menú principal
do {
    Clear-Host 
    Write-Host "Administración de puntos de restauración o shadows"
    Write-Host "======================================="
    Write-Host "1. Mostrar puntos de restauración existentes"
    Write-Host "2. Crear un punto de restauración sobre un volumen"
    Write-Host "3. Volcar un punto de restauración existente"
    Write-Host "4. Borrar un punto de restauración existente"
    Write-Host "5. Salir"

    [int]$opcion = Read-Host -Prompt "Opción"

    switch ($opcion) {
        1 { MostrarShadow }
        2 { crearShadow }
        3 { volcarPuntoRestauracion }
        4 { borrarPunto }
        5 { Write-Host "Saliendo..."; break }
        default { Write-Host "Opción no válida, intenta de nuevo." }
    }

    if ($opcion -ne 5) {
        $tecla = Read-Host "Pulsa una tecla para continuar"
    }

} while ($opcion -ne 5)
