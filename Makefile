all: container push

container:
	docker build -t tonglil/nginx-basic-auth -f Dockerfile .

push:
	docker push tonglil/nginx-basic-auth
