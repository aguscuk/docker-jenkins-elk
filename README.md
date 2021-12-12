# docker-jenkins-elk

Cara penggunaan:

git clone https://github.com/aguscuk/docker-jenkins-elk.git

cd docker-jenkins-elk

cp -p .env.template .env

docker-compose build

docker-compose up -d

Akses Jenkins: http://localhost:8080

Akses Elasticsearch: http://localhost:9200

Cek index: http://localhost:9200/_cat/indices

Akses Kibana: http://localhost:9200
