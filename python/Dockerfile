FROM python:3
WORKDIR /qa
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN python3 --version
RUN pytest --version