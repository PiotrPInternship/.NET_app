FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /dotnetapp/Booking.Server

COPY Booking.Server.API/Booking.Server.API.csproj ./Booking.Server.API/Booking.Server.API.csproj
COPY Booking.Server.DB/Booking.Server.DB.csproj ./Booking.Server.DB/Booking.Server.DB.csproj
COPY Booking.Server.Test/Booking.Server.Test.csproj ./Booking.Server.Test/Booking.Server.Test.csproj
COPY Booking.Server.sln ./Booking.Server/Booking.Server.sln

RUN dotnet restore

COPY . ./
RUN dotnet publish ./Booking.Server/Booking.Server.API/Booking.Server.API.csproj -c release -o /app --no-restore

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /dotnetapp
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "Booking.Server.API.dll"]
