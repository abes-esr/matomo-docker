FROM matomo:5.1.2-fpm-alpine

COPY ./cron.txt /etc/crontabs/root
RUN chown root:root /etc/crontabs/root && \
    chmod 600 /etc/crontabs/root
 
