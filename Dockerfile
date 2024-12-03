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

RUN apt-get update && apt-get install -y git

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir /app \
    && chown dcn:dcn /app

USER dcn
WORKDIR /app