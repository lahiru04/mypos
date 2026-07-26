# FreePOS (WPF)

Small POS (Point Of Sale) WPF application targeting .NET Framework 4.8.

This repository contains the FreePOS WPF desktop application and supporting data scripts.

## Quick overview
- UI: WPF (Views in `FreePOS Application/Views/`)
- Business logic: `FreePOS Application/bll/`
- Data access: lightweight Dapper models & repos in `FreePOS Application/data/dapper/`
- Project file: `FreePOS Application/FreePOS Application.csproj`

## Requirements
- Windows with Visual Studio (tested with Visual Studio Community 2026)
- .NET Framework 4.8
- MySQL / MariaDB server (the app defaults to MySQL), or use the provided SQL Server script
- NuGet packages (restored by Visual Studio): Dapper, Dapper.Contrib, MySql.Data, Newtonsoft.Json, etc.

## Database files
- `FreePOS Application/data/freepos.sql` — original MySQL / MariaDB dump (tables, sample data, foreign keys). Used by the app to create a MySQL DB.
- `FreePOS Application/data/freepos-sqlserver.sql` — SQL Server-compatible script generated from the MySQL dump (basic conversion + sample rows). Review before running.

Notes:
- The app's database connection is built from settings (see `FreePOS Application/bll/AppSetting.cs`).
- The runtime connection string is exposed in `FreePOS Application/data/dapper/databaseutils.cs` (default: `Server=localhost;Database=freepos;Uid=root;Pwd=...;`).
- Use the UI → Settings → Database screen (DatabaseSettingWindow) to change DB server/name/credentials. The app can attempt to create the database using `FreePOS Application/data/freepos.sql`.

## How to build & run
1. Open `FreePOS-wpf.sln` in Visual Studio (solution file at repository root).
2. Restore NuGet packages (Visual Studio does this automatically on build).
3. Configure database settings:
   - Run the app and open Database Settings (or edit application settings) and set DatabaseServer, DatabaseName, DatabaseUsername, DatabasePassword.
   - The app can create the database for MySQL by running the `FreePOS Application/data/freepos.sql` script (it replaces the default database name with your configured one).
4. Build and run the application.

## New / important behavior
- Sales: when a new sale is made from the sale UI, the application creates accounting transactions (existing behavior) and also persists:
  - `invoice` — header record (invoice_no, customer, amount, added_by)
  - `invoice_item` — per-product rows (product_id, qty)
  - `invoice_payment` — payment row when payment is made (payment_type default = cash)

These models and repositories live in `FreePOS Application/data/dapper/invoice.cs` and are used from `FreePOS Application/bll/saleutils.cs`.

## Key folders / files
- `FreePOS Application/Views/` — WPF windows and user controls (sale UI is `FreePOS Application/Views/finance/salenew.xaml`)
- `FreePOS Application/bll/` — business logic helpers (saleutils, financeutils, printing, inventoryutils, databaseutils)
- `FreePOS Application/data/dapper/` — Dapper DTOs and simple repository classes for DB access
- `FreePOS Application/data/freepos.sql` — original MySQL dump
- `FreePOS Application/data/freepos-sqlserver.sql` — SQL Server script (generated)

## Troubleshooting
- Build error: missing database script referenced from the project — ensure `FreePOS Application/data/freepos-sqlserver.sql` exists (this repo includes a generated script).
- Connection issues: verify DB server is running and credentials are correct in Settings. `FreePOS Application/bll/databaseutils.cs` contains the logic used to check/connect.

## Development notes
- The app stores some sample passwords in the SQL dump in plaintext. For production, replace with secure hashes.
- Monetary fields are a mix of `float` and `decimal` in the original dump; decimal is preferable for money values.

## License & contact
This repository is a development workspace. For questions about the code, open an issue or contact the maintainer.
