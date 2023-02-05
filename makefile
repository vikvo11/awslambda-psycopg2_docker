SSL ?= 0

.PHONY:	compile
compile:
	@docker build --force-rm --build-arg PY_VER=$(PYTHON) --build-arg SSL=$(SSL) -t awslambda-psycopg2 .

	@echo "starting container..."
	@docker run --rm -t -d --name psycopg2 awslambda-psycopg2 > /dev/null
	@echo "done"
	
	@echo "coping library to build directory..."
	@rm -rf build >/dev/null
	@docker cp psycopg2:/sources/psycopg2/build build > /dev/null
	@echo "done"
	
	@echo "stopping container..."
	@docker stop psycopg2 > /dev/null
	@echo "done"

	@echo "deleting image..."
	@docker rmi awslambda-psycopg2 > /dev/null
	@echo "done"
