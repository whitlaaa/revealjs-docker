FROM node:alpine as builder
WORKDIR /public
ENV REVEALJS_VERSION 3.7.0
ADD https://github.com/hakimel/reveal.js/archive/${REVEALJS_VERSION}.tar.gz .
RUN tar --strip-components=1 -xzvf ${REVEALJS_VERSION}.tar.gz && \
    rm ${REVEALJS_VERSION}.tar.gz && \
    yarn
COPY index.html .

FROM nginx:alpine as server
COPY --from=builder /public/ /usr/share/nginx/html/
