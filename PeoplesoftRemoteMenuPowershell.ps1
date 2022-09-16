function BuildMenu
{
    <# 
    Os parametros devem ser passados na seguinte sequencia 
    Primeiro parametro e o Titulo, do segundo em diante quantos itens de menu quiser e o ultimo parametro o comando de sair do menu 
    ex (Titulo, opcaodomenu1...n, exit)
    #>
    $i=1
    
    Write-Host "====================== $($args[0]) ====================== "
    do {
    if ($i -ne $args.Count-1){
        Write-Host "$i - $($args[$i]) " 
    }
    else {
        $MenuExitOpt=$($args[$i]).ToString().ToUpper()
        if($MenuExitOpt -eq "EXIT"){
            Write-Host "q - $($args[$i])"
        }
        if($MenuExitOpt -eq "RETURN"){
            Write-Host "r - $($args[$i])"
        }
        if($MenuExitOpt -eq " "){
            Write-Host " "
        }
    }
    $i++
    }while ($i -ne $args.Count)
}
function BuildSubMenu ([string]$PSENV, [string]$PSEnvHome)
{
   #Passe apenas o nome do ambiente
    Write-Host "====================== $PSENV PSADMIN ======================"
    Write-Host ""
    Write-Host "Shutdown Options"
    Write-Host "1 - Shutdown All"
    Write-Host "2 - Shutdown App Server"
    Write-Host "3 - Shutdown Process Scheduler"
    Write-Host ""
    Write-Host "Startup Options"
    Write-Host "4 - Startup All"
    Write-Host "5 - Startup App Server"
    Write-Host "6 - Startup Process Scheduler"
    Write-Host ""
    Write-Host "Misc Options"
    Write-Host "7 - Status all"
    Write-Host "8 - Status App Server"
    Write-Host "9 - Status Process Scheduler"
    [int]$PSChoice = Read-Host "Choose your Option"
    PSADMINEEXC $PSChoice $PSENV $PSEnvHome
}
function Get-Credential
{
$rsiusername = Read-Host "Enter your Username"
$rsipassword = Read-Host "Enter your password" -AsSecureString
$rsiCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($rsiusername, $rsipassword) 
return $rsiCred
}
function PSADMINEEXC ([int]$PSChoice, [string]$PSEnv, [string]$PSEnvHome)
{
    <#
    .DESCRIPTION
    Executa comandos administrativos peoplesoft no ambiente remoto
    
    .PARAMETER PSChoice
    Numero inteiro que cordenara a execucao da escolha feita no menu
    
    .PARAMETER PSEnv
    Ambiente peoplesoft em qual o comando sera executado exemplo (FSTST, FSPROD e etc)
    
    .PARAMETER PSAdminHome
    PSHome do ambiente em que sera executado o comando
    
    .EXAMPLE
    PSADMINEEXC 1 FSTST "D:\FS910\appserv\psadmin"
    
    .NOTES
    Cuidado ao baixar um ambiente com grandes poderes vem grandes responsabilidades
    #>
    $rsiCred = Get-Credential
    switch ($PSChoice)
    {    
        '1' {            
            Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -c shutdown -d $PSEnv 2>&1"}
            Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -p stop -d $PSEnv 2>&1"}
            pause
            $PSEnv
        }
        '2' {
        Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -c shutdown -d $PSEnv 2>&1"}
        pause
        $PSEnv
        }
        '3' {
        Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -p stop -d $PSEnv 2>&1"}
        pause
        $PSEnv
        }
        '4'{
        Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -c boot -d $PSEnv 2>&1"}
        Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -p start -d $PSEnv 2>&1"}
        pause
        $PSEnv
        }
        '5'{
        Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -c boot -d $PSEnv 2>&1"}
        pause
        $PSEnv
        }
        '6'{
        Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -p start -d $PSEnv 2>&1"}
        pause
        $PSEnv
        }
        '7'{
        Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -c sstatus -d $PSEnv 2>&1"}
        Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -p status -d $PSEnv 2>&1"}
        pause
        $PSEnv
        }
        '8'{
        Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -c sstatus -d $PSEnv 2>&1"}
        pause
        $PSEnv
        }
        '9'{
        Invoke-Command -ComputerName vFINAPPS.guestservices.com -Credential $rsiCred -ScriptBlock {cmd /c "$PSAdminHome -p status -d $PSEnv 2>&1"}
        pause
        $PSEnv
        }
    }
}

function Show-Menu
{
    # A variavel string para o nome do menu eu mantive pra facilitar a visualizacao na hora de passar o parametro
    [string]$MenuTitle = 'REMOTE PSADMIN'
    Clear-Host
    BuildMenu $MenuTitle FSCM HCM Exit

    $rsiselection = Read-Host "Choose your destiny"
    switch ($rsiselection)
        {
        '1' {FIN-Menu}
        '2' {HCM-Menu}
        'q'{exit}
        }
}

function FIN-Menu
{
    # A variavel string para o nome do menu eu mantive pra facilitar a visualizacao na hora de passar o parametro
    [string]$MenuTitle = 'VFINAPPS PSADMIN'
    Clear-Host
    BuildMenu $MenuTitle FSTST FSPROD return

    $rsiselectionF = Read-Host "Choose your Env"
    switch ($rsiselectionF)
        {
        '1' {FSTST}
        '2' {FSPROD}
        'r'{return}
        }
}

function HCM-Menu
{
    # A variavel string para o nome do menu eu mantive pra facilitar a visualizacao na hora de passar o parametro
    [string]$MenuTitle = 'VHRAPPS PSADMIN'
    Clear-Host
    BuildMenu $MenuTitle HRDEV HRTST HRPROD return

    $rsiselectionH = Read-Host "Choose your Env"
    switch ($rsiselectionH)
    {
        '1' {HRDEV}
        '2' {HRTST}
        '3' {HRPROD}
        'r'{return}
    }
}
function FSTST
{
    clear-variable rsi*
    [string]$PSENV = 'FSTST'
    [string]$PSEnvHome = 'D:\FS910\appserv\psadmin'
    Clear-Host
    BuildSubMenu $PSENV $PSEnvHome
}

function HRTST
{
    clear-variable rsi*
    [string]$PSENV = 'HRTST'
    [string]$PSEnvHome = 'D:\HR910\appserv\psadmin'
    Clear-Host
    BuildSubMenu $PSENV $PSEnvHome
}

function HRDEV
{
    clear-variable rsi*
    [string]$PSENV = 'HRDEV'
    [string]$PSEnvHome = 'D:\HR910\appserv\psadmin'
    Clear-Host
    BuildSubMenu $PSENV $PSEnvHome
}


do
{
Show-Menu -Title 'Remote PSADMIN Menu'
}
until ($rsiselection -eq 'q')
