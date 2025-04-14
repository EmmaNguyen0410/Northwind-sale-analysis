# Set up nodejs
npm init -y
npm install express pg consistent-hash crypto
# Create a Docker image
docker build -t pgshard .
# Run 3 instances of databases (shards)
docker run --name pgshard1 -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d pgshard

docker run --name pgshard2 -p 5433:5432 -e POSTGRES_PASSWORD=postgres -d pgshard

docker run --name pgshard3 -p 5434:5432 -e POSTGRES_PASSWORD=postgres -d pgshard
