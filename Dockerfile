FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /dotnetapp

# Copy csproj and restore as distinct layers
COPY Booking.Server/Booking.Server.API/Booking.Server.API.csproj ./Booking.Server/Booking.Server.API/Booking.Server.API.csproj
COPY Booking.Server/Booking.Server.DB/Booking.Server.DB.csproj ./Booking.Server/Booking.Server.DB/Booking.Server.DB.csproj
COPY Booking.Server/Booking.Server.Test/Booking.Server.Test.csproj ./Booking.Server/Booking.Server.Test/Booking.Server.Test.csproj
COPY Booking.Server/Booking.Server.sln ./Booking.Server/Booking.Server.sln

WORKDIR /dotnetapp/Booking.Server

RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c release -o ./Booking.Server/Booking.Server.API/

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /dotnetapp
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "Booking.Server.API.dll"]
