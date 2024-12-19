FROM python:3.12.8-alpine3.21

LABEL maintainer="manofcolombia"

ENV USER=dcn
ENV GROUPNAME=$USER
ENV UID=1000
ENV GID=$UID

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ENV UV_SYSTEM_PYTHON=1
ENV UV_COMPILE_BYTECODE=1
ENV UV_PYTHON_PREFERENCE=system

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN apk update \
    && apk add git curl

# add globalsign non public cert chain to image
COPY ./certs/gsintranetsslsha256g3.crt /usr/local/share/ca-certificates/
COPY ./certs/gsnonpublicroot2.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN addgroup \
    --gid "$GID" \
    "$GROUPNAME" \
&&  adduser \
    --disabled-password \
    --gecos "" \
    --home "/app" \
    --ingroup "$GROUPNAME" \
    --no-create-home \
    --uid "$UID" \
    $USER

USER $USER
WORKDIR /app