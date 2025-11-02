#!/bin/bash
# Start Phoenix with environment variables
export DB_USER="admin"
export DB_PASSWORD="thang2001"
export DB_HOST="localhost"
export DB_NAME="left_note"
export DB_PORT="5431"

iex -S mix phx.server