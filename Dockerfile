FROM debian:sid

RUN apt-get update
RUN apt-get -y install \
	gcc \
	build-essential \
	fakeroot \
	devscripts \
	bc \
	git

RUN git clone \
	--depth 1 \
	https://github.com/torvalds/linux.git /linux

RUN git clone \
	-b let_trinity_be_inity \
	--depth 1 \
	https://github.com/zined/trinity.git /trinity
