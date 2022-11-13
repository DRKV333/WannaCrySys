FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

WORKDIR /app

EXPOSE 80

COPY *.sln .
COPY CaffShop.BLL/*.csproj ./CaffShop.BLL/
COPY CaffShop.DAL/*.csproj ./CaffShop.DAL/
COPY CaffShop.Shared/*.csproj ./CaffShop.Shared/
COPY CaffShop.Server/*.csproj ./CaffShop.Server/ 

COPY CaffShop.BLL/. ./CaffShop.BLL/
COPY CaffShop.DAL/. ./CaffShop.DAL/
COPY CaffShop.Shared/. ./CaffShop.Shared/ 
COPY CaffShop.Server/. ./CaffShop.Server/ 

RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o out 

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "CaffShop.Server.dll"]