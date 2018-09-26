FROM alpine:3.8

COPY bin/minibank/ bin/minibank 

CMD ["/bin/minibank"]
