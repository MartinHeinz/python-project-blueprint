FROM python:3.8-slim AS builder
RUN apt-get update && apt-get install -y --no-install-recommends build-essential gcc

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
RUN python setup.py install

FROM python:3.8.1-alpine3.11 AS runner
COPY --from=builder /usr/local/lib/python3.8/site-packages/ /usr/local/lib/python3.8/site-packages/

CMD ["python", "-m", "blueprint"]


# TODO add test run to this image build