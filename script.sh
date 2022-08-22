#! /bin/sh
while true; do sudo docker stats --no-stream | sudo tee --append /log/stats.txt; sleep 10; done