CSVServer Assignment

This project runs a CSV Server inside Docker and exposes Prometheus metrics for monitoring.

📁 Folder Structure
ASSIGNMENT/
├── docker-compose.yaml
├── inputFile.txt
├── csvserver.env
└── README.md

🚀 Run the project
Step 1: Start containers
docker-compose up -d

Step 2: Check running containers
docker ps

You should see something like:

CONTAINER ID   IMAGE                           STATUS         PORTS
abc123def456   infracloudio/csvserver:latest   Up 2 mins      0.0.0.0:9393->9300/tcp
xyz789ghi012   prom/prometheus:latest          Up 2 mins      0.0.0.0:9090->9090/tcp

🌐 Verify Services
   Service          	  URL                        	Description
   CSV Server	  http://localhost:9393   Displays table with orange border
   Prometheus	  http://localhost:9090   Monitoring metrics dashboard

⚙️ Environment Variables
.env file (csvserver.env) contains:
  
  CSVSERVER_BORDER=Orange

📊 Prometheus Target
Prometheus scrapes metrics from the CSV Server endpoint:

- job_name: 'csvserver'
  static_configs:
    - targets: ['csvserver:9300']

If csvserver hostname fails, replace with:

- targets: ['host.docker.internal:9300']

🧾 Sample input file

inputFile.txt:

2, 294
3, 872
4, 199
5, 108
6, 455
7, 40
8, 899

🧹 Stop and Clean Up
docker-compose down

✅ Output Preview

CSVServer Page:
🟧 Table visible with orange border and data rows.

Prometheus Page:
✅ Job status = UP
✅ Target = csvserver:9300
✅ Metrics visible at /metrics endpoint

💬 Author

Prateek Mall


