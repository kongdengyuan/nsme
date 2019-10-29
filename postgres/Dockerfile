FROM postgres:11-alpine

ENV POSTGRES_DB X4DB

COPY schema.sql /docker-entrypoint-initdb.d/

EXPOSE 5432
