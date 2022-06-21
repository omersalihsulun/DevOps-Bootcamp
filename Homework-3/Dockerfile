FROM python:3.9 as build
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
build-essential \
ca-certificates \
curl \
git \
libssl-dev 

WORKDIR /opt/data
RUN python -m venv /opt/data/venv
ENV PATH="/opt/data/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade -U -r requirements.txt

ENV PATH="/opt/data/venv/bin:$PATH"
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]