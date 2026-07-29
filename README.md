# 🧊 aspnet-clean-arch-template

> Clean Architecture template for ASP.NET Core Web API projects

[![.NET](https://img.shields.io/badge/.NET-10.0-blueviolet)](https://dotnet.microsoft.com/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/YOUR_USERNAME/aspnet-clean-arch-template)](https://github.com/YOUR_USERNAME/aspnet-clean-arch-template/stargazers)

---

## 🌐 Language

- [English](#english)

---

## English

### What is this?

**aspnet-clean-arch-template** is a template for creating ASP.NET Core projects with Clean Architecture.

One command gives you:

- 4 layers: Domain, Application, Infrastructure, WebAPI
- Configured dependencies between layers
- Entity Framework Core + SQLite
- .NET 10.0
- Ready to run

### Quick Start

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/aspnet-clean-arch-template.git
cd aspnet-clean-arch-template
```

Make the script executable:

```bash
chmod +x scripts/create-template.sh
```

### Make the script global (optional but recommended)
To run the script from any folder, create a symbolic link:

```bash
sudo ln -s $(pwd)/create-template.sh /usr/local/bin/clean-arch
```

Create a new project:

```bash
./scripts/create-template.sh
```
or if you made the command global:
```bash
clean-arch
```

Enter project name:

```text
Enter project name: MyApp
```

Run the project:

```bash
cd MyApp/MyApp.WebAPI
dotnet run
```

### Dependency Rule

```text
WebAPI → Infrastructure → Application → Domain
```

Dependencies always point inward to Domain.

Technologies
.NET 10.0 (preview)

ASP.NET Core 10.0

Entity Framework Core 10.0.0-preview

SQLite 10.0.0-preview

```bash
# Create a blog project
./scripts/create-template.sh
> Enter project name: Blog

# Create a model in Domain
# Blog.Domain/Entities/Post.cs

# Add DbSet in Infrastructure
# Blog.Infrastructure/Data/ApplicationDbContext.cs

# Create migration
cd Blog/Blog.Infrastructure
dotnet ef migrations add InitialCreate --startup-project ../Blog.WebAPI
dotnet ef database update --startup-project ../Blog.WebAPI

# Run the API
cd ../Blog.WebAPI
dotnet run
```

***❗️❗️❗️ To make Swagger work, install Swashbuckle.AspNetCore via NuGet or using the command:***
```bash
dotnet add package Swashbuckle.AspNetCore
```
