# Obter o tamanho máximo suportado para a unidade C:
$size = Get-PartitionSupportedSize -DriveLetter C

# Redimensionar a partição C: para o tamanho máximo
Resize-Partition -DriveLetter C -Size $size.SizeMax

Write-Output "A unidade C: foi estendida para o tamanho máximo permitido."
