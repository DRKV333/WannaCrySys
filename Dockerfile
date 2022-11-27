#############
# build-env #
#############

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

WORKDIR /app

EXPOSE 80
EXPOSE 443

COPY Backend/*.sln .
COPY Backend/CaffShop.BLL/*.csproj ./CaffShop.BLL/
COPY Backend/CaffShop.DAL/*.csproj ./CaffShop.DAL/
COPY Backend/CaffShop.Shared/*.csproj ./CaffShop.Shared/
COPY Backend/CaffShop.Server/*.csproj ./CaffShop.Server/ 

RUN dotnet restore

COPY Backend/CaffShop.BLL/. ./CaffShop.BLL/
COPY Backend/CaffShop.DAL/. ./CaffShop.DAL/
COPY Backend/CaffShop.Shared/. ./CaffShop.Shared/ 
COPY Backend/CaffShop.Server/. ./CaffShop.Server/ 

COPY Backend/. ./
RUN dotnet publish -c Release -o out 

####################
# native-build-env #
####################

FROM debian:bullseye-slim AS native-build-env

WORKDIR /libcaff

RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc g++ libc6-dev cmake make \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
	
COPY libcaff/. .

RUN export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LIBRARY_PATH \
    && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .

###########
# backend #
###########

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
COPY --from=native-build-env /libcaff/build/liblibcaff.so .
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/app
ENTRYPOINT ["dotnet", "CaffShop.Server.dll"]