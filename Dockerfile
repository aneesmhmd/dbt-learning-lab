FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && addgroup dbt \
    && useradd -ms /bin/bash -g dbt dbt

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ./dbt_tutorial/scripts/* /

RUN sed -i 's/\r//' ./entrypoint.sh && chmod +x ./entrypoint.sh && chown dbt ./entrypoint.sh

WORKDIR /usr/app

RUN chown -R dbt /usr/app

COPY . .

ENTRYPOINT ["sh", "scripts/entrypoint.sh"]

