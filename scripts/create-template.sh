#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Creating Clean Architecture project${NC}"
echo "---------------------------"

# Ask for project name
read -p "Enter project name: " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Project name cannot be empty!"
    exit 1
fi

# Create project folder
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create solution
echo -e "${GREEN}📁 Creating solution...${NC}"
dotnet new sln -n "$PROJECT_NAME"

# Create projects (.NET 10)
echo -e "${GREEN}📁 Creating projects...${NC}"
dotnet new classlib -n "$PROJECT_NAME.Domain" -f net10.0
dotnet new classlib -n "$PROJECT_NAME.Application" -f net10.0
dotnet new classlib -n "$PROJECT_NAME.Infrastructure" -f net10.0
dotnet new webapi -n "$PROJECT_NAME.WebAPI" -f net10.0

# Add to solution
echo -e "${GREEN}🔗 Adding to solution...${NC}"
dotnet sln add "$PROJECT_NAME.Domain/$PROJECT_NAME.Domain.csproj"
dotnet sln add "$PROJECT_NAME.Application/$PROJECT_NAME.Application.csproj"
dotnet sln add "$PROJECT_NAME.Infrastructure/$PROJECT_NAME.Infrastructure.csproj"
dotnet sln add "$PROJECT_NAME.WebAPI/$PROJECT_NAME.WebAPI.csproj"

# Configure dependencies
echo -e "${GREEN}🔗 Configuring dependencies...${NC}"
dotnet add "$PROJECT_NAME.Application/$PROJECT_NAME.Application.csproj" reference "$PROJECT_NAME.Domain/$PROJECT_NAME.Domain.csproj"
dotnet add "$PROJECT_NAME.Infrastructure/$PROJECT_NAME.Infrastructure.csproj" reference "$PROJECT_NAME.Application/$PROJECT_NAME.Application.csproj"
dotnet add "$PROJECT_NAME.WebAPI/$PROJECT_NAME.WebAPI.csproj" reference "$PROJECT_NAME.Infrastructure/$PROJECT_NAME.Infrastructure.csproj"

# Install NuGet packages (.NET 10 preview)
echo -e "${GREEN}📦 Installing packages...${NC}"

cd "$PROJECT_NAME.Infrastructure"
dotnet add package Microsoft.EntityFrameworkCore --version 10.0.0-preview.1.25080.5
dotnet add package Microsoft.EntityFrameworkCore.Sqlite --version 10.0.0-preview.1.25080.5
dotnet add package Microsoft.EntityFrameworkCore.Design --version 10.0.0-preview.1.25080.5
cd ..

cd "$PROJECT_NAME.WebAPI"
dotnet add package Microsoft.EntityFrameworkCore.Design --version 10.0.0-preview.1.25080.5
cd ..

# Done!
echo -e "${GREEN}✅ Project '$PROJECT_NAME' created successfully!${NC}"
echo ""
echo -e "${BLUE}📁 Project structure:${NC}"
ls -la

echo ""
echo -e "${BLUE}🚀 Run:${NC}"
echo "cd $PROJECT_NAME/$PROJECT_NAME.WebAPI"
echo "dotnet run"

echo ""
echo -e "${BLUE}📦 Migrations:${NC}"
echo "cd $PROJECT_NAME/$PROJECT_NAME.Infrastructure"
echo "dotnet ef migrations add InitialCreate --startup-project ../$PROJECT_NAME.WebAPI"
echo "dotnet ef database update --startup-project ../$PROJECT_NAME.WebAPI"
