FROM ubuntu:22.04

ENV USERNAME="devuser"

# Dependency Versions
ENV PYTHON_VERSION=3.10

# Update dependencies
RUN apt update && apt upgrade -y
RUN apt install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-venv \
    python3-pip git \
    pkg-config python3-dev build-essential software-properties-common \
    default-libmysqlclient-dev && \
    add-apt-repository -y ppa:deadsnakes/ppa

# Create developer user
RUN useradd -ms /bin/bash ${USERNAME}
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Copy over necessary files for astoria and install pip requirements
WORKDIR /home/${USERNAME}/astoria/
COPY requirements.txt ./
COPY ./bot bot
COPY .env .env
RUN pip install -r requirements.txt

ENTRYPOINT ["python3", "bot/bot.py"]
