
docker build -t rpi-image-cam .
docker run --privileged --rm -it -v C:\Users\Javier\workspace\docker-rasppi-images\rpi-image-cam:/src rpi-image-cam "%1"