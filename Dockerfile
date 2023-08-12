# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the C# project file and restore dependencies
COPY hello.csproj .
RUN dotnet restore

# Copy the remaining source code and build the application
COPY . /app
RUN dotnet publish -c Release -o out

# Create a new stage with a smaller runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the build output from the previous stage
COPY --from=build /app/out .

# Set the entry point for the application
ENTRYPOINT ["dotnet", "hello.dll"]
