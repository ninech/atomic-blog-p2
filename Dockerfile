FROM fedora

ENV GOLAND_VERSION=2017.3.3 \
    GO_VERSION=1.10

LABEL RUN='docker run --rm --name goland -v /home/${USER}/nine-goland:/home/developer -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=${DISPLAY} --security-opt label=type:container_runtime_t ninech/goland'

RUN dnf install -y which sudo git findutils java-9-openjdk util-linux-user hostname gcc dnf-plugins-core && \
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo && \
    dnf install -y docker-ce docker-compose && \
    dnf clean all && \
    adduser -u 1000 developer && \
    echo '%developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN curl https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xz && \
    mkdir /opt/goland && curl https://download-cf.jetbrains.com/go/goland-${GOLAND_VERSION}.tar.gz | tar -C /opt/goland -xz

USER 1000
ENV PATH=$PATH:/usr/local/go/bin:/home/developer/Code/golang/bin \
    GOPATH=/home/developer/Code/golang

WORKDIR /home/developer
VOLUME /home/developer

CMD /opt/goland/GoLand-${GOLAND_VERSION}/bin/goland.sh

