# Obtém o número do disco onde está a unidade C:
$diskNumber = (Get-Partition | Where-Object { $_.DriveLetter -eq "C" }).DiskNumber
Write-Host "DEBUG: Número do disco onde está a unidade C: $diskNumber"

if ($diskNumber -ne $null) {
    Write-Host "O disco do C: é o Disco $diskNumber"

    # Criar um script temporário para listar partições no DISKPART
    $diskpartScript = @"
select disk $diskNumber
list partition
"@
    $scriptPath = "$env:TEMP\diskpart_list.txt"
    $diskpartScript | Set-Content -Path $scriptPath

    Write-Host "DEBUG: Executando DISKPART para listar partições..."
    
    # Executa diskpart e captura a saída
    $diskpartOutput = diskpart /s $scriptPath
    Write-Host "DEBUG: Saída do DISKPART ao listar partições:"
    Write-Host $diskpartOutput

    # Procura pela linha que contém "Recovery" e extrai o número da partição
    $recoveryPartition = $diskpartOutput | Where-Object { $_ -match "Recovery" }

    if ($recoveryPartition) {
        # Extraindo o número da partição corretamente usando regex
        if ($recoveryPartition -match "Partition\s+(\d+)") {
            $partitionNumber = $matches[1]
            Write-Host "DEBUG: Número da partição de recuperação identificado: $partitionNumber"

            # Criar um novo script para excluir a partição
            $deleteScript = @"
select disk $diskNumber
select partition $partitionNumber
delete partition override
"@
            $deleteScriptPath = "$env:TEMP\diskpart_delete.txt"
            $deleteScript | Set-Content -Path $deleteScriptPath

            Write-Host "DEBUG: Executando DISKPART para excluir a partição..."
            
            # Executa diskpart para deletar a partição
            Start-Process -FilePath "diskpart.exe" -ArgumentList "/s $deleteScriptPath" -Wait -NoNewWindow

            # Verifica novamente se a partição foi removida
            Write-Host "DEBUG: Validando se a partição foi removida..."
            $diskpartOutputAfter = diskpart /s $scriptPath
            Write-Host "DEBUG: Saída do DISKPART após a tentativa de remoção:"
            Write-Host $diskpartOutputAfter

            # Verificar se a partição ainda existe
            if ($diskpartOutputAfter -match "Recovery") {
                Write-Host "Erro: A partição de recuperação ainda existe. Tente executar manualmente o comando:"
                Write-Host "`nselect disk $diskNumber`nselect partition $partitionNumber`ndelete partition override"
            } else {
                Write-Host "✅ Partição de recuperação removida com sucesso!"
            }
        } else {
            Write-Host "Erro: Não foi possível extrair o número da partição de recuperação."
        }
    } else {
        Write-Host "Nenhuma partição de recuperação encontrada no disco do C:."
    }
} else {
    Write-Host "Erro: Não foi possível identificar o disco onde está a unidade C:."
}
