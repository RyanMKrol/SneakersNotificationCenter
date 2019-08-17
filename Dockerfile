FROM swift
WORKDIR /app
COPY . ./
RUN apt-get update
RUN echo "y" | apt-get install openssl libssl-dev
RUN git pull
RUN swift package clean
RUN swift package update
RUN swift build -c release
RUN mv `swift build -c release --show-bin-path` /app/bin
CMD /app/bin/SneakersNotificationCenter

