FROM xena/nim:0.19.4 AS build
WORKDIR /surl
COPY . .
RUN yes | nimble build

FROM xena/alpine
COPY --from=build /surl/shorten /usr/local/bin/shorten
COPY --from=build /surl/surl    /usr/local/bin/surl
RUN apk -U add sqlite-libs
VOLUME /data
ENV DATABASE_PATH /data/surl.db
ENV PORT 5000
ENV DOMAIN go.akua
EXPOSE 5000
CMD /usr/local/bin/surl
