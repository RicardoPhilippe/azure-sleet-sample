#!/bin/sh
# Script para empacotar apenas projetos de biblioteca com versão baseada na data atual

VERSION_SUFFIX=$(date +%Y%m%d%H%M)

# Adicionando -print para depuração
find . -name "*.csproj" -print -exec sh -c '
for csproj; do
    if grep -q "<OutputType>Library</OutputType>" "$csproj" || ! grep -q "<OutputType>" "$csproj"; then
        dotnet pack --no-build -c Release -o out --version-suffix '"$VERSION_SUFFIX"' "$csproj"
    fi
done
' sh {} +