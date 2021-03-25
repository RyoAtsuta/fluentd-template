ps:
	docker ps

# http
http_up:
	docker run --rm -d --name=http_fluentd -p 9880:9880 -v `pwd`/tmp/etc:/fluentd/etc fluent/fluentd:edge-debian -c /fluentd/etc/http.conf

http_logs:
	docker logs -f http_fluentd

http_send:
	curl -X POST -d 'json={"json":"message"}' http://127.0.0.1:9880/sample.test

http_connect:
	docker exec -it http_fluentd sh

# tail_forward
rec_tail_file_up:
	docker run --rm -d --name=rec_tail_file_fluentd --expose 24224 -v `pwd`/tmp/etc:/fluentd/etc -v `pwd`/tmp/log:/tmp/log fluent/fluentd:edge-debian -c /fluentd/etc/receiver_tail_file.conf

sender_tail_file_up:
	docker run --rm -d --name=sender_tail_file_fluentd --link rec_tail_file_fluentd -v `pwd`/tmp/etc:/fluentd/etc -v `pwd`/tmp/log:/tmp/log fluent/fluentd:edge-debian -c /fluentd/etc/sender_tail_file.conf

rec_tail_file_connect:
	docker exec -it rec_tail_file_fluentd sh

sender_tail_file_connect:
	docker exec -it sender_tail_file_fluentd sh

# stdout_file
rec_stdout_file:
	docker run --rm -d --name=rec_stdout_file_fluentd -p 24224:24224 --expose 24224 -v `pwd`/tmp/etc:/fluentd/etc -v `pwd`/tmp/log:/tmp/log fluent/fluentd:edge-debian -c /fluentd/etc/receiver_stdout_file.conf

sender_stdout_file:
	docker run --rm -d --name=sender_stdout_file_fluentd --link rec_stdout_file_fluentd -v `pwd`/tmp/etc:/fluentd/etc -v `pwd`/tmp/log:/tmp/log fluent/fluentd:edge-debian -c /fluentd/etc/sender_stdout_file.conf

rec_stdout_file_connect:
	docker exec -it rec_stdout_file_fluentd sh

sender_stdout_file_connect:
	docker exec -it sender_stdout_file_fluentd sh

stdout_file_sh:
	docker run --rm --log-driver=fluentd -it httpd sh

stop:
	docker stop http_fluentd rec_tail_file_fluentd sender_tail_file_fluentd rec_stdout_file_fluentd sender_stdout_file_fluentd