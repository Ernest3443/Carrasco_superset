FROM postgres:12.10

# Add the plpython function to the database
RUN apt-get update && apt-get install --assume-yes postgresql-plpython3-12 cron

# Delete our left over sample_data.sql
RUN mkdir preloaded_data
RUN mkdir preloaded_data/advData

# COPY ALL OF OUR DATA_SHEETS OVER (We copy all of them over since there's no conditional COPY)
COPY ./pg_sample_data/*.sql \
		/preloaded_data/

COPY ./pg_sample_data/random/*.sql \
		/preloaded_data/

#COPY ./pg_sample_data/random/AdventureWorks/*.sql \
#		/preloaded_data/

#COPY ./pg_sample_data/random/AdventureWorks/*.csv \
#		/preloaded_data/advData/


# Retrieve all of the files from the folder
RUN file="$(ls -1 /preloaded_data)" && echo $file
RUN array=$(ls ./preloaded_data -1); for i in ${array}; do cp ./preloaded_data/$i /docker-entrypoint-initdb.d/$i; echo $i; done

## -- Setup my cron job
RUN mkdir /home/postgres
RUN chown postgres /home/postgres

# Copy
COPY ./pg_sample_data/cronscript/loki-insert.sql \
		/home/postgres/loki-insert.sql
COPY ./pg_sample_data/cronscript/loki-cron.sh \
		/home/postgres/loki-cron.sh
COPY ./pg_sample_data/cronscript/postgres-cron \
    /etc/cron.d/postgres-cron

RUN chmod 0744 /home/postgres/loki-cron.sh
RUN chmod 0644 /etc/cron.d/postgres-cron

# Apply cron job
RUN crontab /etc/cron.d/postgres-cron
# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Cleanup
RUN rm -rf /preloaded_data

# Run the cron stuff
#CMD cron && tail -f /var/log/cron.log
