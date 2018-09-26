all:  net mini mariadb run

net:
	docker network create minibanknetwork

mini: bin/minibank
	docker build -t minibank .

mariadb: 
	docker build -t mariadb ./mariadb/

run: mini mariadb
	docker run -d --name mariadb -e MYSQL_ROOT_PASSWORD=Yost12345 -v `pwd`/mariadb:/docker-entrypoint-initdb.d:ro --net minibanknetwork --link minibank mariadb
	docker run  -d  --name minibank   --net minibanknetwork minibank

bin/minibank: $(shell find $(SRCDIR) -name '*.go')
	docker run -it -v `pwd`:/usr/app \
	-w /usr/app \
	-e GOPATH=/usr/app \
	-e CGO_ENABLED=0 \
	-e GOOS=linux \
	golang:1.9 sh -c 'go get minibank && go build -ldflags "-extldflags -static" -o $@ minibank'

clean:
	docker network rm minibanknetwork	
	docker stop mariadb
	docker rm mariadb
	docker rm minibank
	sudo rm -rf bin pkg ./src/github.com ./src/golang.org




