# 📘 CSVServer Assignment — Solution

## 🧩 Part I – Running CSVServer manually

### 1. Generate CSV input file
```bash
chmod +x gencsv.sh
./gencsv.sh 2 8
```
This generates `inputFile.txt` containing:
```
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





