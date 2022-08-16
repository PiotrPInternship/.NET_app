FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
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

WORKDIR ./Booking.Server/Booking.Server.API/
#i have no idea what is wrong in line under
RUN dotnet publish -o ./binary

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /dotnetapp
COPY --from=build-env /dotnetapp/out .
ENTRYPOINT ["dotnet", "Booking.Server.API.dll"]
