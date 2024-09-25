<#
		ADMIN DACL recurso
		==================
		1. Mostrar reglas ACE de la DACL <------- ruta al recurso, mostrar reglas tanto comando powershell, como wmic
		2. Agregar nueva regla ACE a la DACL <--- ruta al recurso, pedir: permisos(control total,lectura,...), tipo(permitir,denegar)
		3. Quitar regla ACE de la DACL			objeto(nombre usuario o nombre grupo) <== una vez ok, comprobar si se ha agregado
		4. --SALIR--					(valientes: hacerlo con clases wmic)
		  opcion:_				<---- ruta al recurso, mostrar reglas ACE numeradas, pedir numero de regla a eliminar y	
								quitarla de la DACL <== si ok, comprobarlo
								(valientes: hacerlo con clases wmic)



#>


function mostrarReglasACE{

            [string]$path=Read-Host -Prompt "`n`t`t`t`t Ruta completa al fichero o directorio_"
            write-host -BackgroundColor red -ForegroundColor yellow "`t`t`t Reglas ACE de la DACL de " $path
            write-host -BackgroundColor red -ForegroundColor yellow "`t`t`t ======================== "

            (Get-Acl -Path $path).Access | Format-Table

            write-host -BackgroundColor Red -ForegroundColor yellow "`n`n`t`t`t con WMIC: ------- "
            $sd=Invoke-CimMethod -Query "SELECT * FROM Win32_LogicalFileSecuritySetting WHERE Path='$($path.Replace("\","\\"))'" -MethodName GetSecurityDescriptor
            
            #...expandimos propiedad Trustee q es un objeto Win32_Trustee, donde viene info del usuario/grupo se aplica ACE...
            $sd.Descriptor.DACL | % { $_ | Select-Object -Property * -ExpandProperty Trustee -ErrorAction Ignore}


}



function agregarNuevaReglaACE{
      
    try{        
    [string]$indentity=Read-Host "Introduce la identidad a la que se le aplicaran los permisos [usuarios/invitados]" # FullControll/Read and Allow/Deny
    [string]$permisos=Read-Host "Introduce los permisos [FullControl/Read]"
    [string]$tipo=Read-Host "Introduce el tipo de acceso al recurso[Allow/Deny]"
    [string]$ruta=Read-Host "Introduce la ruta del archivo"
    [System.Security.AccessControl.FileSystemRights]$permisos=[System.Security.AccessControl.FileSystemRights]::$permisos # Colocamos permisos full control
    [System.Security.AccessControl.AccessControlType]$tipo=[System.Security.AccessControl.AccessControlType]::$tipo # Permitimos acceso al recurso
    [System.Security.AccessControl.FileSystemAccessRule]$nuevaACE=[System.Security.AccessControl.FileSystemAccessRule]::new($indentity,$permisos,$tipo) #invoca al constructor [FileSystemAccesRule] para inicializar 
     #la nueva regla de acceso con los nuevos parametros proporcionados
    [System.Security.AccessControl.FileSecurity]$ficheroSD=Get-Acl -Path $ruta  # Obtenemos el SD del fichero, y lo convertimos en una instancia de la clase , FileSecurity
    $ficheroSD.SetAccessRule($nuevaACE) # Utilizamos la instancia para llamar a un metodo de la clase [FileSecurity] y colocar la nueva regla ACE
    Set-Acl -Path $ruta -AclObject $ficheroSD # Aplicamos el nuevo descriptor de seguridad al archivo prueba.txt utilizando Set-Acl"

        write-host "La regla ACE se ha creado"
    }catch{
        write-host "La regla ACE no ha podido crearse"
    }
}

function quitarReglaACE{
try{
    [string]$ruta=Read-Host "Introduce la ruta del archivo" # C:\Users\jorge\OneDrive\Escritorio\Nombela.txt
    $acl=Get-Acl -Path $ruta
    $constante=0
    $array=@()

    foreach($a in $acl.Access){ # acl.access obtiene todas las aces de una ruta
        $constante++
        Write-Host "Numero: $constante"
        $a
        $array+=$a
    }

    $numero=Read-Host "Elige la regla que quieres borrar por el numero de arriba" # Aqui elegimos la ace a borrar , y cogemos sus propiedaes
    $usuario=$array[$numero-1].IdentityReference
    $permisos=$array[$numero-1].FileSystemRights
    $tip=$array[$numero-1].AccessControlType
    $regla=New-Object System.Security.AccessControl.FileSystemAccessRule($usuario,$permisos,$tip)
    $acl.RemoveAccessRule($regla)
    Set-Acl -Path $ruta -AclObject $acl
    write-host "La ACE $numero ha sido eliminada"
    }catch{
        write-host "No se ha borrado la regla ACE"
    }
    }    


do
{
    clear-host
    write-host -BackgroundColor Red -ForegroundColor yellow "`t`t`t ADMIN DACL recurso"
    write-host -BackgroundColor Red -ForegroundColor yellow "`t`t`t =================="
    write-host "`t`t`t 1. Mostrar reglas ACE de la DACL"
    write-host "`t`t`t 2. Agregar nueva regla ACE a la DACL"
    write-host "`t`t`t 3. Quitar regla ACE de la DACL"
    write-host "`t`t`t 4. --SALIR--"
    
    [int]$opcion=Read-Host -Prompt "`t`t`t`t Opcion_"
    switch($opcion){
        
        1{mostrarReglasACE;break;}
        2{agregarNuevaReglaACE;break;}
        3{quitarReglaACE;break;}
        4{break;}
    }

    Read-Host "`n`n .... pulsa una tecla para continuar...."

} while ($opcion -ne 4)