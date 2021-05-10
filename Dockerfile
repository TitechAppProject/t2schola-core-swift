FROM swift:5.3-bionic as build
WORKDIR /build
COPY . .
RUN apt-get -q update && apt-get -q upgrade -y && apt-get install -y libxml2-dev
RUN swift build --build-path /build/.build -c release

FROM swift:5.3-bionic-slim
COPY --from=build /build/.build/release/T2ScholaCoreSwiftRun /usr/bin
ENTRYPOINT ["T2ScholaCoreSwiftRun"]