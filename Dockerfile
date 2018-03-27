FROM python:3.6.4-alpine

RUN pip install flake8 \
    && rm -rf /root/.cache

COPY ./ /root/drone-example
WORKDIR /root/drone-example

ENTRYPOINT ["/root/drone-example/entrypoint.sh"]
CMD []
