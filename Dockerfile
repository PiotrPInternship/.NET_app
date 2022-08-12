FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /usr/src/dotnetapp

# Copy csproj and restore as distinct layers
COPY ./Booking.Server/Booking.Server.API/Booking.Server.API.csproj ./
COPY ./Booking.Server/Booking.Server.DB/Booking.Server.DB.csproj ./
COPY ./Booking.Server/Booking.Server.Test/Booking.Server.Test.csproj ./
COPY ./Booking.Server/Booking.Server.sln ./

WORKDIR /usr/src/dotnetapp/Booking.Server

RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "dotnetapp.dll"]
