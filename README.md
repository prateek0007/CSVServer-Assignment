# 📘 CSVServer Assignment — Solution

## 🧩 Part I – Running CSVServer manually

### 1. Generate CSV input file
```bash
chmod +x gencsv.sh
./gencsv.sh 2 8
```
This generates `inputFile.txt` containing:
```
=======
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
Service	URL	Description
CSV Server	http://localhost:9393
	Displays table with orange border
Prometheus	http://localhost:9090
	Monitoring metrics dashboard
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

>>>>>>> 3453808b32423ffe8f1ac41a409c561c0b88fdf4
2, 294
3, 872
4, 199
5, 108
6, 455
7, 40
8, 899

```

### 2. Run CSVServer container
```bash
docker run -d   -v "$(pwd)/inputFile.txt:/csvserver/inputdata"   -e CSVSERVER_BORDER=Orange   -p 9393:9300   infracloudio/csvserver:latest
```

### 3. Verify application
- Open → [http://localhost:9393](http://localhost:9393)
- Should show 7 records with orange border.

### 4. Save outputs
```bash
curl -o ./part-1-output http://localhost:9393/raw
docker logs <container_id> >& part-1-logs
```

### 5. Files for Part I
```
gencsv.sh
inputFile.txt
part-1-cmd
part-1-output
part-1-logs
README.md
```

---

## 🧩 Part II – Using Docker Compose

### 1. Environment file (`csvserver.env`)
```
CSVSERVER_BORDER=Orange
```

### 2. Docker Compose file (`docker-compose.yaml`)
```yaml
services:
  csvserver:
    image: infracloudio/csvserver:latest
    ports:
      - "9393:9300"
    env_file:
      - csvserver.env
    volumes:
      - ./inputFile.txt:/csvserver/inputdata
```

### 3. Run the setup
```bash
docker-compose up -d
```

### 4. Verify
Open [http://localhost:9393](http://localhost:9393)  
✅ App running with orange border and 7 records.

---

## 🧩 Part III – Prometheus Integration

### 1. Prometheus configuration (`prometheus.yml`)
```yaml
global:
  scrape_interval: 5s

scrape_configs:
  - job_name: 'csvserver'
    static_configs:
      - targets: ['csvserver:9300']
```

### 2. Updated `docker-compose.yaml`
```yaml
services:
  csvserver:
    image: infracloudio/csvserver:latest
    ports:
      - "9393:9300"
    env_file:
      - csvserver.env
    volumes:
      - ./inputFile.txt:/csvserver/inputdata

  prometheus:
    image: prom/prometheus:v2.45.2
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    depends_on:
      - csvserver
```

### 3. Run everything
```bash
docker-compose down
docker-compose up -d
```

### 4. Verify Prometheus
Open [http://localhost:9090](http://localhost:9090)  
→ Query: `csvserver_records`  
→ Go to **Graph tab**  
✅ We’ll see a straight line graph with value = 7.

---

## ✅ Final Repository Checklist
```
gencsv.sh
inputFile.txt
part-1-cmd
part-1-output
part-1-logs
csvserver.env
docker-compose.yaml
prometheus.yml
README.md
```





=======

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

