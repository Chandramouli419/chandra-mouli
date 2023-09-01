FROM liquibase/liquibase:4.20.0

ARG COMMANDS=""
RUN if [ -z "$COMMANDS" ]; then echo 'Build ARG "COMMANDS" must be specified. It is a semicolon delimited list of Liquibase commands. Exiting.'; exit 1; fi

ARG DATABASE_CONNECTION_STRING=""
RUN if [ -z "$DATABASE_CONNECTION_STRING" ]; then echo 'Build ARG "DATABASE_CONNECTION_STRING" must be specified. Exiting.'; exit 1; fi

ARG DATABASE_USERNAME=""
RUN if [ -z "$DATABASE_USERNAME" ]; then echo 'Build ARG "DATABASE_USERNAME" must be specified. Exiting.'; exit 1; fi

ARG DATABASE_PASSWORD=""
RUN if [ -z "$DATABASE_PASSWORD" ]; then echo 'Build ARG "DATABASE_PASSWORD" must be specified. Exiting.'; exit 1; fi

COPY . /liquibase

RUN echo 'Running liquibase command: $COMMANDS'

RUN echo 'Liquibase changelogs:'
RUN ls -R /liquibase/changelog

SHELL ["/bin/bash", "-c"]
RUN set -e; IFS=';' read -r -a array <<< "${COMMANDS}";                 \
    for comm in "${array[@]}";                                          \
    do                                                                  \
        echo "---------------------------------------------------";     \
        echo "Executing Liquibase command: " $comm;                     \
        liquibase --url="${DATABASE_CONNECTION_STRING}"                 \
                  --defaultsFile=liquibase.properties                   \
                  --username="${DATABASE_USERNAME}"                     \
                  --password="${DATABASE_PASSWORD}"                     \
                  ${comm};                                              \
        echo "---------------------------------------------------";     \
    done     