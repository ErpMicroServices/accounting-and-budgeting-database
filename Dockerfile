FROM postgres:9

ENV POSTGRES_DB=accounting-and-budgeting_database
ENV POSTGRES_USER=accounting-and-budgeting_database
ENV POSTGRES_PASSWORD=accounting-and-budgeting_database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib
