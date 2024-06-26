# Usa a imagem do SDK do .NET
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copia todos os arquivos do projeto
COPY . .

# Restaura as dependências
RUN dotnet restore

# Constrói o projeto
RUN dotnet build --no-restore -c Release

# Instala dos2unix
RUN apt-get update && apt-get install -y dos2unix

# Converte o script para formato Unix
RUN dos2unix /app/scripts/create-packages.sh

# Executa o script para identificar e empacotar apenas projetos de biblioteca
RUN /app/scripts/create-packages.sh

# Instala Sleet
RUN dotnet tool install --global Sleet

# Adiciona o caminho das ferramentas dotnet ao PATH
ENV PATH="${PATH}:/root/.dotnet/tools"

# Define o ponto de entrada para o contêiner
ENTRYPOINT ["sleet"]

# Comando padrão para iniciar o contêiner
##CMD ["push", "/app/out", "--source", "myAzureFeed", "--config", "/app/sleet.json"]
