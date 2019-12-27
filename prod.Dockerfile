FROM python:3.5-slim AS builder
RUN apt-get update && apt-get install -y --no-install-recommends build-essential gcc

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
RUN python setup.py install

FROM gcr.io/distroless/python3 as runner
COPY --from=builder /usr/local/lib/python3.5/site-packages/ /usr/local/lib/python3.5/site-packages/

ENV PYTHONPATH=/usr/local/lib/python3.5/site-packages/blueprint-0.0.1-py3.5.egg
ENTRYPOINT ["python", "-m", "blueprint"]

# TODO parametrize the version (Python and package version)
# TODO add test run to this image build