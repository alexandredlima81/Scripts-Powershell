# Diretório base onde os clientes estão localizados
$basePath = "F:\Sistemas\"

# Percorre todos os diretórios dentro de "Sistemas"
Get-ChildItem -Path $basePath -Directory | ForEach-Object {
    $ibcPath = "$($_.FullName)\ibc"

    # Verifica se o diretório "ibc" existe antes de tentar apagar os arquivos
    if (Test-Path $ibcPath) {
        # Remove todos os arquivos .tmp dentro do diretório "ibc"
        Get-ChildItem -Path $ibcPath -Filter "*.tmp" -File | Remove-Item -Force
    }
}
