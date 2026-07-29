#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Создание Clean Architecture проекта${NC}"
echo "---------------------------"

# Запрашиваем имя проекта
read -p "Введите имя проекта: " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Имя проекта не может быть пустым!"
    exit 1
fi

# Создаем папку проекта
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Создаем решение
echo -e "${GREEN}📁 Создание решения...${NC}"
dotnet new sln -n "$PROJECT_NAME"

# Создаем проекты (.NET 10)
echo -e "${GREEN}📁 Создание проектов...${NC}"
dotnet new classlib -n "$PROJECT_NAME.Domain" -f net10.0
dotnet new classlib -n "$PROJECT_NAME.Application" -f net10.0
dotnet new classlib -n "$PROJECT_NAME.Infrastructure" -f net10.0
dotnet new webapi -n "$PROJECT_NAME.WebAPI" -f net10.0

# Добавляем в решение
echo -e "${GREEN}🔗 Добавление в решение...${NC}"
dotnet sln add "$PROJECT_NAME.Domain/$PROJECT_NAME.Domain.csproj"
dotnet sln add "$PROJECT_NAME.Application/$PROJECT_NAME.Application.csproj"
dotnet sln add "$PROJECT_NAME.Infrastructure/$PROJECT_NAME.Infrastructure.csproj"
dotnet sln add "$PROJECT_NAME.WebAPI/$PROJECT_NAME.WebAPI.csproj"

# Настраиваем зависимости
echo -e "${GREEN}🔗 Настройка зависимостей...${NC}"
dotnet add "$PROJECT_NAME.Application/$PROJECT_NAME.Application.csproj" reference "$PROJECT_NAME.Domain/$PROJECT_NAME.Domain.csproj"
dotnet add "$PROJECT_NAME.Infrastructure/$PROJECT_NAME.Infrastructure.csproj" reference "$PROJECT_NAME.Application/$PROJECT_NAME.Application.csproj"
dotnet add "$PROJECT_NAME.WebAPI/$PROJECT_NAME.WebAPI.csproj" reference "$PROJECT_NAME.Infrastructure/$PROJECT_NAME.Infrastructure.csproj"

# Устанавливаем NuGet пакеты (.NET 10 preview)
echo -e "${GREEN}📦 Установка пакетов...${NC}"

cd "$PROJECT_NAME.Infrastructure"
dotnet add package Microsoft.EntityFrameworkCore --version 10.0.0-preview.1.25080.5
dotnet add package Microsoft.EntityFrameworkCore.Sqlite --version 10.0.0-preview.1.25080.5
dotnet add package Microsoft.EntityFrameworkCore.Design --version 10.0.0-preview.1.25080.5
cd ..

cd "$PROJECT_NAME.WebAPI"
dotnet add package Microsoft.EntityFrameworkCore.Design --version 10.0.0-preview.1.25080.5
cd ..

# Готово!
echo -e "${GREEN}✅ Проект '$PROJECT_NAME' успешно создан!${NC}"
echo ""
echo -e "${BLUE}📁 Структура проекта:${NC}"
ls -la

echo ""
echo -e "${BLUE}🚀 Запуск:${NC}"
echo "cd $PROJECT_NAME/$PROJECT_NAME.WebAPI"
echo "dotnet run"

echo ""
echo -e "${BLUE}📦 Миграции:${NC}"
echo "cd $PROJECT_NAME/$PROJECT_NAME.Infrastructure"
echo "dotnet ef migrations add InitialCreate --startup-project ../$PROJECT_NAME.WebAPI"
echo "dotnet ef database update --startup-project ../$PROJECT_NAME.WebAPI"
