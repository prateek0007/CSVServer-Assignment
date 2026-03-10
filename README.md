# 📘 CSVServer — Solution

CSVServer 

This project runs a CSV Server inside Docker and exposes Prometheus metrics for monitoring.


## 🧩 Part I – Running CSVServer manually

STEP 1
docker pull infracloudio/csvserver:latest
docker pull prom/prometheus:v2.45.2

STEP 2
docker run -d infracloudio/csvserver:latest

docker ps -a
docker logs <container_id>
BY running this the error was :: error while reading the file "/csvserver/inputdata": open /csvserver/inputdata: no such file or directory
reason was :: container expects a file /csvserver/inputdata, which doesn’t exist.

STEP 3
created gensv.sh file 

### 1. Generate CSV input file
```bash
chmod +x gencsv.sh
./gencsv.sh 2 8

This generates `inputFile.txt` containing:
2, 456
3, 123
4, 678
5, 345
6, 987
7, 111
8, 234

STEP 4:Rn the container with input fie mounted
docker run -d -v "$(pwd)/inputFile:/csvserver/inputdata" infracloudio/csvserver:latest
docker logs <container_id>

STEP 5:Run again, exposing correct port + env var
docker run -d \
  -v "$(pwd)/inputFile:/csvserver/inputdata" \
  -e CSVSERVER_BORDER=Orange \
  -p 9393:9300 \
  infracloudio/csvserver:latest

Now open browser → http://localhost:9393
✅ You’ll see:
A table with 7 rows from inputFile
Orange border around welcome message.

Step:6 Save outputs

Files for Part I
```
gencsv.sh
inputFile.txt
part-1-cmd
part-1-output
part-1-logs
README.md


#  PART II — docker-compose setup

Stop old containers:
docker ps -aq | xargs docker rm -f

created  file docker-compose.yaml
version: '3'
services:
  csvserver:
    image: infracloudio/csvserver:latest
    ports:
      - "9393:9300"
    environment:
      - CSVSERVER_BORDER=${CSVSERVER_BORDER}
    volumes:
      - ./inputFile:/csvserver/inputdata
    env_file:
      - csvserver.env

also ctreated a  csvserver.env:
   CSVSERVER_BORDER=Orange

then run
docker-compose up -d

Check:
http://localhost:9393
 ✅

📁 Folder Structure
ASSIGNMENT/
├── docker-compose.yaml
├── inputFile.txt
├── csvserver.env
└── README.md

# PART III — Add Prometheus

Stop old containers:
docker-compose down

Now i have modify docker-compose.yaml like this:

version: '3'
services:
  csvserver:
    image: infracloudio/csvserver:latest
    ports:
      - "9393:9300"
    environment:
      - CSVSERVER_BORDER=${CSVSERVER_BORDER}
    volumes:
      - ./inputFile:/csvserver/inputdata
    env_file:
      - csvserver.env

  prometheus:
    image: prom/prometheus:v2.45.2
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml



Create prometheus.yml:

 global:
   scrape_interval: 5s

 scrape_configs:
   - job_name: 'csvserver'
     static_configs:
       - targets: ['csvserver:9300']


🚀 Run the project
# Step 1: Start containers
docker-compose up -d

# Step 2: Check running containers
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



Open:

http://localhost:9393
 → CSV app

http://localhost:9090
 → Prometheus UI

In Prometheus UI → “csvserver_records” → Execute → Graph tab
✅ You’ll see a line with value 7




# Run CSVServer container
```bash
docker run -d   -v "$(pwd)/inputFile.txt:/csvserver/inputdata"   -e CSVSERVER_BORDER=Orange   -p 9393:9300   infracloudio/csvserver:latest
```

# Verify application
- Open → [http://localhost:9393](http://localhost:9393)
- Should show 7 records with orange border.

# 4. Save outputs
```bash
curl -o ./part-1-output http://localhost:9393/raw
docker logs <container_id> >& part-1-logs



# Final Repository Checklist
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

