# See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Debug
ARG HUSKY=0
WORKDIR /src
COPY ["dotnet/dotnet.csproj", "dotnet/"]
RUN dotnet restore "dotnet/dotnet.csproj"
COPY . .
WORKDIR "/src/dotnet"
RUN dotnet build "dotnet.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Debug
ARG PRODUCT_VERSION=0.0.0
ARG FILE_VERSION=0.0.0.0
ARG HUSKY=0
RUN dotnet publish "dotnet.csproj" -p:Version=$FILE_VERSION -p:InformationalVersion=$PRODUCT_VERSION -c $BUILD_CONFIGURATION  -o /app/publish

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS plugins
ARG BUILD_CONFIGURATION=Debug
ARG HUSKY=0
WORKDIR /plg
COPY ["dotnet.plugins/dotnet.plugins.csproj", "dotnet.plugins/"]
RUN dotnet restore "dotnet.plugins/dotnet.plugins.csproj"

COPY . .
WORKDIR "/plg/dotnet.plugins"
RUN dotnet build "dotnet.plugins.csproj" -c $BUILD_CONFIGURATION -o /app/plg

FROM base AS final
WORKDIR /app
COPY ["certs", "certs"]
WORKDIR /app
COPY --from=publish /app/publish .
RUN mkdir -p ./Plugins
COPY --from=plugins /app/plg/plugin.one.dll /app/plg/plugin.two.dll /app/plg/plugin.three.dll ./Plugins/
ENTRYPOINT ["dotnet", "dotnet.dll"]