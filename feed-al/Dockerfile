FROM velaco/alpine-r:base-3.5.0-r1

RUN apk --update add postgresql-client && rm -rf /var/cache/apk/*

RUN set -ex && \
    apk update && apk add --no-cache curl tzdata libpq && \    
    apk update

RUN R -e "install.packages(c('optparse'), repos='http://cran.rstudio.com/')"

CMD tail -f /dev/null