# aras-innovator-28-automation
Automating aras Installation
📘 Aras Innovator 36 – Automated Installation (Windows + Jenkins Pipeline)

This repository contains a complete automation framework to install Aras Innovator 36 using:

✔ PowerShell
✔ SQL automation
✔ Jenkins Pipeline
✔ Windows Server (2019/2022)

The goal of this repo is to make Aras installation repeatable, automated, and beginner friendly.

🚀 Repository Structure
aras-innovator-36-automation/
│
├── installers/                 # Place all offline installers here
│     ├── Aras_36_Setup.exe
│     ├── dotnet-hosting-8.0.x-win.exe
│     ├── vc_redist.x64.exe
│
├── scripts/                    # PowerShell automation scripts
│     ├── 01-install-prereqs.ps1
│     ├── 02-configure-sql.ps1
│     ├── 03-install-aras.ps1
│     ├── 04-run-arasupdate.ps1
│
├── sql/                        # SQL scripts
│     └── create_innovator_db.sql
│
├── jenkins/                    # Jenkins CI/CD pipeline
│     └── Jenkinsfile
│
└── README.md

📦 Prerequisites Required for Aras 36
Component	Version
Windows Server	2019 / 2022
SQL Server	2019 / 2022
.NET Hosting Bundle	.NET 8
Visual C++ Redistributable	2015–2022 (x64)
IIS Features	Enabled (included in script)
Aras Innovator Installer	Aras_36_Setup.exe
🔧 Automation Flow Overview
1️⃣ Install prerequisites

Installs IIS roles + .NET 8 Hosting Bundle + VC++ Redistributable.

✔ Script → scripts/01-install-prereqs.ps1

2️⃣ Configure SQL Server

Creates the Innovator36 database automatically.

✔ Script → scripts/02-configure-sql.ps1
✔ SQL → sql/create_innovator_db.sql

3️⃣ Install Aras Innovator (GUI installer)

Launches the Aras 36 installer.

✔ Script → scripts/03-install-aras.ps1

4️⃣ Run ArasUpdate (optional packages)

Runs the ArasUpdate tool for package deployment.

✔ Script → scripts/04-run-arasupdate.ps1

🧪 Jenkins Pipeline (CI/CD)

The Jenkinsfile performs:

✔ Checkout repository
✔ Run prereq installation
✔ Configure SQL DB
✔ Start Aras installer
✔ Run ArasUpdate
✔ Send result output



Pipeline file:
👉 jenkins/Jenkinsfile

▶️ How to Run the Jenkins Pipeline
1. Create a Jenkins Job

Choose:

Pipeline → SCM (Git)

Paste your repo URL:

https://github.com/Kranti9892/aras-innovator-36-automation.git

2. Add Jenkins Credential

Name:

sql-sa-password


This is used by:

env.SA_PASSWORD

3. Run the pipeline

Jenkins will:

Install prerequisites

Create Innovator database

Launch Aras 36 installer

Run ArasUpdate

🙌 Author

Automation repository developed for learning and real-world DevOps deployment of Aras Innovator.
