root = "/var/www/dungeon-masters/current"
working_directory root
pid "home/unicorn/pids/unicorn.pid"
stderr_path "home/unicorn/log/unicorn.log"
stdout_path "home/unicorn/log/unicorn.log"

listen "/tmp/unicorn.dungeon-masters.sock"
worker_processes 4
timeout 30