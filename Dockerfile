FROM python:3.12.7-slim-bookworm

LABEL maintainer="manofcolombia"

ARG USERNAME=dcn
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ENV UV_SYSTEM_PYTHON=1
ENV UV_COMPILE_BYTECODE=1

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN apt-get update && apt-get install -y \
    git \
    gcc \
    build-essential \
    # Install netcat for wait-for-it.sh
    netcat-openbsd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# add globalsign non public cert chain to image
COPY ./certs/gsintranetsslsha256g3.crt /usr/local/share/ca-certificates/
COPY ./certs/gsnonpublicroot2.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir /app \
    && chown dcn:dcn /app

USER dcn
WORKDIR /app