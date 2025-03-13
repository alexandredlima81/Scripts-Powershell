#
#--------------------Geral--------------------#
#

# Nome do Script :template.sh
# Descrição: Modelo template para padronizar programas em shell script
# utilizados pela Agrotis Agroinformática LTDA.
#
# Repositório: xxxxxx.com.br
#
# Autor: Alexandre Farias Lima - Analista de Infraestrutura
# E-mail: alexandre.lima@agrotis.com
# Data de criação: 13/05/2024
#
# Manutenção: Colaborador Y - Analista de DevOps
# E-mail: colabor(a).y@agrotis.com


#
#--------------------Histórico de Versionamento-------------------#
#

# Controle de versão e alterações devem ser tratadas via sistema de versionamento.

#
#--------------------Objetivo-------------------#
#

# Este script em bash tem como objetivo automatizar a verificação da operacionalidade 
# de um domínio (no exemplo dado, o domínio é "example.com") e reiniciar o serviço 
# BIND (um servidor de nomes de domínio) caso o domínio não esteja operacional.
# Ele também gera logs caso durante a verificação da operacionalidade ele identifique que 
# um domínio não esteja operacional. E no primeiro sábado de cada mês, ele realiza a limpeza
# dos logs que egerados por ele quado identifica um dominio indisponivel.




# Diretório base onde os clientes estão localizados
$basePath = "F:\Sistemas\"
$folders = @("ClienteA", "ClienteB", "ClienteC")

# Criar pastas e adicionar arquivos
foreach ($folder in $folders) {
    $ibcPath = "$basePath\$folder\ibc"

    # Criar a pasta se não existir
    if (!(Test-Path $ibcPath)) {
        New-Item -Path $ibcPath -ItemType Directory -Force
    }

    # Criar 100 arquivos .tmp dentro da pasta ibc
    for ($i = 1; $i -le 100; $i++) {
        New-Item -Path "$ibcPath\arquivo_$i.tmp" -ItemType File -Force
    }
}

Write-Host "Arquivos .tmp criados com sucesso!"
