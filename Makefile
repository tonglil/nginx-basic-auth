default: build

docker-image = dhswt/nginx-basic-auth
docker-tag = 1.2

build:
	docker build --squash \
		-t $(docker-image):$(docker-tag) \
		.

push:
	docker push $(docker-image):$(docker-tag)

show-images:
	docker images | grep "$(docker-image)"

# Remove dangling images
clean-images:
	docker images -a -q \
		--filter "reference=$(docker-image)" \
		--filter "dangling=true" \
	| xargs docker rmi

# Remove all images
clear-images:
	docker images -a -q \
		--filter "reference=$(docker-image)" \
	| xargs docker rmi
